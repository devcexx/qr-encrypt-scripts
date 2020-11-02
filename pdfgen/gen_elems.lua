name_suffix = '.sh.name'
qr_suffix = '.sh.pdf'

name_key = "name"
image_key = "image"

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

local function ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

function listdir(directory)
   local elems = io.popen('/bin/ls -a1 ' .. directory):read('all')
   local it = string.gmatch(elems, '[^\n]+')
   return function()
      local n = it()
      if n == nil then
	 return nil
      else
	 return directory .. "/" .. n
      end
   end
end

function gen_latex_entries_row(ents)
   tex.print("\\begin{figure}[H]")
   for key,ent in pairs(ents) do
      tex.print("\\begin{minipage}[b]{\\qrsize}")
      tex.print("  \\centering")
      tex.print("  \\includegraphics[height=\\qrsize]{" .. ent[image_key] .. "}")
      tex.print("  \\caption{\\texttt{" .. ent[name_key] ..  "}}")
      tex.print("\\end{minipage}")
      tex.print("\\hfill")
   end
   tex.print("\\end{figure}")
end

entries = {}
function get_or_create_entry(key)
   local ent = entries[entryid]
   if ent == nil then
      ent = {}
      entries[entryid] = ent
   end

   return ent
end

function message(msg)
   tex.print("\\begin{verbatim}")
   tex.print(msg)
   tex.print("\\end{verbatim}")
end

function table_keys(tbl)
   keys = {}
   for k in pairs(tbl) do table.insert(keys, k) end
   return keys
end


for file in listdir('../build/items') do
   if ends_with(file, name_suffix) then
      entryid = file:sub(1, -#name_suffix - 1)
      ent = get_or_create_entry(entryid)

      local f = io.open(file, "r")
      ent[name_key] = f:read('all')
      f:close()
      
   elseif ends_with(file, qr_suffix) then
      entryid = file:sub(1, -#qr_suffix - 1)
      ent = get_or_create_entry(entryid)
      ent[image_key] = file
   else
      ent = nil
   end
end

entries_keys = table_keys(entries)
table.sort(entries_keys)

next_row = {}
for i, k in pairs(entries_keys) do
   ent = entries[k]
   if ent[name_key] ~= nil and ent[image_key] then
      table.insert(next_row, ent)
      if #next_row >= 2 then
	 gen_latex_entries_row(next_row)
	 next_row = {}
      end
   end
end

if #next_row > 0 then
   gen_latex_entries_row(next_row)
end
