-- drop links (keep text), images, spans and divs; drop the Wikisource licence tables
function Link(l) return l.content end
function Image(i) return {} end
function Span(s) return s.content end
function Div(d) return d.content end
