-- prepend "Appendix " before the (level-1) chapter number if the header has class attribute .appendix
-- this lust only be applied to produce epub file
function Header(el)
  -- Check if it's a level 1 header and has the class "appendix"
  if el.level == 1 and el.classes:includes("appendix") then
    -- Prepend "Appendix" to the header number
    table.insert(el.content, 1, pandoc.Str("Appendix "))
  end
  return el
end

