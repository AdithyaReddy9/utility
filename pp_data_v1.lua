require 'torch'
require 'nn'
require 'optim'

local dbg = require 'debugger'



local cmd = torch.CmdLine()
cmd:option('-ipfile', 'trainlist01.txt') -- necessary
cmd:option('-ratio', 1) -- Neceesary to downsample a video
cmd:option('-seqLength', 16)
cmd:option('-basePath', '/home/adithya/frames/')

local opt = cmd:parse(arg)

-- Torch cmd parses user input as strings so we need to convert number strings to numbers
for k, v in pairs(opt) do
  if tonumber(v) then
    opt[k] = tonumber(v)
  end
end

function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end


ft = io.open(opt.ipfile, "r")
ot = io.open("train_01.lst", "w")

local line = ft:read()
k = 1
while line do 
st = mysplit(line, " ")

st1 = paths.basename(st[1])
st2 = mysplit(st1, ".")

videoPath = paths.concat(opt.basePath .. st2[1] )

if paths.dirp(videoPath) then
local count = 0  

 for f in paths.iterfiles(videoPath) do
      count = count + 1;
 end
for ct = 1, count-opt.seqLength-1, 1 do 
     if (ct - 1) % opt.seqLength == 0 then

	str = videoPath .. " " .. ct .. " " .. st[2] 	
	ot:write(str)
	ot:write('\n')
	end 	
end

if k % 100 == 0 then	
	print(k)
end

end

k = k + 1;
line = ft:read()
end


ft:close()
ot:close()



