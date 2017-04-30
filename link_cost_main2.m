function c_ij = link_cost_main2(dres)
delta = 4;
% ind = find(mod(dres.fr, delta)==1);
% dnuml = length(ind);
dnum = length(dres.x);
c_ij = ones(dnum,dnum);   %% if frame.i== frame.j then cij=100
c_ij = c_ij.*10;
for k1=1:dnum
    display(k1);
    for k2= k1+1:dnum
        xx1 = dres.fr(k1);
        xx2 = dres.fr(k2);
        if(xx1~=xx2)
            traj1 = dres.tr1(k1).bbox;
            traj2 = dres.tr2(k2).bbox;
            c_ij(k1,k2) = trajOverlap_main2(xx1,xx2,traj1,traj2);
        end
    end
    
end
    
end