require 'torch'
require 'nn'
require 'optim'

local dbg = require 'debugger'



local cmd = torch.CmdLine()
cmd:option('-ipfile', 'testlist01.txt') -- necessary
cmd:option('-ratio', 1) -- Neceesary to downsample a video
cmd:option('-seqLength', 16)
cmd:option('-basePath', '/home/adithya/ucf101/testlist01_videos')

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

videoPath = paths.concat(opt.basePath)
if paths.dirp(videoPath) then

  local count = 0  

  for f in paths.iterdirs(videoPath) do

        st = mysplit(f, '.')
     
	videodir1 = st[1] .. '_tf'
old = paths.concat(videoPath, f)
new = paths.concat(videoPath, videodir1)
  os.rename(old, new)
--	local success, err = paths.mkdir(videodir1)
	
        

	end 	
   end








