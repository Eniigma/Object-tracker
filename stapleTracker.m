function [results] = stapleTracker(img_path, img_files, initial_frame, bbox)   %% bbox,sequence,frame number

params = readParams('params.txt');
params.img_files = img_files;
params.img_path = img_path;
params.bb_VOT = bbox;
region = params.bb_VOT;

if(size(initial_frame,3)==1)
  params.grayscale_sequence = true;
end
x = region(1);
y = region(2);       
w = region(3);    
h = region(4);        
cx = x+w/2;        
cy = y+h/2;
params.init_pos = [cy cx];
params.target_sz = round([h w]);
[params, bg_area, fg_area, area_resize_factor] = initializeAllAreas(initial_frame, params);
params.fout = -1;
results = tracking(params, initial_frame, bg_area, fg_area, area_resize_factor);
end

% function stapleTracker(sequence, frame, bbox)   %% bbox,sequence,frame number
% 
% % RUN_TRACKER  is the external function of the tracker - does initialization and calls trackerMain
% 
%     % Read params.txt
%     params = readParams('params.txt');
% 	% load video info
% % 	sequence_path = ['../Sequences/',sequence,'/'];
% %     img_path = [sequence_path 'imgs/'];
%     % Read files
% %     text_files = dir([sequence_path '*_frames.txt']);
% %     f = fopen([sequence_path text_files(1).name]);
% %     frames = textscan(f, '%f,%f');
% %     if exist('start_frame')
% %         frames{1} = start_frame;
% %     else
% %         frames{1} = 1;
% %     end
%     
% %     fclose(f);
%     
% %     params.bb_VOT = csvread([sequence_path 'groundtruth.txt']);
% 
% param.bb_VOT = bbox;
% region = params.bb_VOT;
% 
%     % read all the frames in the 'imgs' subfolder
% %     dir_content = dir([sequence_path 'imgs/']);
%     % skip '.' and '..' from the count
% %     n_imgs = length(dir_content) - 2;
% %     img_files = cell(n_imgs, 1);
% %     for ii = 1:n_imgs
% %         img_files{ii} = dir_content(ii+2).name;
% %     end
%        
% %     img_files(1:start_frame-1)=[];
%     
% %     im = imread([img_path img_files{1}]);
%     % is a grayscale sequence ?
%     
% im = frame;
%     if(size(im,3)==1)
%         params.grayscale_sequence = true;
%     end
% 
% %     params.img_files = img_files;
% %     params.img_path = img_path;
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         x = region(1);
%         y = region(2);
%         w = region(3);
%         h = region(4);
%         cx = x+w/2;
%         cy = y+h/2;
% 
%     % init_pos is the centre of the initial bounding box
%     params.init_pos = [cy cx];
%     params.target_sz = round([h w]);
%     [params, bg_area, fg_area, area_resize_factor] = initializeAllAreas(im, params);
% % 	if params.visualization
% % 		params.videoPlayer = vision.VideoPlayer('Position', [100 100 [size(im,2), size(im,1)]+30]);
% % 	end
%     % in runTracker we do not output anything
% 	params.fout = -1;
% 	% start the actual tracking
% 	trackerMain(params, im, bg_area, fg_area, area_resize_factor);
% %     fclose('all');
% % end


