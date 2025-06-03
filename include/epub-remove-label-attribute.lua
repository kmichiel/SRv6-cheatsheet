-- remove the label attribute that was added for the appendix numbering
function Header(el)
  -- Check if the Header has attributes
  if el.attr and el.attr.attributes then
    -- Remove the 'label' attribute if it exists
    el.attr.attributes["label"] = nil
  end
  return el
end

