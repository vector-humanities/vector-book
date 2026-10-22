"""Vector Book mark: Leonardo's cube from Pacioli's De divina proportione (1509), opened as a book.

The cube is the book block, drawn as a wireframe in electric blue with visible edges (those bordering a face
turned to the eye) bold and hidden edges thin and pale, by the rule of the Vector Humanities mark
(brand/src/poly.py in the VH kit). Its front face is swung open on the spine edge as a cover, in vermilion,
with two leaves fanning between cover and block.

Levels: 'full' draws every edge; 'front' visible edges only, heavier; 'icon' outlines and cover only, heavier still.
Usage: python3 mark.py <brand dir>
"""
import math, os, sys

DIST = 9.0
AZ, EL = math.radians(24), math.radians(20)      # three-quarter view, a little above
OPEN = math.radians(162)                          # the cover laid open, short of flat
LEAVES = (0.42, 0.72)                             # leaves at these fractions of the opening

V = [(x, y, z) for x in (-1, 1) for y in (-1, 1) for z in (-1, 1)]
E = [(i, j) for i in range(8) for j in range(i + 1, 8) if sum(a != b for a, b in zip(V[i], V[j])) == 1]
F = [((ax, s), [i for i, v in enumerate(V) if v[ax] == s]) for ax in range(3) for s in (-1, 1)]


def rot(p):
    x, y, z = p
    x, z = x * math.cos(AZ) + z * math.sin(AZ), -x * math.sin(AZ) + z * math.cos(AZ)
    y, z = y * math.cos(EL) - z * math.sin(EL), y * math.sin(EL) + z * math.cos(EL)
    return (x, y, z)


def proj(p):
    x, y, z = rot(p)
    return (x * DIST / (DIST + z), -y * DIST / (DIST + z))


def swing(p, a):
    """Turn a point of the front face (z = -1) about the spine, the edge x = -1, z = -1."""
    x, y, z = p
    dx = x + 1
    return (-1 + dx * math.cos(a), y, -1 - dx * math.sin(a))


def geometry():
    R = [rot(v) for v in V]
    count = {e: 0 for e in E}
    for (ax, s), fv in F:
        n = [0, 0, 0]; n[ax] = s
        nr = rot(tuple(n))
        c = [sum(R[q][k] for q in fv) / 4 for k in range(3)]
        if nr[0] * c[0] + nr[1] * c[1] + nr[2] * (c[2] + DIST) < 0:
            for e in E:
                if e[0] in fv and e[1] in fv:
                    count[e] += 1
    vis = [count[e] > 0 for e in E]
    sil = [count[e] == 1 for e in E]
    front = [(-1, -1, -1), (1, -1, -1), (1, 1, -1), (-1, 1, -1)]
    cover = [swing(p, OPEN) for p in front]
    leaves = [[swing(p, OPEN * t) for p in front] for t in LEAVES]
    return R, vis, sil, cover, leaves


def fit(box):
    R, vis, sil, cover, leaves = geometry()
    pts = [proj(v) for v in V] + [proj(p) for p in cover] + [proj(p) for l in leaves for p in l]
    xs = [p[0] for p in pts]; ys = [p[1] for p in pts]
    x0, y0, x1, y1 = box
    sc = min((x1 - x0) / (max(xs) - min(xs)), (y1 - y0) / (max(ys) - min(ys)))
    ox = (x0 + x1) / 2 - (min(xs) + max(xs)) / 2 * sc
    oy = (y0 + y1) / 2 - (min(ys) + max(ys)) / 2 * sc
    T = lambda p: (proj(p)[0] * sc + ox, proj(p)[1] * sc + oy)
    return T, R, vis, sil, cover, leaves


def mix(a, b, t):
    ca = [int(a[i:i + 2], 16) for i in (1, 3, 5)]; cb = [int(b[i:i + 2], 16) for i in (1, 3, 5)]
    return '#' + ''.join(f'{round(x + (y - x) * t):02x}' for x, y in zip(ca, cb))


PALETTES = {
    'paper':    dict(bg='#f6f2e9', beam='#1a1aff', ink='#141518', accent='#ff4a24'),
    'night':    dict(bg='#0c0e1c', beam='#8a90ff', ink='#e8e6f0', accent='#ff6a45'),
    'electric': dict(bg='#1a1aff', beam='#ffffff', ink='#ffffff', accent='#ff6a45'),
}


def level_for(px):
    return 'full' if px >= 80 else 'front' if px >= 28 else 'icon'


def seg(a, b, col, w, cls=None):
    paint = f'class="{cls}"' if cls else f'stroke="{col}"'
    return f'<path d="M{a[0]:.2f},{a[1]:.2f} L{b[0]:.2f},{b[1]:.2f}" {paint} stroke-width="{w:.2f}" stroke-linecap="round"/>'


def quad(ps, col, w, cls=None, fill='none'):
    paint = f'class="{cls}"' if cls else f'stroke="{col}" fill="{fill}"'
    d = 'M' + ' L'.join(f'{p[0]:.2f},{p[1]:.2f}' for p in ps) + ' Z'
    return f'<path d="{d}" {paint} stroke-width="{w:.2f}" stroke-linejoin="round"/>'


def body(c, level='full', px=400, box=(8.0, 8.0, 92.0, 92.0), weight=1.0, cls=False):
    T, R, vis, sil, cover, leaves = fit(box)
    if level == 'icon':
        vis = sil
    u = 100.0 / px
    if level == 'full':
        wf, wb, wc, wl = 1.5 * weight, 0.55 * weight, 1.3 * weight, 0.6 * weight
    elif level == 'front':
        wf, wb, wc, wl = max(3.0, 1.7 * u), None, max(2.6, 1.5 * u), max(1.4, 0.8 * u)
    else:
        wf, wb, wc, wl = max(6.0, 2.0 * u), None, max(5.0, 1.8 * u), None
    back = mix(c['beam'], c['bg'], 0.6)
    leaf = mix(c['accent'], c['bg'], 0.45)
    out = []
    order = sorted(range(len(E)), key=lambda n: -(R[E[n][0]][2] + R[E[n][1]][2]))
    for n in order:
        if not vis[n] and wb:
            out.append(seg(T(V[E[n][0]]), T(V[E[n][1]]), back, wb, 'bh' if cls else None))
    if wl:
        for l in leaves:
            out.append(quad([T(p) for p in l], leaf, wl, 'l' if cls else None))
    for n in order:
        if vis[n]:
            out.append(seg(T(V[E[n][0]]), T(V[E[n][1]]), c['beam'], wf, 'b' if cls else None))
    out.append(quad([T(p) for p in cover], c['accent'], wc, 'a' if cls else None))
    return ''.join(out)


def mark_svg(c, px=400, level=None, bg=True, title='Vector Book'):
    level = level or level_for(px)
    rect = f'<rect width="100" height="100" fill="{c["bg"]}"/>' if bg else ''
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="{px}" height="{px}">'
            f'<title>{title}</title>{rect}{body(c, level, px)}</svg>')


def favicon():
    css = ('<style>.b{stroke:#1a1aff}.a{stroke:#ff4a24;fill:none}'
           '@media (prefers-color-scheme: dark){.b{stroke:#8a90ff}.a{stroke:#ff6a45}}</style>')
    return ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">' + css
            + body(PALETTES['paper'], 'icon', 32, box=(4.0, 4.0, 96.0, 96.0), cls=True) + '</svg>')


def avatar_svg():
    c = PALETTES['paper']
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="1024" height="1024">'
            f'<rect width="100" height="100" fill="{c["bg"]}"/>'
            + body(c, 'full', 1024, box=(14.0, 14.0, 86.0, 86.0), weight=1.5) + '</svg>')


def card_svg():
    """1200 x 630 social card: mark on the left, wordmark on the right, paper ground."""
    c = PALETTES['paper']
    m = body(c, 'full', 1200, box=(6.0, 6.0, 94.0, 94.0), weight=0.9)
    serif = "Cormorant Garamond, EB Garamond, Georgia, serif"
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 630" width="1200" height="630">'
            f'<rect width="1200" height="630" fill="{c["bg"]}"/>'
            f'<g transform="translate(70 75) scale(4.8)">{m}</g>'
            f'<text x="630" y="300" font-family="{serif}" font-weight="600" font-size="62" letter-spacing="9" fill="{c["ink"]}">VECTOR</text>'
            f'<text x="630" y="372" font-family="{serif}" font-weight="600" font-size="62" letter-spacing="9" fill="{c["beam"]}">BOOK</text>'
            f'<text x="633" y="430" font-family="IBM Plex Mono, Menlo, monospace" font-size="19" letter-spacing="3" fill="#5b5d66">A VECTOR HUMANITIES TOOL</text>'
            f'</svg>')


def sheet():
    cells = []
    for name in ('paper', 'night', 'electric'):
        c = PALETTES[name]
        cells.append(f'<div class="c"><div class="t">{name}</div>{mark_svg(c, 300)}'
                     f'<div class="sm">' + ''.join(mark_svg(c, s) for s in (128, 64, 48, 32, 24, 16)) + '</div></div>')
    return ('<!doctype html><meta charset="utf-8"><style>body{margin:0;padding:18px;background:#d8d4ca}'
            '.g{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}.c{background:#fff;border-radius:10px;padding:14px;'
            'display:flex;flex-direction:column;gap:12px;align-items:center}.t{align-self:flex-start;font:12px Menlo,monospace;'
            'letter-spacing:.12em;text-transform:uppercase;color:#555}.sm{display:flex;gap:12px;align-items:flex-end}</style>'
            '<div class="g">' + ''.join(cells) + '</div>')


if __name__ == '__main__':
    BR = sys.argv[1]
    w = lambda p, t: open(os.path.join(BR, p), 'w').write(t)
    for name, c in PALETTES.items():
        for lv in ('full', 'front', 'icon'):
            w(f'mark-{lv}-{name}.svg', mark_svg(c, 400, lv))
    w('favicon.svg', favicon())
    w('avatar.svg', avatar_svg())
    w('social-card.svg', card_svg())
    w('src/sheet.html', sheet())
    print('ok')
