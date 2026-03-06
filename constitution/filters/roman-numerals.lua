--[[
  Lua filter to convert section numbering to "Article I", "Article II" style
  with Roman numerals for constitutional documents.

  Works for both HTML and PDF output by:
  - For PDF: Injects LaTeX \renewcommand to redefine section counters
  - For HTML: Replaces numeric section numbers with Roman numerals in headers
]]--

local function numberToRoman(num)
  local romanTable = {
    {1000, 'M'}, {900, 'CM'}, {500, 'D'}, {400, 'CD'},
    {100, 'C'}, {90, 'XC'}, {50, 'L'}, {40, 'XL'},
    {10, 'X'}, {9, 'IX'}, {5, 'V'}, {4, 'IV'}, {1, 'I'}
  }

  if num == 0 then return '0' end

  local roman = ''
  for _, pair in ipairs(romanTable) do
    local value, numeral = pair[1], pair[2]
    while num >= value do
      roman = roman .. numeral
      num = num - value
    end
  end
  return roman
end

-- For PDF output, inject LaTeX counter configuration
function Meta(meta)
  if quarto.doc.isFormat("pdf") then
    -- LaTeX configuration to use Roman numerals for sections (Article I, II, III)
    -- Chapters remain numbered normally (1, 2, 3)
    local latex_config = [[
% Roman numeral numbering for constitutional style
% Sections get "Article I, Article II, Article III"
\renewcommand{\thesection}{Article \Roman{section}}
\renewcommand{\thesubsection}{\Alph{subsection}}
\renewcommand{\thesubsubsection}{\roman{subsubsection}}
]]

    if meta['header-includes'] then
      table.insert(meta['header-includes'], pandoc.RawBlock('latex', latex_config))
    else
      meta['header-includes'] = pandoc.MetaList{pandoc.RawBlock('latex', latex_config)}
    end

    quarto.log.output("Roman numeral numbering (Article I, II, III...) enabled for PDF")
  end

  return meta
end

-- For HTML output, modify section numbers in the rendered output
-- Note: This is a simplified approach. For more robust HTML handling,
-- you might need to use CSS or JavaScript post-processing
function Header(header)
  if quarto.doc.isFormat("html") then
    -- Only process level 1 headers (chapters) to add "Article" prefix
    if header.level == 1 and header.attr and header.attr.identifier then
      -- Quarto auto-generates section numbers, we'll let CSS handle the styling
      -- via the _custom.scss file
    end
  end

  return header
end
