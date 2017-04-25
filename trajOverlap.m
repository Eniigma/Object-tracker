function [c_ij] = trajOverlap(frame1,frame2,traj1,traj2)

%%% feature 2 -> time difference
time_diff = frame2-frame1; 
k = 5;

if(time_diff > k)
    c_ij = -1;
else
    
    iou = zeros(1,time_diff);
    weights = [-20, -20, -5, -5, -0.5, 0.5, 0.5, 0.5, 0.5, 0.5];  %% weights
    hist = zeros(1,10);  %% 10 bin histogram

    %%% feature 1 -> IoU
    for i = 1:time_diff
        bbox1 = traj1(i,:);
        bbox2 = traj2(time_diff-i+1,:);
        iou(i) = bboxOverlap(bbox1,bbox2);  %%find IoU between detections
        for j=0:1:10
            if iou(i) < 0.1*j
                hist(j)= hist(j)+1;
                break;
            end
        end
    end
        c_ij = 1/(1+exp(-1*dot(weights,hist)));  %% sigmoid funct 
%         c_ij = log(a_ij);
end
end