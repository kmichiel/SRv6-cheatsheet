-- usage:
-- add in .tex file: \directlua{require('hyphenateall')}

function hyphenate_always(head, tail)
   local n = head
   while n do
      if node.type(n.id) == 'glyph' and n.char == string.byte('-') then
         -- Check for "--" and "---" and skip them
         local next1 = n.next
         local next2 = next1 and next1.next or nil
         if next1 and node.type(next1.id) == 'glyph' and next1.char == string.byte('-') then
            -- Skip "--" and "---"
            if next2 and node.type(next2.id) == 'glyph' and next2.char == string.byte('-') then
               n = next2.next
            else
               n = next1.next
            end
         else
            -- Insert an infinite penalty before, and a zero-width glue node after, the hyphen.
            -- Like writing "\nobreak-\hspace{0pt}" or equivalently "\penalty10000-\hskip0pt"
            local p = node.new(node.id('penalty'))
            p.penalty = 10000
            head, p = node.insert_before(head, n, p)
            local g = node.new(node.id('glue'))
            head, g = node.insert_after(head, n, g)
            n = g
         end
      else
         n = n.next
      end
   end
   lang.hyphenate(head, tail)
end

luatexbase.add_to_callback('hyphenate', hyphenate_always, 'Hyphenate even words containing hyphens')

