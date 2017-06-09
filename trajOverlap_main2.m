function [c_ij] = trajOverlap_main2(frame1,frame2,traj1,traj2,delta,w_time_diff,w_overlap,w_dist)
time_diff = frame2-frame1;

if(time_diff > delta)
    c_ij = -10;
else
%     iou = zeros(1,time_diff);
%     weights = [1.31,1.38,1.46,1.54,1.6,1.6,1.54,1.45,1.38,1.31];  %% weights
%     hist = zeros(1,10);  %% 10 bin histogram

%%%%%%%%%%%%%% feature 1 -> Trajectory Overlap
    avg_overlap=0;
    for i = 1:time_diff
        bbox1 = traj1(i,:);
        bbox2 = traj2(time_diff-i+1,:);
        iou = bboxOverlap(bbox1,bbox2);  %%find IoU between detections
        avg_overlap = avg_overlap+iou;
%         temp = min(floor(iou(i)*10),9);
%         hist(1,temp+1) = hist(1,temp+1)+1;
    end
    avg_overlap = avg_overlap/time_diff;

% %%%%%%%%%%%%%% feature 2 -> distance between centre
    avg_dist = 0;
    for i = 1:time_diff
        bbox1 = traj1(i,:);
        bbox2 = traj2(time_diff-i+1,:);
        dist = bbox1(1:2)-bbox2(1:2);  %%find IoU between detections
        dist = sqrt(sum(dist.^2));
        dist = dist/((bbox1(3)+bbox2(3))/2+(bbox1(4)+bbox2(4))/2);
        avg_dist = avg_dist+dist;
    end 
    avg_dist = avg_dist/time_diff;
    
%%%%%%%%%%%%%% feature 3 -> velocity similarity
%     l1 = size(traj1,1);
%     l2 = size(traj2,1);
%     if(l1>1)
%         vel1 = traj1(2,1:2)-traj1(1,1:2);
%     end
%     if(l2>1)
%         vel2 = traj2(1,1:2)-traj1(2,1:2);
%     end
%     vel_diff = sqrt(sum((vel1 - vel2) .^ 2));

%%%%%%%%%%%%%% final link weight
    k1 = w_overlap*(avg_overlap);
    k2 = w_dist*avg_dist;
    k3 = (w_time_diff)*(time_diff);
    c_ij = w_overlap*(avg_overlap) - w_dist*avg_dist - (w_time_diff)*(time_diff);
    
%     p = sum(hist.*weights)-time_diff*0.33 ;
%     c_ij = 1/(1+exp(-1*p));  %% sigmoid funct 
%     c_ij = -log(a_ij);
end
end