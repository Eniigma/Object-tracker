function cij = link_cost_main2(dres,delta)
overlap_thresh = 0.4;
time_diff_weight = 0.33;
overlap_weight = 2;

% ind = find(mod(dres.fr, delta)==1);
% dnuml = length(ind);
dnum = length(dres.x);
c_ij = zeros(dnum,dnum);   %% if frame.i== frame.j then cij=100
% c_ij = c_ij.*10;
cij = zeros(dnum,1);

for k1=1:dnum
    for k2= k1+1:dnum
        xx1 = dres.fr(k1);
        xx2 = dres.fr(k2);
        if(xx1~=xx2)
            traj1 = dres.tr1(k1).bbox;
            traj2 = dres.tr2(k2).bbox;
            c_ij(k1,k2) = trajOverlap_main2(xx1,xx2,traj1,traj2,delta,time_diff_weight,overlap_weight);
        end
    end
    arr = c_ij(k1,:);
    [~,max_ind] = max(arr);
    if(arr(max_ind) > overlap_thresh)
        cij(k1) = max_ind;
%     else
%         disp(k1);
%         disp(max_ind);
%         disp(arr(max_ind));
    end
end
    
end