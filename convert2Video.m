function convert2Video(workingDir,vidname)
% workingDir = '/home/shubham/mot_benchmark/Object-tracker/temp/';
imageNames = dir(strcat(workingDir,'*.jpg'));
imageNames = {imageNames.name}';
outputVideo = VideoWriter(strcat(workingDir,vidname));
outputVideo.FrameRate = 10;

open(outputVideo)
for ii = 1:length(imageNames)
        img = imread(strcat(workingDir,imageNames{ii}));
%         imshow(img);
        writeVideo(outputVideo,img);
end
close(outputVideo)

% shuttleAvi = VideoReader(fullfile(workingDir,'trellis.avi'));
% ii = 1;
% while hasFrame(shuttleAvi)
%    mov(ii) = im2frame(readFrame(shuttleAvi));
%    ii = ii+1;
% end
% figure
% imshow(mov(1).cdata, 'Border', 'tight')
% movie(mov,1,shuttleAvi.FrameRate)