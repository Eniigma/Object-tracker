clc
clear
addpath(genpath('/home/shubham/mot_benchmark/staple'));    %% path for STAPLE tracker
addpath(genpath('/home/shubham/mot_benchmark/meng-work/MATLAB/tracking_cvpr11_release_v1_0'));

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
ind = find(dres.r > 0);
dres.x = dres.x(ind);
dres.y = dres.y(ind);
dres.w = dres.w(ind);
dres.h = dres.h(ind);
dres.r = dres.r(ind);
dres.fr = dres.fr(ind);

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
