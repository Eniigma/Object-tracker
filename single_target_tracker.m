function [dres] = single_target_tracker(dres,vid_path)
delta = 3;
no_frames = max(dres.fr);
dirlist = dir(strcat(vid_path,'*.png'));
img_files = cell(no_frames, 1);
for i = 1:no_frames           %% read all frames ->no_frames
   img_files{i} = dirlist(i).name;
end
params = readParams('params.txt');
params.img_path = vid_path;
params.fout = -1;
tr1 = [];
tr2 = [];

for i=1:delta:no_frames    
    im_files = img_files(i:min(i+delta,no_frames));
    im_files_rev = img_files(max(i-delta,1):i)';   %% convert to row vector
    im_files_rev = fliplr(im_files_rev);
    ind = find(dres.fr==i);
    initial_frame = imread(strcat(vid_path,dirlist(i).name));

    for j=1:length(ind)
        k = ind(j);
        params.bb_VOT = [dres.x(j) dres.y(j) dres.w(j) dres.h(j)];
        params.init_pos = [dres.y(j)+dres.h(j)/2 dres.x(j)+dres.w(j)/2];
        params.target_sz = round([dres.h(j) dres.w(j)]);
        params.img_files = im_files;
        [params, bg_area, fg_area, area_resize_factor] = initializeAllAreas(initial_frame, params);
        results = tracking(params, initial_frame, bg_area, fg_area, area_resize_factor);
        tr1(k) = results.res;
        params.img_files = im_files_rev;
        [params, bg_area, fg_area, area_resize_factor] = initializeAllAreas(initial_frame, params);
        results = tracking(params, initial_frame, bg_area, fg_area, area_resize_factor);
        tr2(k) = results.res;
    end
end
end