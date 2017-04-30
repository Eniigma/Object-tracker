function [bboxes] = dres_to_bboxes(dres,fnum)
delta = 4;
no_frames = 1000;
for i = 1:fnum
  bboxes(i).bbox = [];
end

for i = 1:length(dres.x)
  bbox = [dres.x(i) dres.y(i) dres.x(i)+dres.w(i) dres.y(i)+dres.h(i) dres.id(i)];
  bboxes(dres.fr(i)).bbox = [bboxes(dres.fr(i)).bbox; bbox];
  traj = dres.tr1(i).bbox;
  id = dres.id(i);
  for j=1:delta-1
    bbox1 = [traj(j+1,1:2) traj(j+1,1)+traj(j+1,3) traj(j+1,2)+traj(j+1,4) id];
%     traj
    i
    j
    l = min(dres.fr(i)+j,no_frames);
    l
    bboxes(l).bbox = [bboxes(l).bbox; bbox1]; 
  end
end

end