--latex
----\SRFigureScaled{Disjoint paths}{fig:Figure-1.1}{figures_grey/figure1-1.png}{htbp}{0.56}
----\SRFigure{DC Inter-Connect with SLA and without inter-domain BGP}{fig:Figure-1.5}{figures_grey/figure1-5.png}{htbp}

if not FORMAT:match 'latex' and not FORMAT:match 'native' then return nil end

-- determine if a value is within a list
function isInList(list, value)
    for i, v in ipairs(list) do
        if v == value then
            return true
        end
    end
    return false
end

Figure = function (figure)
    -- the new format consists of 
    -- Figure -> Plain -> Image
    -- tag is in Figure (figure.identifier)
    -- caption and file src are both in Image (figure.content[1].content[1].caption and figure.content[1].content[1].src)
    --print(figure) -- Figure ("fig:figure3-2xx",[],[]) (Caption Nothing [Plain [Str "Some",Space,Str "text",Space,Str "describing",Space,Str "this",Space,Str "figure",Space,Str "inside",Space,Str "a",Space,Str "reminder",Space,Str "box"]]) [Plain [Image ("",["inline"],[]) [Str "Some",Space,Str "text",Space,Str "describing",Space,Str "this",Space,Str "figure",Space,Str "inside",Space,Str "a",Space,Str "reminder",Space,Str "box"] ("images/image3-2.png","")]]
    --print(#figure.content) -- 1
    --print(figure.tag) -- Figure
    --print(#figure.content[1].content) -- 1
    --print(figure.content[1].content[1].tag) -- Image
    --print(figure.identifier) -- fig:figure3-2xx
    --print(figure.content[1].content[1].src) -- images/image3-2.png
    --print(figure.content[1].content[1].caption) -- [Str "Some",Space,Str "text",Space,Str "describing",Space,Str "this",Space,Str "figure",Space,Str "inside",Space,Str "a",Space,Str "reminder",Space,Str "box"]
    --print(figure.content[1].content[1]) -- Image ("",["inline"],[]) [Str "Some",Space,Str "text",Space,Str "describing",Space,Str "this",Space,Str "figure",Space,Str "inside",Space,Str "a",Space,Str "reminder",Space,Str "box"] ("images/image3-2.png","")

    --for k,v in pairs(figure.content[1].content[1]) do print(k,v) end
      --[[
          attr    ("",["inline"],[])
          caption [Str "Some",Space,Str "text",Space,Str "describing",Space,Str "this",Space,Str "figure",Space,Str "inside",Space,Str "a",Space,Str "reminder",Space,Str "box"]
          src     images/image3-2.png
          tag     Image
          title
          clone   function: 0xdcea920
          walk    function: 0xdcead90
      ]]--

      --for k,v in pairs(figure.content[1].content[1].attr) do print(k,v) end
      --[[
        attributes      []
        classes List {inline}
        identifier
        tag     Attr
        clone   function: 0xf0c4c90
      ]]--

      --print(figure.content[1].content[1].attr.classes) -- List {inline}

      --print(figure.content[1].content[1].attr.attributes) -- [("scale","44%")]

    --  if #codeblock.classes >= 1 and codeblock.classes[1] == "numberLines" then
    --    numbers = 'left'
    --  end
    --
    if #figure.content == 1 and figure.tag:match 'Figure' then
        if #figure.content[1].content == 1 and figure.content[1].content[1].tag:match 'Image' then
            local tag = figure.identifier
            local fileloc = figure.content[1].content[1].src
            --print(figure.content[1].content[1].caption)
            --local caption = pandoc.utils.stringify(figure.content[1].content[1].caption)
            local caption = figure.content[1].content[1].caption
            --print(caption)
            --local parsed_caption = pandoc.read(caption, "markdown").blocks[1].content
            --print(parsed_caption)
            --local latex_caption = pandoc.write(pandoc.Pandoc({pandoc.Para(parsed_caption)}), "latex")
            local latex_caption = pandoc.write(pandoc.Pandoc({pandoc.Para(caption)}), "latex"):gsub("\n", " ")
            --print(latex_caption)
            -- types of images:
            -- \newcommand{\SRFigure}[4]{%  caption, label, full filename path, float positioning
            -- \newcommand{\SRFigureScaled}[5]{% caption, label, full filename path, float positioning, scale
            -- \newcommand{\SRFigureSW}[4]{%  caption, label, full filename path, float positioning
            -- \newcommand{\SRFigureSWScaled}[5]{% caption, label, full filename path, float positioning, scale
            -- \newcommand{\SRFigureInline}[4]{% caption, label, full filename path, float positioning
            -- \newcommand{\SRFigureInlineScaled}[5]{% caption, label, full filename path, float positioning, scale
            --
            local srfigure = '\\SRFigure'
            -- inline (non-floating) image
            if isInList(figure.content[1].content[1].attr.classes, 'inline') then
              srfigure = '\\SRFigureInline'
            end
            -- landscape image
            if isInList(figure.content[1].content[1].attr.classes, 'landscape') then
              srfigure = '\\SRFigureSW'
            end
            -- scale image
            if figure.content[1].content[1].attr.attributes.scale then
              srfigure = srfigure .. 'Scaled'
              local scale = figure.content[1].content[1].attr.attributes.scale
              -- instead of the Figure, return a raw latex block
              return pandoc.RawBlock('latex',srfigure .. '{' .. latex_caption .. '}{' .. tag .. '}{' .. fileloc .. '}{htbp}{' .. scale .. '}')
            end
            -- instead of the Figure, return a raw latex block
            return pandoc.RawBlock('latex',srfigure .. '{' .. latex_caption .. '}{' .. tag .. '}{' .. fileloc .. '}{htbp}')
        end
    end
end

--[[
  for k,v in pairs(div.content) do print(k,v) end
  for i, tbl in ipairs(div.content) do
         print(string.format("Table #%d contains: ", i))
         for k,v in pairs(tbl) do
                 print(k,v)
         end
  end
]]--

