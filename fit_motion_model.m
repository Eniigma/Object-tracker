function [temp1,temp2] = fit_motion_model(temp1,temp2,vel,ratio)

c = temp1(1,1:2);
w = temp1(1,3);
h = temp1(1,4);
for i=2:size(temp1,1)
    k = c+vel*(i-1);
    distance = temp1(i,1:2) - k;
    if (distance(1)>ratio*w || distance(2)>ratio*h)
        temp1(i,1:2) = k;
    end
end

for i=2:size(temp2,1)
    k = c-vel*(i-1);
    distance = temp2(i,1:2) - k;
    if (distance(1)>4*w/5 || distance(2)>4*h/5)
        temp2(i,1:2) = k;
    end
end
end
