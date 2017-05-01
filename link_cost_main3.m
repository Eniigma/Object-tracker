function c_ij = link_cost_main3(dres)
delta = 4;
ind1 = find(mod(dres.fr, delta)==1);
ind2 = find(mod(dres.fr, delta)==2);
ind3 = find(mod(dres.fr, delta)==3);
ind4 = find(mod(dres.fr, delta)==0);

dnum = length(dres.x);
c_ij = ones(dnum,dnum);   %% if frame.i== frame.j then cij=100
c_ij = c_ij.*10;
for i=1:length(ind1)
    k1 = ind1(i);    
    for j= i+1:length(ind1)
        k2  = ind1(j);
        xx1 = dres.fr(k1);
        xx2 = dres.fr(k2);
        if(xx1~=xx2)
            traj1 = dres.tr1(k1).bbox;
            traj2 = dres.tr2(k2).bbox;
            c_ij(k1,k2) = trajOverlap(xx1,xx2,traj1,traj2);
        end
    end
end
for i=1:length(ind2)
    k1 = ind2(i);    
    for j= i+1:length(ind2)
        k2  = ind2(j);
%         k1
%         k2
%         j
        xx1 = dres.fr(k1);
        xx2 = dres.fr(k2);
        if(xx1~=xx2)
            traj1 = dres.tr1(k1).bbox;
            traj2 = dres.tr2(k2).bbox;
            c_ij(k1,k2) = trajOverlap(xx1,xx2,traj1,traj2);
        end
    end
end
for i=1:length(ind3)
    k1 = ind3(i);    
    for j= i+1:length(ind3)
        k2  = ind3(j);
        xx1 = dres.fr(k1);
        xx2 = dres.fr(k2);
        if(xx1~=xx2)
            traj1 = dres.tr1(k1).bbox;
            traj2 = dres.tr2(k2).bbox;
            c_ij(k1,k2) = trajOverlap(xx1,xx2,traj1,traj2);
        end
    end
end
for i=1:length(ind4)
    k1 = ind4(i);    
    for j= i+1:length(ind4)
        k2  = ind4(j);
        xx1 = dres.fr(k1);
        xx2 = dres.fr(k2);
        if(xx1~=xx2)
            traj1 = dres.tr1(k1).bbox;
            traj2 = dres.tr2(k2).bbox;
            c_ij(k1,k2) = trajOverlap(xx1,xx2,traj1,traj2);
        end
    end
end
    
end
    