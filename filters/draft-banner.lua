-- Lua filter to inject draft banner HTML when gpsa_draft metadata is true
function Meta(meta)
  if PANDOC_VERSION < {2, 17} then
    io.stderr:write("Warning: pandoc >=2.17 required for draft banner filter\n")
    return meta
  end

  -- Only process HTML output
  if FORMAT ~= "html" then
    return meta
  end

  -- Check if gpsa_draft is true
  local is_draft = meta.gpsa_draft
  if not is_draft then
    return meta
  end

  -- Add draft banner CSS and JavaScript to header
  local header_html = [[
<meta name="gpsa-draft" content="true">
<style>
#gpsa-draft-banner {
    display: none;
    position: sticky;
    top: 0;
    left: 0;
    right: 0;
    z-index: 9999;
    background: linear-gradient(135deg, #d9242b 0%, #b81e24 100%);
    color: white;
    text-align: center;
    padding: 1rem;
    font-weight: bold;
    font-size: 1.125rem;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    border-bottom: 3px solid #8b1519;
    margin: 0;
}
body[data-gpsa-draft="true"] #gpsa-draft-banner {
    display: block;
}

</style>
<script>
document.addEventListener('DOMContentLoaded', function() {
    document.body.setAttribute('data-gpsa-draft', 'true');
});
</script>
]]

  -- Add banner div before body
  local banner_html = [[
<div id="gpsa-draft-banner">
    ⚠️ DRAFT DOCUMENT ⚠️
</div>
]]

  -- Initialize header-includes if it doesn't exist
  if not meta['header-includes'] then
    meta['header-includes'] = pandoc.MetaList{}
  elseif meta['header-includes'].t ~= 'MetaList' then
    meta['header-includes'] = pandoc.MetaList{meta['header-includes']}
  end

  -- Add header HTML
  table.insert(meta['header-includes'], pandoc.MetaBlocks{pandoc.RawBlock('html', header_html)})

  -- Initialize include-before if it doesn't exist
  if not meta['include-before'] then
    meta['include-before'] = pandoc.MetaList{}
  elseif meta['include-before'].t ~= 'MetaList' then
    meta['include-before'] = pandoc.MetaList{meta['include-before']}
  end

  -- Add banner HTML
  table.insert(meta['include-before'], pandoc.MetaBlocks{pandoc.RawBlock('html', banner_html)})

  return meta
end
