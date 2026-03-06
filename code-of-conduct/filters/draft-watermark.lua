--[[
  Lua filter to add draft watermark to PDF output using custom field

  This filter checks the document metadata for gpsa_draft: true and automatically
  injects a LaTeX watermark package to add "DRAFT" to every page of the PDF.

  Uses a custom field instead of Quarto's native 'draft' to avoid breaking sidebar navigation.
]]--

function Meta(meta)
  -- Only process for PDF output
  if quarto.doc.isFormat("pdf") then
    -- Check if gpsa_draft metadata is set to true
    if meta.gpsa_draft == true then
      -- Add LaTeX packages and watermark configuration
      local header = [[
\usepackage{draftwatermark}
\SetWatermarkText{DRAFT}
\SetWatermarkScale{1.5}
\SetWatermarkColor[gray]{0.85}
\SetWatermarkAngle{55}
]]

      -- Inject into header-includes
      if meta['header-includes'] then
        -- Append to existing header-includes
        table.insert(meta['header-includes'], pandoc.RawBlock('latex', header))
      else
        -- Create new header-includes
        meta['header-includes'] = pandoc.MetaList{pandoc.RawBlock('latex', header)}
      end

      quarto.log.output("GPSA Draft mode enabled - adding watermark to PDF")
    end
  end

  return meta
end
