function c_ij = link_cost_main2(dres)
delta = 4;
% ind = find(mod(dres.fr, delta)==1);
% dnuml = length(ind);
dnum = length(dres.x);
cij = ones(dnum,dnum);   %% if frame.i== frame.j then cij=100
cij = cij.*10;
c_ij = zeros(dnum,2);
for k1=1:dnum
    for k2= k1+1:dnum
        xx1 = dres.fr(k1);
        xx2 = dres.fr(k2);
        if(xx1~=xx2)
            traj1 = dres.tr1(k1).bbox;
            traj2 = dres.tr2(k2).bbox;
            cij(k1,k2) = trajOverlap_main2(xx1,xx2,traj1,traj2);
        end
    end
    min_cost = min(cij(k1,:));
    min_cost_ind = find(cij(k1,:)==min_cost);
    min_cost_ind
    min_cost
    k1
    c_ij(k1,1) = min(min_cost_ind);
    c_ij(k1,2) = min_cost;
end
    
end