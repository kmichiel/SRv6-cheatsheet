--html
--<div id="lst:example3-1" class="listing">
--<p>Example 3.1: The caption of example 3-1</p>
--<pre><code>RP/0/RP0/CPU0:alibaba-4# §show version§
--Mon Dec 13 13:52:15.206 UTC
--Cisco IOS XR Software, Version 7.4.1.28I
--Copyright (c) 2013-2021 by Cisco Systems, Inc.
--
--Build Information:
-- Built By     : ingunawa
-- Built On     : §Thu Apr 15 00:07:29 PDT 2021§
-- Built Host   : iox-ucs-012
-- Workspace    : /auto/iox-ucs-012-san2/prod/7.4.1.28I.SIT_IMAGE/xrv9k/ws
-- Version      : 7.4.1.28I
-- Location     : /opt/cisco/XR/packages/
-- Label        : 7.4.1.28I-0
--
--cisco IOS-XRv 9000 () processor
--System uptime is 2 days 7 hours 20 minutes</code></pre>
--</div>

if not ( FORMAT:match 'epub' or FORMAT:match 'html' or FORMAT:match 'native') then return nil end

function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

Div = function (div)
--[[
  for k,v in pairs(div.content) do print(k,v) end
  for i, tbl in ipairs(div.content) do
         print(string.format("Table #%d contains: ", i))
         for k,v in pairs(tbl) do
                 print(k,v)

         end
  end
]]--
if #div.content == 2 and div.content[2].tag:match 'CodeBlock' then
      local codeblock =  div.content[2]
      local caption = codeblock.attributes['caption']
      local numbers = 'none'
      if #codeblock.classes >= 1 and codeblock.classes[1] == "numberLines" then
        numbers = 'left'
      end
      local rawtexttable = Split(codeblock.text, "\n")
      local lineno = 1
      local newtable = {}
      for k, v in pairs(rawtexttable) do
	local line = string.gsub( rawtexttable[k], '<', '&lt;')
	line = string.gsub( line, '>', '&gt;')
        -- make marked text bold
        -- .- is the non-greedy variant of .*
	line = string.gsub( line, '§(.-)§', '<strong>%1</strong>')
	--line = string.gsub(line, 'a', '@')
	if numbers == 'left' then
	  -- add linenumbers
	  -- <span class="lineno"> 1</span>
	  line =string.gsub(line, '^', '<span class="lineno">' .. string.format("%2d", lineno) .. '</span>')
	  lineno = lineno + 1
	end
	table.insert(newtable, line)
      end
      table.remove(div.content)
      local t = table.concat(newtable, "\n")
      table.insert( div.content, pandoc.RawBlock('html', '<pre><code>' .. t .. '</code></pre>'))
  end

  return div

end

