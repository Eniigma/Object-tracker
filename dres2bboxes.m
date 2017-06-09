function bboxes = dres2bboxes(dres, fnum)
for i = 1:fnum
  bboxes(i).bbox = [];
end

for i = 1:length(dres.x)
%   if(dres.r(i)>0)
%   bbox = [dres.x(i) dres.y(i) dres.x(i)+dres.w(i) dres.y(i)+dres.h(i) ceil(100*dres.r(i))];
%   else
%   bbox = [1 1 1 1 100];
% %   bbox = [dres.x(i) dres.y(i) dres.x(i)+dres.w(i) dres.y(i)+dres.h(i) ceil(dres.r(i))+100];
%   end
    
    bbox = [dres.x(i) dres.y(i) dres.x(i)+dres.w(i) dres.y(i)+dres.h(i) dres.id(i)];
    bboxes(dres.fr(i)).bbox = [bboxes(dres.fr(i)).bbox; bbox];
end

