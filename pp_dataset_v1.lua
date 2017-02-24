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
cmd:option('-imageType', 'png')
cmd:option('-scaledHeight', 112)
cmd:option('-scaledWidth', 112)
cmd:option('-numChannels', 3)
cmd:option('-patchWidth', 16)
cmd:option('-patchHeight', 16)
cmd:option('-start', 1)

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



fullDumpPath1 = paths.concat('/home/adithya/ucf101/featv/')
fullDumpPath2 = paths.concat('/home/adithya/ucf101/featp/')
fullDumpPath3 = paths.concat('/home/adithya/ucf101/video/')


ft = io.open(opt.ipfile, "r")

ct = 0;

for kp = 1, opt.start-1, 1 do
	local line = ft:read()
        ct = ct +1;
end

print("completed : %d before itself" %{ct})


local line = ft:read()

 
while line do 
 local st = mysplit(line, " ")


 local videoFilename = paths.basename(st[1])
 v1 = mysplit(videoFilename, '.')

 local  videoPath = paths.concat(opt.basePath, v1[1])
if paths.dirp(videoPath) then
        local count = 0
 
	 for file in paths.iterfiles(videoPath) do
		count = count +1  
  	end

	local video = torch.Tensor(count, 3, 112, 112)
	local videodir = torch.Tensor(count, 3, 112, 112)
	local patchdir = torch.Tensor(count, 3, 32, 32)
--	local framePath = paths.concat(videoPath, '%06d.' .. 'png')	
       local framePath = paths.concat(videoPath, v1[1] .. '.%04d.' .. 'jpg')



 for r = 1 , count, 1  do
      local frame = image.load(framePath % i, 3, 'double')
      
      local refFrame = torch.Tensor(3, 112, 112)
 
      refFrame = refFrame:type('torch.DoubleTensor')
      frame = image.scale(refFrame, frame)

       local flip = math.random(0,1)
   
      if flip == 1 then
         frame = image.hflip(frame)
       end

       frame_p = image.crop(frame, "c" , 2 *opt.patchHeight, 2*opt.patchWidth)

       act_frame = frame
       video[r] = act_frame
      videodir[r] =  frame:cmul(mask)
      patchdir[r] = frame_p

 end 	


--videodir =  videodir:reshape(3, count, 112, 112)
--patchdir = patchdir:reshape(3, count, 32, 32)
torch.save(fullDumpPath1 ..'/'.. v1[1]  .. '.t7', videodir)
torch.save(fullDumpPath2 ..'/'.. v1[1]  .. '.t7', patchdir)
torch.save(fullDumpPath3 ..'/'.. v1[1]  .. '.t7', video)

ct = ct + 1;

 if ct % 20 == 0 then
   print("completed : %d" %{ct}) 
 end
end

line = ft:read()

end


ft:close()



