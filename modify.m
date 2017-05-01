function [dres] = modify(dres)
l = length(dres.x);
k =l;
arr = zeros(l*3,1);
dres.x = [dres.x ;arr];
dres.y = [dres.y ;arr];
dres.w = [dres.w ;arr];
dres.h = [dres.h ;arr];
dres.r = [dres.r ;arr];
dres.fr = [dres.fr ;arr];

for i=1:l
    i
   f = dres.fr(i);
   r = dres.r(i);
   traj = dres.tr1(i).bbox;
   for j=1:size(traj,1)-1
      f = f+1;
      k = k+1;
      dres.x(k) = traj(j+1,1);
      dres.y(k) = traj(j+1,2);
      dres.w(k) = traj(j+1,3);
      dres.h(k) = traj(j+1,4);
      dres.fr(k) = f;
      dres.r(k) = r;
   end
end
end