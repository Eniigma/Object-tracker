clc;
clear;
addpath(genpath('/home/shubham/mot_benchmark/staple'));    %% path for STAPLE tracker
addpath(genpath('/home/shubham/mot_benchmark/toolbox/'));   %% Poitr toolbox

%%% Load Detector
loadModel = 1;  %1->Caltech  2->INRIA
detector = detector_Class(loadModel);
count = 1;

%%%%%%%%%%% Read Images and Get detections %%%%%%%%%%%%%%%%
img_path = '/home/shubham/mot_benchmark/Sequences/MOT15/train/PETS09-S2L1/img1/';
srcFiles = dir(strcat(img_path,'*.jpg'));
% no_frames = length(srcFiles);
no_frames = 20;
delta = 4;
img_files = cell(no_frames, 1);
for i = 1:no_frames           %% read all frames ->no_frames
   img_files{i} = srcFiles(i).name;
end

%%%%%%%%%%% struct stores all trajectories %%%%%%%%%%%%%
det = struct('frame',[],'id',[],'position',[],'forward_traj',[],'backward_traj',[]); 

for i=1:delta:no_frames-delta
image = imread(strcat(img_path,srcFiles(i).name));
bboxes = detect(detector,image);
len = size(bboxes,1);

for j = 1:len
    bbox = bboxes(j,:);
    det(count).frame = i;
    det(count).id = j;
    det(count).position = bbox;
    
    %%%%% get forward and back trajectories
    im_files = img_files(i:i+delta);
    results = stapleTracker(img_path, im_files, image, bbox);
    det(count).forward_traj = results.res;    
    im_files = img_files(max(i-delta,1):i)';   %% convert to row vector
    im_files = fliplr(im_files);
    results = stapleTracker(img_path, im_files, image, bbox);
    det(count).backward_traj = results.res;
    
    count = count+1;
end 
end

%%%% testing
xx1 = det(1).frame;
xx2 = det(6).frame;
yy1 = det(1).forward_traj;
yy2 = det(6).backward_traj;
overlap_measure = trajOverlap(xx1,xx2,yy1,yy2);

%%% Initialize Variables for ILP 
c_en      = 10;     %% birth cost
c_ex      = 10;     %% death cost
% c_ij      = -1;      %% transition cost
betta     = 0.2;    %% betta
max_it    = inf;    %% max number of iterations (max number of tracks)
thr_cost  = 18;     %% max acceptable cost for a track (increase it to have more tracks.)

%%% calculate Cij for all xi,xj
no_det = length(det);
c_ij = zeros(no_det,no_det);   %% if frame.i== frame.j then cij=0
for i=1:no_det
    xx1 = det(i).frame;
    for j= i:no_det
        xx2 = det(j).frame;
        if (xx1==xx2)
            c_ij(i,j) = 0;
        else
            yy1 = det(i).forward_traj;
            yy2 = det(j).backward_traj;
            c_ij(i,j) = trajOverlap(xx1,xx2,yy1,yy2);
        end
    end
end


%%% push relabel method
% dres_push_relabel   = tracking_push_relabel(det, c_en, c_ex, c_ij, betta, max_it);
% dres_push_relabel.r = -dres_push_relabel.id;

