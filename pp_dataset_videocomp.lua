require 'torch'
require 'nn'
require 'optim'
require 'image'
local dbg = require 'debugger'



local cmd = torch.CmdLine()
cmd:option('-ipfile', 'train_01.lst') -- necessary
cmd:option('-ratio', 1) -- Neceesary to downsample a video
cmd:option('-seqLength', 16)
cmd:option('-basePath', '/home/adithya/ucf101_frames_png/')
cmd:option('-imageType', 'png')
cmd:option('-scaledHeight', 112)
cmd:option('-scaledWidth', 112)
cmd:option('-patchWidth', 16)
cmd:option('-patchHeight', 16)

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

fullDumpPath = paths.concat('/home/adithya/ucf101/videoComp/')

local mask = torch.Tensor(opt.numChannels, opt.scaledHeight, opt.scaledWidth)
   mask:fill(1)
  local m = opt.scaledHeight/2
  local n = opt.scaledWidth/2

  for i= m - opt.patchWidth +1, m + opt.patchWidth, 1  do
    for j = n - opt.patchHeight + 1, n + opt.patchHeight, 1 do
        for k = 1, 3 do
         mask[k][j][i] = 0
     end
     end
   end

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

	local videodirf = torch.Tensor(16, 3, 112, 112)
        local videodirp = torch.Tensor(16, 3, 32, 32)
local framePath = paths.concat(videoPath, '%06d.' .. 'png')
 for i = startFrame + 1, 16 + startFrame , 1  do
      local frame = image.load(framePath % i, 3, 'double')
 dbg()     
      local refFrame = torch.Tensor(3, 112, 112)
 
        refFrame = refFrame:type('torch.DoubleTensor')
	frame = image.scale(refFrame, frame)

       local flip = math.random(0,1)
   
      if flip == 1 then
         frame = image.hflip(frame)
       end


        frame_p = image.crop(frame, "c" ,32, 32)
	frame:cmul(mask)
dbg() 
	videodirf[count] =  frame
 	videodirp[count] =  frame_p
	count = count + 1	
  end 	


 videodirf =  videodir1:reshape(3, 16, 112, 112)
 videodirp =  videodir2:reshape(3, 16, 32, 32)

torch.save(fullDumpPath ..'/'.. v1[1] .. "-patch-" .. startFrame .. '.t7', videodirf)
torch.save(fullDumpPath .. '/'.. v1[1] .. "-frame-" .. startFrame .. '.t7', videodirp)

ct = ct + 1;

if ct % 100 == 0 then
print("completed : %d" %{ct}) 
end
end

line = ft:read()

end


ft:close()



