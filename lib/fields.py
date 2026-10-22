# SPDX-License-Identifier: GPL-3.0-or-later
"""Generative fields for the wildcard template: organic regions of black, colour and stipple,
drawn as SVG from a smooth noise field seeded by a text (a chapter title, a book title).

A field is the noise surface cut at three levels: the lowest region takes the colour, the highest
is black with a scatter of white dots, and a thin band between them is stippled. Contours come
from marching squares on the grid, joined into closed loops and smoothed, filled even-odd.
Standard library only.
"""
import hashlib
import math
import random

GRID = (72, 106)          # cells across and down; about the page's proportions
PAD = 3                   # cells computed beyond each edge, so that regions run off the page


def _rng(seed):
    return random.Random(int(hashlib.sha256(seed.encode("utf-8")).hexdigest()[:16], 16))


def _noise(w, h, rng, octaves=((5, 1.0), (9, 0.5), (17, 0.22))):
    """Sum of smoothly interpolated random lattices; values roughly in [0, 1]."""
    field = [[0.0] * (w + 1) for _ in range(h + 1)]
    total = sum(a for _, a in octaves)
    for cells, amp in octaves:
        lw, lh = cells + 2, int(cells * h / w) + 3
        lat = [[rng.random() for _ in range(lw + 1)] for _ in range(lh + 1)]
        for y in range(h + 1):
            fy = y / h * (lh - 2)
            y0 = int(fy); ty = fy - y0; ty = ty * ty * (3 - 2 * ty)
            for x in range(w + 1):
                fx = x / w * (lw - 2)
                x0 = int(fx); tx = fx - x0; tx = tx * tx * (3 - 2 * tx)
                a = lat[y0][x0] + (lat[y0][x0 + 1] - lat[y0][x0]) * tx
                b = lat[y0 + 1][x0] + (lat[y0 + 1][x0 + 1] - lat[y0 + 1][x0]) * tx
                field[y][x] += (a + (b - a) * ty) * amp / total
    return field


def _loops(f, level):
    """Closed contours of f at level, by marching squares. The border is treated as below the level."""
    h, w = len(f) - 1, len(f[0]) - 1
    val = lambda x, y: f[y][x] if 0 < x < w and 0 < y < h else -1.0
    def point(edge):
        (x0, y0), (x1, y1) = edge
        a, b = val(x0, y0), val(x1, y1)
        t = 0.5 if a == b else (level - a) / (b - a)
        return (x0 + (x1 - x0) * t, y0 + (y1 - y0) * t)
    nxt = {}
    for y in range(h):
        for x in range(w):
            c = [(x, y), (x + 1, y), (x + 1, y + 1), (x, y + 1)]
            inside = [val(*p) > level for p in c]
            edges = [(c[i], c[(i + 1) % 4]) for i in range(4) if inside[i] != inside[(i + 1) % 4]]
            if not edges:
                continue
            # pair crossings going round the cell; for the saddle cases this pairs adjacent edges
            k = [e for e in edges]
            if inside[0]:
                k = k[1:] + k[:1]
            for i in range(0, len(k), 2):
                a, b = tuple(sorted(k[i])), tuple(sorted(k[i + 1]))
                nxt.setdefault(a, []).append(b); nxt.setdefault(b, []).append(a)
    loops, seen = [], set()
    for start in list(nxt):
        if start in seen:
            continue
        loop, prev, cur = [], None, start
        while cur not in seen:
            seen.add(cur); loop.append(point(cur))
            options = [n for n in nxt[cur] if n != prev and n not in seen]
            if not options:
                break
            prev, cur = cur, options[0]
        if len(loop) > 5:
            loops.append(loop)
    return loops


def _smooth(loop, rounds=2):
    for _ in range(rounds):
        out = []
        for i, p in enumerate(loop):
            q = loop[(i + 1) % len(loop)]
            out += [(0.75 * p[0] + 0.25 * q[0], 0.75 * p[1] + 0.25 * q[1]),
                    (0.25 * p[0] + 0.75 * q[0], 0.25 * p[1] + 0.75 * q[1])]
        loop = out
    return loop


def _path(loops, sx, sy):
    parts = []
    for loop in loops:
        loop = _smooth(loop)
        parts.append("M" + " L".join(f"{p[0] * sx:.1f},{p[1] * sy:.1f}" for p in loop) + "Z")
    return " ".join(parts)


def luminance(hex_colour):
    """Relative luminance of #rrggbb, 0 (black) to 1 (white)."""
    c = [int(hex_colour[i:i + 2], 16) / 255 for i in (1, 3, 5)]
    c = [v / 12.92 if v <= 0.04045 else ((v + 0.055) / 1.055) ** 2.4 for v in c]
    return 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2]


def field_svg(seed, width=130.0, height=190.0, colour="#bfe6d4", ink="#0d0d0d", paper="#ffffff",
              black=0.58, band=0.035, low=0.42, dots=True, clear=None):
    """An SVG field of the given size in millimetres, deterministic in seed.

    clear = (x0, y0, x1, y1) in millimetres keeps ink out of that zone, with a soft organic edge, so that
    text set there stays readable; a dark colour is kept out of it too."""
    rng = _rng(seed)
    w, h = GRID[0] + 2 * PAD, GRID[1] + 2 * PAD
    f = _noise(w, h, rng)
    lo, hi = min(min(r) for r in f), max(max(r) for r in f)
    f = [[(v - lo) / (hi - lo) for v in r] for r in f]
    sx, sy = width / GRID[0], height / GRID[1]
    ox, oy = PAD * sx, PAD * sy
    W, H = w * sx, h * sy
    fc = f
    if clear:
        x0, y0, x1, y1 = clear
        def weight(gx, gy):
            px, py = gx * sx - ox, gy * sy - oy
            dx = max(x0 - px, 0, px - x1); dy = max(y0 - py, 0, py - y1)
            return math.exp(-((dx * dx + dy * dy) / 49.0))
        wts = [[weight(x, y) for x in range(w + 1)] for y in range(h + 1)]
        f = [[v - 0.75 * wts[y][x] for x, v in enumerate(r)] for y, r in enumerate(f)]
        if colour and luminance(colour) < 0.5:
            fc = [[v + 0.75 * wts[y][x] for x, v in enumerate(r)] for y, r in enumerate(fc)]
    out = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{ox:.2f} {oy:.2f} {width} {height}" width="{width}mm" height="{height}mm">',
           f'<rect width="{W:.1f}" height="{H:.1f}" fill="{paper}"/>']
    if colour:
        # the colour lies where the field is low: everything outside the 'low' contour
        out.append(f'<path d="M0,0 H{W:.1f} V{H:.1f} H0Z {_path(_loops(fc, low), sx, sy)}" fill="{colour}" fill-rule="evenodd"/>')
    band_loops = _loops(f, black - band)
    out.append(f'<path d="{_path(band_loops, sx, sy)}" fill="none" stroke="{ink}" stroke-width="0.35" stroke-dasharray="0.2 0.9" stroke-linecap="round"/>')
    out.append(f'<path d="{_path(_loops(f, black), sx, sy)}" fill="{ink}" fill-rule="evenodd"/>')
    if dots:
        g = _noise(w, h, _rng(seed + "/dots"), octaves=((11, 1.0), (23, 0.5)))
        circles = []
        step = 1.45
        y = oy
        while y < oy + height:
            x = ox + rng.random() * step
            while x < ox + width:
                gx, gy = int(x / sx), int(y / sy)
                if f[gy][gx] > black + 0.03 and g[gy][gx] > 0.52:
                    r = 0.25 + rng.random() * 0.3
                    circles.append(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r:.2f}"/>')
                x += step * (0.7 + rng.random() * 0.6)
            y += step * 0.866
        if circles:
            out.append(f'<g fill="{paper}">' + "".join(circles) + "</g>")
    out.append("</svg>")
    return "".join(out)


if __name__ == "__main__":
    import sys
    sys.stdout.write(field_svg(sys.argv[1] if len(sys.argv) > 1 else "vector"))
