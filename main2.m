clc
clear
addpath(genpath('/home/shubham/mot_benchmark/staple'));    %% path for STAPLE tracker
addpath(genpath('/home/shubham/mot_benchmark/meng-work/MATLAB/tracking_cvpr11_release_v1_0'));

%%%%%%%%%%%%%%% parameters for tracking
c_en      = 10;    
c_ex      = 10;     
ratio     = 4/5;

no_frames = 500;
betta           = -0.5;%-2;%-0.2; %-0.05;    %0.2;     %% tuning parameter for detection cost
delta           = 15;
overlap_thresh  = 0.2;%0.8%0.4;
w_overlap       = 2;
w_dist          = 0.3;%0.3;
w_time_diff     = 0.33;%0.5;
%%%%%%%%%%%%%%

datadir = '/home/shubham/mot_benchmark/Sequences/MOT15/train/';     %% venice-2, TUD Stad, ETH Bah
% datadir = '/home/shubham/mot_benchmark/Sequences/MOT15/test/';     %% TUD Crossing
% datadir = '/home/shubham/mot_benchmark/Sequences/MOT16/train/';  %% mot16-04
% datadir = '/home/shubham/mot_benchmark/Sequences/Pune-data/';  %% Court

% vid_name = 'seq03-img-left/';
vid_name = 'ETH-Bahnhof/img1/';   %betta = -0.5, thr = 0.2
% vid_name = 'Venice-2/img1/';      %betta = -0.5,thr = 0.2
% vid_name = 'MOT16-04/img1/';
% vid_name = 'MOT16-01/img1/';
% vid_name = 'TUD-Stadtmitte/img1/';  % betta = -1,thr = 0.7
% vid_name = 'TUD-Crossing/img1/';     % betta = -2. thr = 0.2
% vid_name = 'court/img/';

vid_path = [datadir vid_name];          %% Sequence location

%%%%%%%%%%%%%%% Find trajecories
% ftrack = 'cache/traj_MOT16-04_500_15.mat';
ftrack = 'cache/traj_ETH-Bahnhof_500_15.mat';
% ftrack = 'cache/traj_Venice-2_500_4.mat';
% ftrack = 'cache/traj_MOT16-01_450_15.mat';
% ftrack = 'cache/traj_TUD-Stadtmitte_179_15.mat';
% ftrack = 'cache/traj_TUD-Crossing_200_15.mat';
% ftrack = 'cache/traj_court_486_15.mat';
load(ftrack);    

%%% for detections from ACF detector
% l = length(dres.r);
% dres.r = 2*ones(l,1);
dres.r = dres.r/100;     %%TUD
dres = no_of_frames(dres,no_frames);
dres = velocity_model(dres,ratio);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
videoPlayer = vision.VideoPlayer;
no_frames = max(dres.fr);
dirlist = dir(strcat(vid_path,'*.jpg'));
img_files = cell(no_frames, 1);
for i = 1:no_frames           %% read all frames ->no_frames
   img_files{i} = dirlist(i).name;
end
% xx = find(dres.fr>1 & dres.fr<5);
xx = find(dres.fr==100);
for i = 1:length(xx)
    j = xx(i);
    frame = dres.fr(j);
    rectangle = dres.tr1(j).bbox;
    im = imread([vid_path img_files{frame}]);
    for k=1:delta+1
        rect = rectangle(k,:);
        im = imread([vid_path img_files{frame+k-1}]);
%         figure(1)
%         imshow(im)
%         hold on
        im = insertShape(im, 'Rectangle', rect, 'LineWidth', 2, 'Color', 'black');
%         drawnow
        step(videoPlayer,im);
    end
end
 
%%%%%%%%%%%%%% Find detections links
cij = link_cost_main2(dres,delta,overlap_thresh,w_overlap,w_dist,w_time_diff);
% fcost = 'cache/cost_MOT16-04_500_15.mat';
% fcost = 'cache/cost_venice-2_500_4.mat';
% save(fcost,'cij');
% load(fcost);      

%%%%%%%%%%%%%%% Push relabel algorithm
display('in push relabel algorithm ...')
dres_push_relabel   = tracking_push_relabel_main2(dres, c_en, c_ex, cij, betta);
% dres_push_relabel = smooth_tracks(dres_push_relabel);

%%%%%%%%%%%%%%% Display results
display('writing the results into a video file ...')
load('cache/label_image');
m=2;
for i=1:length(bws)                   %% adds some margin to the label images
  [sz1 ,sz2] = size(bws(i).bw);
  bws(i).bw = [zeros(sz1+2*m,m) [zeros(m,sz2); bws(i).bw; zeros(m,sz2)] zeros(sz1+2*m,m)];
end
% input_frames    = [datadir 'seq03-img-left/image_%0.8d_0.png'];
input_frames    = [datadir vid_name '%0.6d.jpg'];
output_path     = 'temp5/';
mkdir(output_path);
fnum = max(dres.fr);
bboxes_tracked = dres2bboxes(dres_push_relabel, fnum); 
show_bboxes_on_video(input_frames, bboxes_tracked, bws, -inf, output_path);

vidname = 'MOT16.avi';
convert2Video(output_path,vidname);
%%%%%%%%%%%%%%% Write results to csv file
% write_results(dres_push_relabel,'Venice-2.dat');