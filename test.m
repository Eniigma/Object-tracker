clc
clear
addpath(genpath('/home/shubham/mot_benchmark/staple'));    %% path for STAPLE tracker
addpath(genpath('/home/shubham/mot_benchmark/meng-work/MATLAB/tracking_cvpr11_release_v1_0'));

direct = '/home/shubham/mot_benchmark/Object-tracker/';
datadir  = '/home/shubham/mot_benchmark/meng-work/MATLAB/tracking_cvpr11_release_v1_0/data/';
cachedir = '/home/shubham/mot_benchmark/meng-work/MATLAB/tracking_cvpr11_release_v1_0/cache/';
mkdir(cachedir);
vid_name = 'seq03-img-left';
vid_path = [datadir vid_name '/'];

%%% Run object/human detector on all frames.
display('in object/human detection... (may take an hour using 8 CPU cores: please set the number of available CPU cores in the code)')
fname = [cachedir vid_name '_detec_res.mat'];
try
  load(fname)
catch
  [dres, bboxes] = detect_objects(vid_path);
  save (fname, 'dres', 'bboxes');
end
indices = find(dres.fr == 6);
u = max(indices);
dres.x = dres.x(1:u);
dres.y = dres.y(1:u);
dres.w = dres.w(1:u);
dres.h = dres.h(1:u);
dres.r = dres.r(1:u);
dres.fr = dres.fr(1:u);

ind = find(dres.r > 0);
dres.x = dres.x(ind);
dres.y = dres.y(ind);
dres.w = dres.w(ind);
dres.h = dres.h(ind);
dres.r = dres.r(ind);
dres.fr = dres.fr(ind);

ftrack = [direct '_track_test.mat'];
fcost = [direct '_cost_test.mat'];
% dres = single_target_tracker_main2(dres,vid_path);
% save (ftrack, 'dres');
load(ftrack);
c_ij = link_cost_main2(dres);
save (fcost, 'dres');

c_en      = 10;     %% birth cost
c_ex      = 10;     %% death cost
betta     = 0.2;    %% betta
max_it    = inf;    %% max number of iterations (max number of tracks)
thr_cost  = 18;     %% max acceptable cost for a track (increase it to have more tracks.)

dres_push_relabel   = tracking_push_relabel(dres, c_en, c_ex, c_ij, betta, max_it);
dres_push_relabel.r = -dres_push_relabel.id;

load('label_image_file');
m=2;
for i=1:length(bws)                   %% adds some margin to the label images
  [sz1 sz2] = size(bws(i).bw);
  bws(i).bw = [zeros(sz1+2*m,m) [zeros(m,sz2); bws(i).bw; zeros(m,sz2)] zeros(sz1+2*m,m)];
end
% mkdir(temp);
direct = '/home/shubham/mot_benchmark/Object-tracker/';
input_frames    = [datadir 'seq03-img-left/image_%0.8d_0.png'];
output_path     = [direct 'temp/'];
output_vidname  = [direct '_push_relabel.avi'];
fnum = max(dres.fr);
bboxes_tracked = dres2bboxes(dres, fnum); 
show_bboxes_on_video(input_frames, bboxes_tracked, output_vidname, bws, 4, -inf, output_path);
