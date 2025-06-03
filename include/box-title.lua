Div = function (div)
  local defTitle = ''
  local env = div.classes[1]
  local begin_str = ''
  -- if the div has no class, the object is left unchanged
  if not env then return nil end
  if env == 'ReminderBox' then defTitle = 'Reminder' end
  if env == 'HighlightBox' then defTitle = 'Highlight' end
  if env == 'OpinionBox' then defTitle = 'Opinion' end
  if env == 'SummaryBox' then defTitle = 'Summary' end
  if defTitle == '' then return nil end

  local author = div.attributes['author']
  local title = div.attributes['title']
  -- escape any "&"s in title and author
  -- issue: epub output showed \& in author name/title
  --  skip escaping & if format is not latex
  if FORMAT:match 'latex' then
    if author then author = author:gsub("&", "\\&") end
    if title then title = title:gsub("&", "\\&") end
  end

  if FORMAT:match 'latex' then
    -- translate "Box" names to "SR" names as used in SR_book template
    if env == 'ReminderBox' then env = 'SRReminder' end
    if env == 'HighlightBox' then env = 'SRHighlight' end
    if env == 'OpinionBox' then env = 'SROpinion' end
    if env == 'SummaryBox' then env = 'SRSummary' end

    begin_str = "\\begin{" .. env .. "}{" .. (title or defTitle) .. "}"
    -- don't forget to use "SR" name here
    if env == 'SROpinion' then begin_str = begin_str .. "{" .. author .. "}" end
    begin_str = begin_str .. "{}"

    -- insert element in front
    table.insert(
      div.content, 1,
      pandoc.RawBlock("latex", begin_str))
    -- insert element at the back
    table.insert(
      div.content,
      pandoc.RawBlock("latex", "\\end{" .. env .. "}"))
  else -- format is not latex
    -- insert title before content
    --local span = pandoc.Span(pandoc.Strong(title), {class = 'title'})
    local span = pandoc.Span((title or defTitle), {class = 'title'})
    table.insert(
      div.content, 1,
      -- make this a span
      pandoc.Para(span)
    )
    div.attributes['title'] = nil
  
    -- insert author after content
    if author then
      --local span = pandoc.Span(pandoc.Strong(author), {class = 'author'})
      local span = pandoc.Span(author, {class = 'author'})
      table.insert(
        div.content,
        -- make this a span
        pandoc.Para(span)
      )
      div.attributes['author'] = nil
    end
  end

  return div
end

