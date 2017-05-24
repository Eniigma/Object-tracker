clc
clear
addpath(genpath('/home/shubham/mot_benchmark/staple'));    %% path for STAPLE tracker
addpath(genpath('/home/shubham/mot_benchmark/meng-work/MATLAB/tracking_cvpr11_release_v1_0'));

datadir  = '/home/shubham/mot_benchmark/meng-work/MATLAB/tracking_cvpr11_release_v1_0/data/';
cachedir = '/home/shubham/mot_benchmark/meng-work/MATLAB/tracking_cvpr11_release_v1_0/cache/';
mkdir(cachedir);
vid_name = 'seq03-img-left';
vid_path = [datadir vid_name '/'];

%%%%%%%%%%%%%%% setting parameters for tracking
c_en      = 10;     %% birth cost
c_ex      = 10;     %% death cost
% c_ij      = 0;      %% transition cost
betta     = 0.2;    %% betta
max_it    = inf;    %% max number of iterations (max number of tracks)
thr_cost  = 18;     %% max acceptable cost for a track (increase it to have more tracks.)
delta     = 15;
ratio = 4/5;
%%%%%%%%%%%%%%%


%%%%%%%%%%% Run object/human detector on all frames.
display('in object/human detection...')
fname = [cachedir vid_name '_detec_res.mat'];
try
  load(fname)
catch
  [dres, bboxes] = detect_objects(vid_path);
  save (fname, 'dres', 'bboxes');
end

%%%%%%%%%%%  No of frames to track == 100
indices = find(dres.fr == 100);
u = max(indices);
dres.x = dres.x(1:u);
dres.y = dres.y(1:u);
dres.w = dres.w(1:u);
dres.h = dres.h(1:u);
dres.r = dres.r(1:u);
dres.fr = dres.fr(1:u);

%%% remove detections with negative confidence score
ind = find(dres.r > 0);
dres.x = dres.x(ind);
dres.y = dres.y(ind);
dres.w = dres.w(ind);
dres.h = dres.h(ind);
dres.r = dres.r(ind);
dres.fr = dres.fr(ind);

%%%%%%%%%%%%%%% Find trajecories
ftrack = [cachedir vid_name '_traject_main2_vel.mat'];
% dres = single_target_tracker_main2_vel(dres,vid_path);
% save (ftrack, 'dres');
load(ftrack);    %% load trajectories

[dres] = velocity_model(dres,ratio);

%%%%%%%%%%%%%%% Find detections links
cij = link_cost_main2(dres,delta);
% fcost = [cachedir vid_name '_cost_main2.mat'];
fcost = [cachedir vid_name '_cost_main2_vel.mat'];
save(fcost,'cij');
% load(fcost);       %% load c_ij

tic
display('in push relabel algorithm ...')
dres_push_relabel   = tracking_push_relabel_main2(dres, c_en, c_ex, cij, betta, max_it);
dres_push_relabel.r = -dres_push_relabel.id;
toc
%%%%%%%%%%%%%%%

display('writing the results into a video file ...')
%% uncomment this block if you want to re-build the label images. You don't need to do that unless there is more than 1000 tracks.
% close all
% for i = 1:max(dres_dp.track_id)
% for i = 1:1000
%   bws(i).bw =  text_to_image(num2str(i), 20, 123);
% end
% mkdir('output');
% save label_image_file bws
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('label_image_file');
m=2;
for i=1:length(bws)                   %% adds some margin to the label images
  [sz1 sz2] = size(bws(i).bw);
  bws(i).bw = [zeros(sz1+2*m,m) [zeros(m,sz2); bws(i).bw; zeros(m,sz2)] zeros(sz1+2*m,m)];
end
direct = '/home/shubham/mot_benchmark/Object-tracker/';
input_frames    = [datadir 'seq03-img-left/image_%0.8d_0.png'];
output_path     = [direct 'temp/'];
output_vidname  = [direct '_push_relabel.avi'];
% display(output_vidname)

fnum = max(dres.fr);
% bboxes_tracked = dres_to_bboxes(dres_push_relabel, fnum);
bboxes_tracked = dres2bboxes(dres_push_relabel, fnum); 
show_bboxes_on_video(input_frames, bboxes_tracked, output_vidname, bws, 4, -inf, output_path);
