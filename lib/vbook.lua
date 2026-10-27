-- Vector Book: Pandoc Lua filter from the Markdown conventions (docs/conventions.md) to Typst calls in lib/vbook.typ.
-- Settings arrive as metadata from the vbook script: vbook-root, vbook-overlays, vbook-dpi, vbook-textwidth, vbook-parse-headings.

local cfg = { root = '.', overlays = {}, dpi = 300, textwidth = 108, parse = false, shift = 0 }

local function ty(inlines)
  local s = pandoc.write(pandoc.Pandoc({ pandoc.Plain(inlines) }), 'typst-citations')
  return (s:gsub('%s+$', ''))
end

local function tyb(blocks)
  local s = pandoc.write(pandoc.Pandoc(blocks), 'typst-citations')
  return (s:gsub('%s+$', ''))
end

local function tystr(s)
  return '"' .. s:gsub('\\', '\\\\'):gsub('"', '\\"') .. '"'
end

local function basename(p) return p:match('([^/]+)$') or p end

local function trim(inl)
  local out = pandoc.Inlines(inl)
  while #out > 0 and (out[1].t == 'Space' or out[1].t == 'SoftBreak') do out:remove(1) end
  while #out > 0 and (out[#out].t == 'Space' or out[#out].t == 'SoftBreak') do out:remove(#out) end
  return out
end

local function strip_notes(inl)
  return pandoc.Inlines(inl):walk({ Note = function() return {} end })
end

-- pixel size of a PNG or JPEG, for sizing figures at the source's resolution
local function imgsize(path)
  local f = io.open(path, 'rb')
  if not f then return nil end
  local d = f:read('a'); f:close()
  if d:sub(1, 8) == '\137PNG\r\n\26\n' then
    return string.unpack('>I4', d, 17), string.unpack('>I4', d, 21)
  end
  if d:sub(1, 2) == '\255\216' then
    local i = 3
    while i + 8 < #d do
      if d:byte(i) ~= 0xFF then
        i = i + 1
      else
        local m = d:byte(i + 1)
        if m >= 0xC0 and m <= 0xCF and m ~= 0xC4 and m ~= 0xC8 and m ~= 0xCC then
          local h, w = string.unpack('>I2>I2', d, i + 5)
          return w, h
        end
        i = i + 2 + string.unpack('>I2', d, i + 2)
      end
    end
  end
  return nil
end

local function figwidth(src, attr)
  local w = attr and attr.attributes and attr.attributes.width
  if w and w:match('^[%d%.]+%a+$') or (w and w:match('^[%d%.]+%%$')) then return w end
  local pw = imgsize(cfg.root .. '/' .. src)
  if pw then
    local mm = pw / cfg.dpi * 25.4
    if mm > cfg.textwidth then mm = cfg.textwidth end
    return string.format('%.1fmm', mm)
  end
  return '70%'
end

local function overlays_for(src, attr)
  if attr and attr.attributes and attr.attributes.overlays == 'no' then return '()' end
  local list = cfg.overlays[basename(src)]
  if not list or #list == 0 then return '()' end
  local parts = {}
  for _, o in ipairs(list) do
    local en = tostring(o.en):gsub('%-\n', ''):gsub('\n', '\\\n')
    local doc = pandoc.read(en, 'markdown')
    local inl = doc.blocks[1] and doc.blocks[1].content or {}
    table.insert(parts, string.format('(x: %s, y: %s, en: [%s], align: %s)',
      tostring(o.x), tostring(o.y), ty(inl), tystr(o.align or 'left')))
  end
  return '(' .. table.concat(parts, ', ') .. ',)'
end

-- split a caption at "Labels:" or "Key:" into the caption proper and the key printed beneath the figure
local function split_caption(inl)
  inl = pandoc.Inlines(inl)
  for i, x in ipairs(inl) do
    if x.t == 'Str' and (x.text == 'Labels:' or x.text == 'Key:') then
      local cap, key = pandoc.Inlines({}), pandoc.Inlines({})
      for j = 1, i - 1 do cap:insert(inl[j]) end
      for j = i, #inl do key:insert(inl[j]) end
      return trim(cap), trim(key)
    end
  end
  return trim(inl), nil
end

local function figure_block(src, attr, cap)
  local args = { '"/' .. src:gsub('^/', ''):gsub('"', '\\"') .. '"', 'width: ' .. figwidth(src, attr) }
  if cap and #cap > 0 then
    local c, key = split_caption(cap)
    table.insert(args, 'caption: [' .. ty(c) .. ']')
    table.insert(args, 'short: [' .. ty(strip_notes(c)) .. ']')
    if key then table.insert(args, 'key: [' .. ty(key) .. ']') end
  end
  table.insert(args, 'overlays: ' .. overlays_for(src, attr))
  return pandoc.RawBlock('typst', '#vfig(' .. table.concat(args, ', ') .. ')')
end

local function figure_image(b)
  if b.t == 'Figure' then
    local img
    b.content:walk({ Image = function(i) img = img or i end })
    return img
  end
  if (b.t == 'Para' or b.t == 'Plain') and #b.content == 1 and b.content[1].t == 'Image' then
    return b.content[1]
  end
end

local function figure_caption(b)
  if b.t ~= 'Figure' then return nil end
  local inl = pandoc.Inlines({})
  for _, blk in ipairs(b.caption.long) do
    if blk.content then inl:extend(blk.content) end
  end
  return inl
end

-- "**Figure N.** ..." in the paragraph after an image is the figure's caption (the Kuki convention)
local function is_caption_para(b)
  return b and b.t == 'Para' and #b.content > 0 and b.content[1].t == 'Strong'
    and pandoc.utils.stringify(b.content[1]):match('^Figure%s+%d+')
end

local function cjk(s)
  for _, c in utf8.codes(s) do
    if c >= 0x3000 and c <= 0x9FFF or c >= 0xF900 and c <= 0xFAFF or c >= 0x20000 then return true end
  end
  return false
end

-- "Chapter 1. Title (原題)" read as number, title and original title, when vbook-parse-headings is set
local function parse_heading(inl)
  inl = pandoc.Inlines(inl)
  local num, orig
  if #inl >= 3 and inl[1].t == 'Str' and inl[3].t == 'Str' and inl[1].text:match('^%u%l+$')
      and inl[3].text:match('^[%dIVXLCA-Z]+%.$') then
    num = inl[1].text .. ' ' .. inl[3].text:sub(1, -2)
    inl = pandoc.Inlines({ table.unpack(inl, 4) })
  end
  for j = #inl, 1, -1 do
    if inl[j].t == 'Str' and inl[j].text:sub(1, 1) == '(' then
      local tail = pandoc.utils.stringify(pandoc.Inlines({ table.unpack(inl, j) }))
      local inner = tail:match('^%((.*)%)$')
      if inner and cjk(inner) then
        orig = inner
        inl = pandoc.Inlines({ table.unpack(inl, 1, j - 1) })
      end
      break
    end
  end
  return trim(inl), num, orig
end

local function chapter(h)
  local title, num, orig = h.content, h.attributes.num, h.attributes.orig
  if cfg.parse and not num and not orig then title, num, orig = parse_heading(title) end
  local args = { '[' .. ty(strip_notes(title)) .. ']' }
  -- a note on the title is set after the title on the opening page, and kept out of the Contents and running heads
  local notes = {}
  pandoc.Inlines(title):walk({ Note = function(n) table.insert(notes, tyb(n.content)) end })
  if #notes > 0 then table.insert(args, 'note: [' .. table.concat(notes, ' ') .. ']') end
  if num then table.insert(args, 'num: [' .. ty(pandoc.Inlines(num)) .. ']') end
  if orig then table.insert(args, 'orig: [' .. ty(pandoc.Inlines(orig)) .. ']') end
  if h.attributes.run then table.insert(args, 'run: [' .. ty(pandoc.Inlines(h.attributes.run)) .. ']') end
  return pandoc.RawBlock('typst', '#chapter(' .. table.concat(args, ', ') .. ')')
end

-- a paragraph holding only page markers: its markers join the next paragraph, so that a marker
-- before a chapter heading is not set on the page before the chapter opens
local function is_marker_para(b)
  if b.t ~= 'Para' and b.t ~= 'Plain' then return false end
  local any = false
  for _, x in ipairs(b.content) do
    if x.t == 'RawInline' and x.format == 'typst' and x.text:match('^#pm%(') then any = true
    elseif x.t ~= 'Space' and x.t ~= 'SoftBreak' then return false end
  end
  return any
end

-- a section break: a paragraph of asterisks or dots alone ("* * *", "· · ·", "⁂"), or a ::: break block
local function is_break_para(b)
  if b.t ~= 'Para' then return false end
  local s = pandoc.utils.stringify(b.content)
  return s:match('%S') ~= nil and utf8.len(s) <= 12 and s:gsub('[%*%s]', ''):gsub('·', ''):gsub('•', ''):gsub('⁂', '') == ''
end

local function section_break(inl)
  if inl and #inl > 0 then return pandoc.RawBlock('typst', '#section-break[' .. ty(inl) .. ']') end
  return pandoc.RawBlock('typst', '#section-break()')
end

-- column widths in proportion to content, so long cells do not crush their neighbours.
-- Widths given in the source are kept unless they are all equal, as Pandoc makes them from equal dash runs.
local function widths(t)
  local n = #t.colspecs
  local first = t.colspecs[1][2]
  for _, cs in ipairs(t.colspecs) do
    if cs[2] and cs[2] > 0 and math.abs(cs[2] - (first or 0)) > 0.001 then return end
  end
  local w = {}
  for i = 1, n do w[i] = 3 end
  local function measure(rows)
    for _, row in ipairs(rows) do
      for i, cell in ipairs(row.cells) do
        if i <= n then
          local s = pandoc.utils.stringify(cell.contents)
          local len = 0
          for _, c in utf8.codes(s) do len = len + ((c >= 0x2E80) and 2 or 1) end
          if len > w[i] then w[i] = len end
        end
      end
    end
  end
  measure(t.head.rows)
  for _, body in ipairs(t.bodies) do measure(body.body) end
  local total = 0
  for i = 1, n do total = total + math.min(w[i], 60) end
  if total <= 70 then return end
  for i = 1, n do t.colspecs[i][2] = math.min(w[i], 60) / total end
  return t
end

return {
  {
    Meta = function(m)
      if m['vbook-root'] then cfg.root = pandoc.utils.stringify(m['vbook-root']) end
      if m['vbook-dpi'] then cfg.dpi = tonumber(pandoc.utils.stringify(m['vbook-dpi'])) end
      if m['vbook-textwidth'] then cfg.textwidth = tonumber(pandoc.utils.stringify(m['vbook-textwidth'])) end
      if m['vbook-shift'] then cfg.shift = tonumber(pandoc.utils.stringify(m['vbook-shift'])) end
      if m['vbook-parse-headings'] then cfg.parse = pandoc.utils.stringify(m['vbook-parse-headings']) == 'true' end
      if m['vbook-overlays'] then
        local f = io.open(pandoc.utils.stringify(m['vbook-overlays']), 'r')
        if f then cfg.overlays = pandoc.json.decode(f:read('a'), false); f:close() end
      end
    end,
  },
  {
    Span = function(s)
      if s.classes:includes('tag') then
        return pandoc.RawInline('typst', '#schemetag[' .. ty(s.content) .. ']')
      end
    end,
    -- shifted here because Pandoc's own --shift-heading-level-by runs after filters; a heading shifted below 1 is dropped
    Header = function(h)
      h.level = h.level + cfg.shift
      if h.level < 1 then return {} end
      if h.level == 1 then return chapter(h) end
      return h
    end,
    Table = widths,
    Div = function(d)
      if d.classes:includes('break') then
        local inl = d.content[1] and d.content[1].content or nil
        return section_break(inl)
      end
      for cls, al in pairs({ right = 'right', centre = 'center', center = 'center' }) do
        if d.classes:includes(cls) then
          local out = pandoc.Blocks({ pandoc.RawBlock('typst', '#align(' .. al .. ')[') })
          out:extend(d.content)
          out:insert(pandoc.RawBlock('typst', ']'))
          return out
        end
      end
      if not d.classes:includes('scheme') then return end
      local head, branches = '[]', {}
      for _, b in ipairs(d.content) do
        if (b.t == 'Para' or b.t == 'Plain') and head == '[]' then
          head = '[' .. ty(b.content) .. ']'
        elseif b.t == 'BulletList' then
          for _, item in ipairs(b.content) do table.insert(branches, '[' .. tyb(item) .. ']') end
        end
      end
      return pandoc.RawBlock('typst', '#scheme(' .. head .. ', (' .. table.concat(branches, ', ') .. ',))')
    end,
  },
  {
    -- top-down, so that a Figure is replaced before its own image is visited
    traverse = 'topdown',
    Blocks = function(blocks)
      local out = pandoc.Blocks({})
      local held = pandoc.Inlines({})   -- page markers standing alone, waiting for the next paragraph
      local i = 1
      while i <= #blocks do
        local b = blocks[i]
        local img = figure_image(b)
        if is_marker_para(b) then
          for _, x in ipairs(b.content) do if x.t == 'RawInline' then held:insert(x) end end
        elseif is_break_para(b) then
          out:insert(section_break(b.content))
        elseif #held > 0 and (b.t == 'Para' or b.t == 'Plain') then
          local inl = pandoc.Inlines({})
          inl:extend(held); inl:extend(b.content)
          b.content = inl
          held = pandoc.Inlines({})
          out:insert(b)
        elseif img then
          local cap = figure_caption(b)
          if is_caption_para(blocks[i + 1]) then
            cap = blocks[i + 1].content
            i = i + 1
          end
          out:insert(figure_block(img.src, img.attr, cap))
        else
          out:insert(b)
        end
        i = i + 1
      end
      if #held > 0 then out:insert(pandoc.Para(held)) end
      return out
    end,
  },
}
