function c_ij = link_cost(dres)
delta = 4;
ind = find(mod(dres.fr, delta)==1);
dnuml = length(ind);
dnum = length(dres.x);
c_ij = ones(dnum,dnum);   %% if frame.i== frame.j then cij=100
c_ij = c_ij.*10;
for i=1:dnuml
    k1 = ind(i);
    display(k1);
    for j= i+1:dnuml
        k2  = ind(j);
        xx1 = dres.fr(k1);
        xx2 = dres.fr(k2);
        if(xx1~=xx2)
            traj1 = dres.tr1((delta+1)*(k1-1)+1:(delta+1)*(k1-1)+4,:);
            traj2 = dres.tr2((delta+1)*(k2-1)+1:(delta+1)*(k2-1)+4,:);
            c_ij(k1,k2) = trajOverlap(xx1,xx2,traj1,traj2);
        end
    end
end
    
end