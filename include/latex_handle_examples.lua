-- pandoc produces this:
--\begin{codelisting}
--
--\caption{Verify the uDT4 SID allocation}\label{lst:0085-example11-2}
--
--\begin{verbatim}
--RP/0/RP0/CPU0:PE3# show segment-routing srv6 sid
-- <...>
--\end{verbatim}
--
--\end{codelisting}
--
-- We need this format:
--\begin{SRExample}{SR Policy configuration Node1}{lst:Example-2.1}{none}
--RP/0/RP0/CPU0:PE3# show segment-routing srv6 sid
-- <...>
-- --\end{SRExample}

if not FORMAT:match 'latex' and not FORMAT:match 'native' then return nil end

Div = function (div)
    --print(div)
    -- Div ("",[],[]) [RawBlock (Format "latex") "\\begin{codelisting}",Plain [RawInline (Format "latex") "\\caption",Span ("",[],[]) [Str "The caption of example 3-1"],RawInline (Format "latex") "\\label{lst:example3-1}"],CodeBlock ("",[],[("caption","The caption of example 3-1")]) "RP/0/RP0/CPU0:alibaba-4# \167show version\167\nMon Dec 13 13:52:15.206 UTC\nCisco IOS XR Software, Version 7.4.1.28I\nCopyright (c) 2013-2021 by Cisco Systems, Inc.\n\nBuild Information:\n Built By     : ingunawa\n Built On     : \167Thu Apr 15 00:07:29 PDT 2021\167\n Built Host   : iox-ucs-012\n Workspace    : /auto/iox-ucs-012-san2/prod/7.4.1.28I.SIT_IMAGE/xrv9k/ws\n Version      : 7.4.1.28I\n Location     : /opt/cisco/XR/packages/\n Label        : 7.4.1.28I-0\n\ncisco IOS-XRv 9000 () processor\nSystem uptime is 2 days 7 hours 20 minutes",RawBlock (Format "latex") "\\end{codelisting}"]
    --print(#div.content) -- 4
    --print(div.content[1].tag) -- 'RawBlock' 
    --print(div.content[1].format) -- 'latex' 
    --print(div.content[1].text) -- '\\begin{codelisting}'
    --print(div.content[2].tag) -- 'Plain'
    --print(div.content[2].content[1].tag) -- 'RawInline'
    --print(div.content[2].content[1].format) -- 'latex'
    --print(div.content[2].content[1].text) -- '\\caption'
    --print(div.content[2].content[2].tag) -- 'Span'
    --print(div.content[2].content[2].format) -- 'nil'
    --print(div.content[2].content[2].text) -- 'nil'
    --print(div.content[2].content[3].tag) -- 'RawInline'
    --print(div.content[2].content[3].format) -- 'latex'
    --print(div.content[2].content[3].text) -- '\\label{....}'
    --print(div.content[3].tag) -- 'CodeBlock'
    --print(div.content[4].tag) -- 'RawBlock' 
    --print(div.content[4].format) -- 'latex' 
    --print(div.content[4].text) -- '\\end{codelisting}'

  if #div.content == 4
    and div.content[1].tag:match 'RawBlock' 
    and div.content[1].format:match 'latex' 
    and div.content[1].text:match '\\begin{codelisting}'
    and div.content[2].tag:match 'Plain'
    and div.content[2].content[1].tag:match 'RawInline'
    and div.content[2].content[1].format:match 'latex'
    and div.content[2].content[1].text:match '\\caption'
    and div.content[2].content[3].format:match 'latex'
    and div.content[2].content[3].text:match '\\label'
    and div.content[3].tag:match 'CodeBlock'
    and div.content[4].tag:match 'RawBlock' 
    and div.content[4].format:match 'latex' 
    and div.content[4].text:match '\\end{codelisting}' then
      local codeblock = div.content[3]
      local caption = codeblock.attributes['caption']
      --print(caption)
      local numbers = 'none'
      if #codeblock.classes >= 1 and codeblock.classes[1] == "numberLines" then
        numbers = 'left'
      end
      local label = div.content[2].content[3].text:match("\\label{(.-)}")
      -- Convert the caption from Markdown to LaTeX
      local parsed_caption = pandoc.read(caption, "markdown").blocks[1].content
      local latex_caption = pandoc.write(pandoc.Pandoc({pandoc.Para(parsed_caption)}), "latex"):gsub("\n", " ")
      --print(latex_caption)

      -- replace any § in the codeblock.text by £
      codeblock.text = string.gsub( codeblock.text, '§', '£')
      --\begin{SRExample}{SR Policy configuration Node1}{lst:Example-2.1}{none}
      -- need to add the example text into the block as well, to avoid latex escaping characters
      --\end{SRExample}
      -- Construct the new LaTeX environment
      div.content[1].text = '\\begin{SRExample}{' .. latex_caption .. '}{' .. label .. '}{' .. numbers .. '}\n' .. codeblock.text .. '\n\\end{SRExample}'
      -- remove the other elements
      table.remove(div.content, 4)
      table.remove(div.content, 3)
      table.remove(div.content, 2)
  end

  return div

end

