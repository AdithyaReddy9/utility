require 'torch'
require 'nn'
require 'optim'
require 'image'
local dbg = require 'debugger'



local cmd = torch.CmdLine()
cmd:option('-ipfile', 'trainlist01.txt') -- necessary
cmd:option('-ratio', 1) -- Neceesary to downsample a video
cmd:option('-seqLength', 16)
cmd:option('-basePath', '/home/adithya/ucf101/')
cmd:option('-imageType', 'png')
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


ft = io.open(opt.ipfile, "r")



local line = ft:read()
local meanImage = torch.Tensor(opt.numChannels, opt.scaledHeight, opt.scaledWidth)

  meanImage[1]:fill(0.39299330663517)
  meanImage[2]:fill(0.37701564553516)
  meanImage[3]:fill(0.34664885463049)

while line do 
st = mysplit(line, " ")

st1 = mysplit(st[1], '/')

fullDumpPath = paths.concat(opt.basePath .. 'trainlist01.txt_preprocessed/')
videoPath = paths.concat(opt.basePath .. 'trainlist01.txt_videos/' .. st1[2] .. '_totalFrames')
if paths.dirp(videoPath) then
local count = 1  
        videodir1 = paths.concat(fullDumpPath, st1[2] .. '_c')
        videodir2 = paths.concat(fullDumpPath, st1[2] .. '_tl')
        videodir3 = paths.concat(fullDumpPath, st1[2] .. '_tr')
        videodir4 = paths.concat(fullDumpPath, st1[2] .. '_bl')
        videodir5 = paths.concat(fullDumpPath, st1[2] .. '_br')

local success, err = paths.mkdir(videodir1)
local success, err = paths.mkdir(videodir2)
local success, err = paths.mkdir(videodir3)
local success, err = paths.mkdir(videodir4)
local success, err = paths.mkdir(videodir5)

 for f in paths.iterfiles(videoPath) do
     framePath = paths.concat(videoPath, f)
      local frame = image.load(framePath, 3, 'double')
	   local refFrame = torch.Tensor(3, 128, 171)
       refFrame = refFrame:type('torch.DoubleTensor')
	frame = image.scale(refFrame, frame)

       
	frame_tl = image.crop(frame, "tl" ,opt.scaledHeight, opt.scaledWidth)
        frame_tr = image.crop(frame, "tr" ,opt.scaledHeight, opt.scaledWidth)
        frame_c = image.crop(frame, "c" ,opt.scaledHeight, opt.scaledWidth)
        frame_bl = image.crop(frame, "bl" ,opt.scaledHeight, opt.scaledWidth)
        frame_br = image.crop(frame, "br" ,opt.scaledHeight, opt.scaledWidth)
	
        image.save(paths.concat(videodir1, 'frame%d.%s' % {count, opt.imageType}), frame_c)
        image.save(paths.concat(videodir2, 'frame%d.%s' % {count, opt.imageType}), frame_tl)
        image.save(paths.concat(videodir3, 'frame%d.%s' % {count, opt.imageType}), frame_tr)
        image.save(paths.concat(videodir4, 'frame%d.%s' % {count, opt.imageType}), frame_bl)
        image.save(paths.concat(videodir5, 'frame%d.%s' % {count, opt.imageType}), frame_br)
count = count +1
	
	end 	

end

line = ft:read()

end


ft:close()



