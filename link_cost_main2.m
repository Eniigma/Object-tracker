function cij = link_cost_main2(dres,delta,overlap_thresh,w_overlap,w_dist,w_time_diff)

dnum = length(dres.x);
% cij = zeros(dnum,1);
for i=1:dnum
    cij(i).nei = [];
    cij(i).val = [];
end

for k1=1:dnum
    display(k1);
    c_ij = -10.*ones(1,dnum);
    frame1 = dres.fr(k1);
    ind = find(dres.fr < frame1+delta+1 & dres.fr > frame1);
    traj1 = dres.tr1(k1).bbox;
    for k2= 1:length(ind)
        j = ind(k2);
        frame2 = dres.fr(j);
        traj2 = dres.tr2(j).bbox;
        c_ij(1,j) = trajOverlap_main2(frame1,frame2,traj1,traj2,delta,w_time_diff,w_overlap,w_dist);
    end   
%    for i=k1+1:size(arr,2)
%         if(arr(i)>overlap_thresh)
%             cij(k1) = i;
%             flag=1;
%             break;
%         end
%    end
%    if(flag==0)

arr = c_ij(1,:);
index = find(arr>overlap_thresh);
values = arr(index(:));
cij(k1).nei = index;
cij(k1).val = values;


% [value,max_ind] = max(arr);
% if(value > overlap_thresh)
%     cij(k1) = max_ind;
% end

%         if(flag==0)
%             [velocity,min_ind] = min(vel);
%             if(velocity<5)
%                  cij(k1) = min_ind;
%             end
%         end
%    end
end
    
end