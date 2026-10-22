# SPDX-License-Identifier: GPL-3.0-or-later
"""Vector-space imagery for the vectors template: streamlines, arrow fields, tensor glyphs, warped
coordinate grids and point clouds with basis vectors, drawn as SVG from one flow field per page.

The flow is the curl of a smooth noise stream function, with a few vortices and sources added at
seeded positions. Each page draws two or three layers from it, chosen by the seed. A clear zone keeps
the imagery out from behind type. Standard library only.
"""
import hashlib
import math
import random

from fields import _noise, _rng, luminance

PALETTES = {
    "electric": {"ground": "#f6f2e9", "ink": "#141518", "colours": ["#1a1aff", "#ff4a24", "#e9a31c"]},
    "night": {"ground": "#0c0e1c", "ink": "#e8e6f0", "colours": ["#5ee6ff", "#ff5ec4", "#ffd23f"]},
    "blueprint": {"ground": "#123286", "ink": "#e3ebff", "colours": ["#ffffff", "#7fd1ff", "#ffcc4d"]},
    "garden": {"ground": "#f4f1e8", "ink": "#1d2b24", "colours": ["#1f8a70", "#ff7a1a", "#6b2d5c"]},
    "spectrum": {"ground": "#ffffff", "ink": "#111111", "colours": ["#3b28cc", "#00a6a6", "#f2a900", "#e4572e"]},
}

SUB = str.maketrans("0123456789", "₀₁₂₃₄₅₆₇₈₉")


class Flow:
    """Velocity from a noise stream function plus point vortices and sources, on a page of w × h mm."""

    def __init__(self, rng, w, h):
        self.w, self.h = w, h
        self.gw, self.gh = 40, int(40 * h / w)
        self.psi = _noise(self.gw, self.gh, rng, octaves=((3, 1.0), (6, 0.45), (11, 0.15)))
        self.singular = [(rng.uniform(0.1, 0.9) * w, rng.uniform(0.1, 0.9) * h,
                          rng.choice((-1, 1)) * rng.uniform(250, 700), rng.random() < 0.3)
                         for _ in range(rng.randint(1, 4))]

    def _psi(self, x, y):
        fx = min(max(x / self.w * self.gw, 0), self.gw - 1.001)
        fy = min(max(y / self.h * self.gh, 0), self.gh - 1.001)
        x0, y0 = int(fx), int(fy); tx, ty = fx - x0, fy - y0
        p = self.psi
        a = p[y0][x0] + (p[y0][x0 + 1] - p[y0][x0]) * tx
        b = p[y0 + 1][x0] + (p[y0 + 1][x0 + 1] - p[y0 + 1][x0]) * tx
        return a + (b - a) * ty

    def v(self, x, y):
        e = 0.6
        u = (self._psi(x, y + e) - self._psi(x, y - e)) / (2 * e) * 900
        w = -(self._psi(x + e, y) - self._psi(x - e, y)) / (2 * e) * 900
        for sx, sy, k, source in self.singular:
            dx, dy = x - sx, y - sy
            r2 = dx * dx + dy * dy + 30
            if source:
                u += k * dx / r2 * 0.5; w += k * dy / r2 * 0.5
            else:
                u += -k * dy / r2; w += k * dx / r2
        return u, w

    def jacobian(self, x, y, e=1.0):
        u1, w1 = self.v(x + e, y); u0, w0 = self.v(x - e, y)
        u3, w3 = self.v(x, y + e); u2, w2 = self.v(x, y - e)
        return ((u1 - u0) / (2 * e), (u3 - u2) / (2 * e), (w1 - w0) / (2 * e), (w3 - w2) / (2 * e))


class Canvas:
    def __init__(self, w, h, ground, clear):
        self.w, self.h = w, h
        self.parts = [f'<rect x="-5" y="-5" width="{w + 10}" height="{h + 10}" fill="{ground}"/>']
        self.clear = clear

    def blocked(self, x, y, margin=4.0):
        if not self.clear:
            return False
        x0, y0, x1, y1 = self.clear
        return x0 - margin < x < x1 + margin and y0 - margin < y < y1 + margin

    def add(self, s):
        self.parts.append(s)


def _arrowhead(x, y, ang, size, colour):
    l = (x - size * math.cos(ang - 0.45), y - size * math.sin(ang - 0.45))
    r = (x - size * math.cos(ang + 0.45), y - size * math.sin(ang + 0.45))
    return f'<path d="M{x:.2f},{y:.2f} L{l[0]:.2f},{l[1]:.2f} L{r[0]:.2f},{r[1]:.2f}Z" fill="{colour}"/>'


def streamlines(cv, flow, rng, pal, n=170):
    for _ in range(n):
        x, y = rng.uniform(-5, cv.w + 5), rng.uniform(-5, cv.h + 5)
        if cv.blocked(x, y):
            continue
        pts = [(x, y)]
        direction = rng.choice((1, -1))
        for _ in range(rng.randint(30, 110)):
            u, w = flow.v(x, y)
            m = math.hypot(u, w) or 1
            x2, y2 = x + direction * u / m * 0.9, y + direction * w / m * 0.9
            u2, w2 = flow.v(x2, y2)
            m2 = math.hypot(u2, w2) or 1
            x, y = x + direction * (u / m + u2 / m2) * 0.45, y + direction * (w / m + w2 / m2) * 0.45
            if cv.blocked(x, y) or not (-8 < x < cv.w + 8 and -8 < y < cv.h + 8):
                break
            pts.append((x, y))
        if len(pts) < 8:
            continue
        col = rng.choice(pal["colours"])
        sw = rng.choice((0.25, 0.35, 0.5, 0.8))
        d = "M" + " L".join(f"{a:.2f},{b:.2f}" for a, b in pts)
        cv.add(f'<path d="{d}" fill="none" stroke="{col}" stroke-width="{sw}" stroke-linecap="round" stroke-opacity="0.9"/>')
        if rng.random() < 0.35:
            (ax, ay), (bx, by) = pts[-2], pts[-1]
            cv.add(_arrowhead(bx, by, math.atan2(by - ay, bx - ax), 1.6 + sw * 1.5, col))


def quiver(cv, flow, rng, pal, step=None):
    step = step or rng.choice((5.5, 7.0, 8.5))
    col = pal["ink"]
    y = step / 2
    out = []
    while y < cv.h:
        x = step / 2
        while x < cv.w:
            if not cv.blocked(x, y):
                u, w = flow.v(x, y)
                m = math.hypot(u, w)
                if m > 1e-6:
                    L = min(step * 0.85, 1.2 + m * 0.012 * step)
                    a = math.atan2(w, u)
                    x0, y0 = x - math.cos(a) * L / 2, y - math.sin(a) * L / 2
                    x1, y1 = x + math.cos(a) * L / 2, y + math.sin(a) * L / 2
                    out.append(f'<path d="M{x0:.2f},{y0:.2f} L{x1:.2f},{y1:.2f}" stroke="{col}" stroke-width="0.32"/>')
                    out.append(_arrowhead(x1, y1, a, 1.0, col))
            x += step
        y += step
    cv.add('<g stroke-linecap="round">' + "".join(out) + "</g>")


def tensors(cv, flow, rng, pal, step=None):
    """Glyphs for a tensor field: ellipses along the flow, long where it is fast, narrow where it turns
    little and round where it rotates (the vorticity), as in diffusion-tensor imaging."""
    step = step or rng.choice((8.0, 10.0, 12.0))
    col = rng.choice(pal["colours"])
    cells = []
    y = step / 2
    while y < cv.h:
        x = step / 2 + (step / 2 if int(y / step) % 2 else 0)
        while x < cv.w:
            if not cv.blocked(x, y):
                u, w = flow.v(x, y)
                a, b, c, d = flow.jacobian(x, y)
                cells.append((x, y, math.hypot(u, w), abs(c - b), math.atan2(w, u)))
            x += step
        y += step
    if not cells:
        return
    mmax = max(m for _, _, m, _, _ in cells) or 1
    cmax = sorted(r for _, _, _, r, _ in cells)[int(len(cells) * 0.9)] or 1
    out = []
    for x, y, m, rot, ang in cells:
        rx = step * 0.5 * (0.3 + 0.7 * m / mmax)
        ry = rx * (0.18 + 0.62 * min(rot / cmax, 1))
        out.append(f'<ellipse cx="{x:.2f}" cy="{y:.2f}" rx="{rx:.2f}" ry="{ry:.2f}" '
                   f'transform="rotate({math.degrees(ang):.1f} {x:.2f} {y:.2f})"/>')
    cv.add(f'<g fill="{col}" fill-opacity="0.5" stroke="{pal["ink"]}" stroke-width="0.2">' + "".join(out) + "</g>")


def grid(cv, flow, rng, pal):
    """A coordinate grid carried along the flow: a vector space bent into a manifold."""
    step = rng.choice((6.0, 8.0, 10.0))
    amp = rng.uniform(0.015, 0.03)
    col = pal["ink"]
    paths = []
    def warp(x, y):
        u, w = flow.v(x, y)
        return x + u * amp, y + w * amp
    for horizontal in (True, False):
        n = int((cv.h if horizontal else cv.w) / step) + 2
        for i in range(-1, n):
            pts = []
            t = -6.0
            while t < (cv.w if horizontal else cv.h) + 6:
                x, y = (t, i * step) if horizontal else (i * step, t)
                X, Y = warp(x, y)
                if cv.blocked(X, Y, margin=2):
                    if len(pts) > 1:
                        paths.append(pts)
                    pts = []
                else:
                    pts.append((X, Y))
                t += 1.5
            if len(pts) > 1:
                paths.append(pts)
    d = " ".join("M" + " L".join(f"{a:.2f},{b:.2f}" for a, b in p) for p in paths)
    cv.add(f'<path d="{d}" fill="none" stroke="{col}" stroke-width="0.18" stroke-opacity="0.55"/>')


def embedding(cv, flow, rng, pal):
    """Point clouds in clusters, with an origin and two labelled basis vectors."""
    out = []
    for c in range(rng.randint(3, 5)):
        cx, cy = rng.uniform(0.15, 0.85) * cv.w, rng.uniform(0.15, 0.85) * cv.h
        sx, sy = rng.uniform(4, 12), rng.uniform(4, 12)
        col = pal["colours"][c % len(pal["colours"])]
        for _ in range(rng.randint(60, 140)):
            x, y = rng.gauss(cx, sx), rng.gauss(cy, sy)
            if 0 < x < cv.w and 0 < y < cv.h and not cv.blocked(x, y):
                out.append(f'<circle cx="{x:.2f}" cy="{y:.2f}" r="{rng.uniform(0.35, 0.8):.2f}" fill="{col}"/>')
    cv.add("<g>" + "".join(out) + "</g>")
    for _ in range(20):
        ox, oy = rng.uniform(0.2, 0.7) * cv.w, rng.uniform(0.3, 0.85) * cv.h
        if not cv.blocked(ox, oy, margin=30):
            break
    else:
        return
    ink = pal["ink"]
    a = rng.uniform(-0.6, 0.2)
    for i, (ang, L) in enumerate(((a, rng.uniform(22, 34)), (a - math.pi / 2 + rng.uniform(-0.25, 0.25), rng.uniform(18, 28)))):
        x1, y1 = ox + math.cos(ang) * L, oy + math.sin(ang) * L
        cv.add(f'<path d="M{ox:.2f},{oy:.2f} L{x1:.2f},{y1:.2f}" stroke="{ink}" stroke-width="0.6"/>')
        cv.add(_arrowhead(x1, y1, ang, 2.4, ink))
        cv.add(f'<text x="{x1 + 1.5:.2f}" y="{y1 - 1.2:.2f}" font-family="IBM Plex Mono" font-size="4" fill="{ink}">e{str(i + 1).translate(SUB)}</text>')
    cv.add(f'<circle cx="{ox:.2f}" cy="{oy:.2f}" r="0.9" fill="{ink}"/>')
    vx, vy = ox + rng.uniform(15, 35), oy - rng.uniform(15, 30)
    cv.add(f'<path d="M{ox:.2f},{oy:.2f} L{vx:.2f},{vy:.2f}" stroke="{pal["colours"][0]}" stroke-width="0.7" stroke-dasharray="1.2 0.8"/>')
    cv.add(_arrowhead(vx, vy, math.atan2(vy - oy, vx - ox), 2.2, pal["colours"][0]))
    cv.add(f'<text x="{vx + 1.5:.2f}" y="{vy:.2f}" font-family="IBM Plex Mono" font-size="4" font-style="italic" fill="{ink}">v</text>')


LAYERS = {"streamlines": streamlines, "quiver": quiver, "tensors": tensors, "grid": grid, "embedding": embedding}
COMPOSITIONS = [
    ("grid", "streamlines"),
    ("streamlines", "quiver"),
    ("grid", "tensors", "embedding"),
    ("quiver", "tensors"),
    ("grid", "streamlines", "embedding"),
    ("streamlines", "tensors"),
    ("grid", "quiver", "embedding"),
]


def vector_svg(seed, width=140.0, height=216.0, palette=None, inverse=False, clear=None, layers=None):
    """An SVG page of vector-space imagery, deterministic in seed. inverse swaps ground and ink."""
    pal = dict(palette or PALETTES["electric"])
    if inverse:
        pal["ground"], pal["ink"] = pal["ink"], pal["ground"]
    rng = _rng(seed)
    flow = Flow(rng, width, height)
    cv = Canvas(width, height, pal["ground"], clear)
    for name in layers or rng.choice(COMPOSITIONS):
        LAYERS[name](cv, flow, rng, pal)
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} {height}" width="{width}mm" height="{height}mm">'
            + "".join(cv.parts) + "</svg>")


if __name__ == "__main__":
    import sys
    sys.stdout.write(vector_svg(sys.argv[1] if len(sys.argv) > 1 else "vector",
                                palette=PALETTES[sys.argv[2]] if len(sys.argv) > 2 else None))
