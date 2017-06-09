clc
clear
addpath(genpath('/home/shubham/mot_benchmark/staple'));    %% path for STAPLE tracker
addpath(genpath('/home/shubham/mot_benchmark/meng-work/MATLAB/tracking_cvpr11_release_v1_0'));

%%%%%%%%%%%%%%% setting parameters for tracking
c_en      = 10;     %% birth cost
c_ex      = 10;     %% death cost
% c_ij      = 0;      %% transition cost
betta     = 0.2;    %% betta
max_it    = inf;    %% max number of iterations (max number of tracks)
thr_cost  = 18;     %% max acceptable cost for a track (increase it to have more tracks.)
ratio     = 4/5;
%%%%%%%%%%%%%%%

datadir  = '/home/shubham/mot_benchmark/Sequences/Pune-data/';
vid_name = 'court/img/';
vid_path = [datadir vid_name];
filepath ='/home/shubham/mot_benchmark/Sequences/Pune-data/court/'; %% Venice-2
dres = get_detections(filepath);
delta = 15;
%%%%%%%%%%%%%%%%%%%%
ind = find(dres.r > 0);
dres.x = dres.x(ind);
dres.y = dres.y(ind);
dres.w = dres.w(ind);
dres.h = dres.h(ind);
dres.r = dres.r(ind);
dres.fr = dres.fr(ind);

%%%%%%%%%%%%%%% Find trajecories
ftrack = 'cache/traj_court_486_15.mat';
dres = single_target_tracker_main2_vel(dres,vid_path,delta);
% save (ftrack, 'dres');

load('cache/label_image');
input_frames    = [datadir vid_name '%0.8d.jpg'];
output_path     = 'temp6/';
mkdir(output_path);
fnum = length(dres.x);
bboxes_tracked = dres2bboxes(dres, fnum); 
show_bboxes_on_video(input_frames, bboxes_tracked, bws, -inf, output_path);


% 
% %%%%%%%%%%%%%%%%%%%% SEQUENCE 1
% datadir = '/home/shubham/mot_benchmark/Sequences/MOT16/test/';
% vid_name = 'MOT16-01/img1/';
% vid_path = [datadir vid_name];
% filepath = '/home/shubham/mot_benchmark/Sequences/MOT16/test/MOT16-01/det/'; %% People crossing
% dres = get_detections(filepath);
% 
% delta =15;
% %%%%%%%%%%%%%%% Find trajecories
% ftrack = 'traj_MOT16-01_450_15.mat';
% dres1 = single_target_tracker_main2_vel(dres,vid_path,delta);
% save (ftrack, 'dres1');
% 
% delta = 4;
% %%%%%%%%%%%%%%% Find trajecories
% ftrack = 'traj_MOT16-01_450_4.mat';
% dres2 = single_target_tracker_main2_vel(dres,vid_path,delta);
% save (ftrack, 'dres2');
% 
% 
% %%%%%%%%%%%%%%%%%%%% SEQUENCE 2
% datadir = '/home/shubham/mot_benchmark/Sequences/MOT16/train/';
% vid_name = 'MOT16-04/img1/';
% vid_path = [datadir vid_name];
% filepath = '/home/shubham/mot_benchmark/Sequences/MOT16/train/MOT16-04/det/'; %% Town square
% dres = get_detections(filepath);
% 
% %%%%%%%%%%  No of frames to track
% indices = find(dres.fr == 500);
% u = max(indices);
% dres.x = dres.x(1:u);
% dres.y = dres.y(1:u);
% dres.w = dres.w(1:u);
% dres.h = dres.h(1:u);
% dres.r = dres.r(1:u);
% dres.fr = dres.fr(1:u);
% 
% delta =15;
% %%%%%%%%%%%%%%% Find trajecories
% ftrack = 'traj_MOT16-04_500_15.mat';
% dres3 = single_target_tracker_main2_vel(dres,vid_path,delta);
% save (ftrack, 'dres3');
% 
% delta = 4;
% %%%%%%%%%%%%%%% Find trajecories
% ftrack = 'traj_MOT16-04_500_4.mat';
% dres4 = single_target_tracker_main2_vel(dres,vid_path,delta);
% save (ftrack, 'dres4');
% 
[dres] = velocity_model(dres,ratio);


