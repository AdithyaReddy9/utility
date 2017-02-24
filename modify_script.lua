require 'torch'
require 'nn'
require 'optim'

local dbg = require 'debugger'



local cmd = torch.CmdLine()
cmd:option('-ipfile', 'test_01.lst_bkp') -- necessary
cmd:option('-ratio', 1) -- Neceesary to downsample a video
cmd:option('-seqLength', 16)
cmd:option('-basePath', '/home/adithya/ucf101/UCF-101/')

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
ot = io.open("test_01.lst", "w")

line = ft:read()


while line do

st = mysplit(line, " ")

st1 = mysplit(st[1], "/")
dir = opt.basePath .. st1[7] .. "/" ..  st1[8] .. "/"
stri = dir .. " " .. st[2] .. " " .. st[3]
ot:write(stri)
ot:write('\n')
        
line = ft:read()
end

ot:close()
ft:close()









