require 'torch'
require 'nn'
require 'optim'

local dbg = require 'debugger'



local cmd = torch.CmdLine()
cmd:option('-ipfile', 'trainlist01.txt') -- necessary
cmd:option('-ratio', 1) -- Neceesary to downsample a video
cmd:option('-seqLength', 16)
cmd:option('-basePath', '/home/adithya/ucf101/UCF-101/')

local opt = cmd:parse(arg)

-- Torch cmd parses user input as linengs so we need to convert number strings to numbers
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
        for str in lineng.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end


ft = io.open(opt.ipfile, "r")


ot1 = io.open("trainlist01_comp1.txt", "w")
ot2 = io.open("trainlist01_comp2.txt", "w")
ot3 = io.open("trainlist01_comp3.txt", "w")

line = ft:read()
ct = 0

while line do

if ct % 3 == 0 then
ot3:write(line)
ot3:write('\n')
elseif ct % 3 == 1 then
ot1:write(line)
ot1:write('\n')
elseif ct % 3 == 2 then
ot2:write(line)
ot2:write('\n')
end
line = ft:read()
ct = ct + 1;
end




ot1:close()
ot2:close()
ot3:close()
ft:close()









