function dres = get_detections(filepath)
file = strcat(filepath,'det.txt');
% fileID = fopen(file,'r');
M = csvread(file);

dres.x = M(:,3);
dres.y = M(:,4);
dres.w = M(:,5);
dres.h = M(:,6);
dres.r = M(:,7);
dres.fr = M(:,1);
end