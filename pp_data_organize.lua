require 'torch'
require 'nn'
require 'optim'
require 'image'
local dbg = require 'debugger'



local cmd = torch.CmdLine()
cmd:option('-ipfile', 'trainlist01.txt') -- necessary
cmd:option('-ratio', 1) -- Neceesary to downsample a video
cmd:option('-seqLength', 16)
cmd:option('-basePath', '/home/adithya/frames/')
cmd:option('-imageType', 'jpg')
cmd:option('-scaledHeight', 112)
cmd:option('-scaledWidth', 112)
cmd:option('-numChannels', 3)

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




fullDumpPath = paths.concat(opt.basePath)
fullDumpPath1 = "/home/adithya/ucf101_frames/"

for dir in paths.iterdirs(fullDumpPath) do
      maindir = paths.concat(opt.basePath, dir)
      newvideodir = paths.concat(fullDumpPath1, dir)
	local success, err = paths.mkdir(newvideodir)

	for f in paths.iterfiles(maindir) do
	st = mysplit(f, ".")

	oldvideodir = paths.concat(fullDumpPath, dir, f)	

	if success then
	newfile = newvideodir .. "/"  .. "00" .. st[2] .. ".jpg"
		file.copy(oldvideodir, newfile)
	end

	end
end


