require 'torch'
require 'nn'
require 'optim'
require 'image'
local dbg = require 'debugger'



local cmd = torch.CmdLine()
cmd:option('-ipfile', 'train_01.lst') -- necessary
cmd:option('-ratio', 1) -- Neceesary to downsample a video
cmd:option('-seqLength', 16)
cmd:option('-basePath', '/home/adithya/frames/')
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

print("executing %s " %{opt.ipfile})
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

fullDumpPath = paths.concat('/home/adithya/ucf101/features/')


ft = io.open(opt.ipfile, "r")
local line = ft:read()

local ct = 0

while line do 

 local st = mysplit(line, " ")

 startFrame = st[2]

 local videoFilename = paths.basename(st[1])
  v1 = mysplit(videoFilename, '.')

 local  videoPath = paths.concat(opt.basePath, v1[1])

if paths.dirp(videoPath) then
        local count = 1  

	local videodir1 = torch.Tensor(16, 3, 112, 112)
	local videodir2 = torch.Tensor(16, 3, 112, 112)
	local videodir3 = torch.Tensor(16, 3, 112, 112)
	local videodir4 = torch.Tensor(16, 3, 112, 112)
	local videodir5 = torch.Tensor(16, 3, 112, 112)
local framePath = paths.concat(videoPath, v1[1] .. '.%04d.' .. 'jpg')

 for i = startFrame + 1, 16 + startFrame , 1  do
      local frame = image.load(framePath % i, 3, 'double')
      
      local refFrame = torch.Tensor(3, 128, 171)
 
        refFrame = refFrame:type('torch.DoubleTensor')
	frame = image.scale(refFrame, frame)

       local flip = math.random(0,1)
   
      if flip == 1 then
         frame = image.hflip(frame)
       end


	frame_tl = image.crop(frame, "tl" ,opt.scaledHeight, opt.scaledWidth)
        frame_tr = image.crop(frame, "tr" ,opt.scaledHeight, opt.scaledWidth)
        frame_c = image.crop(frame, "c" ,opt.scaledHeight, opt.scaledWidth)
        frame_bl = image.crop(frame, "bl" ,opt.scaledHeight, opt.scaledWidth)
        frame_br = image.crop(frame, "br" ,opt.scaledHeight, opt.scaledWidth)
 	videodir1[count] =  frame_tl
 	videodir2[count] =  frame_tr
 	videodir3[count] =  frame_c
 	videodir4[count] =  frame_bl
 	videodir5[count] =  frame_br
	count = count + 1	
  end 	


 videodir1 =  videodir1:reshape(3, 16, 112, 112)
 videodir2 =  videodir2:reshape(3, 16, 112, 112)
 videodir3 =  videodir3:reshape(3, 16, 112, 112)
 videodir4 =  videodir4:reshape(3, 16, 112, 112)
 videodir5 =  videodir5:reshape(3, 16, 112, 112)

torch.save(fullDumpPath ..'/'.. v1[1] .. "-tl-" .. startFrame .. '.t7', videodir1)
torch.save(fullDumpPath .. '/'.. v1[1] .. "-tr-" .. startFrame .. '.t7', videodir2)
torch.save(fullDumpPath ..'/'.. v1[1] .. "-c-" .. startFrame .. '.t7', videodir3)
torch.save(fullDumpPath .. '/'.. v1[1] .. "-bl-" .. startFrame .. '.t7', videodir4)
torch.save(fullDumpPath .. '/'.. v1[1] .. "-br-" .. startFrame .. '.t7', videodir5)

ct = ct + 1;

if ct % 100 == 0 then
print("completed : %d" %{ct}) 
end
end

line = ft:read()

end


ft:close()



