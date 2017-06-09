function dres = smooth_tracks(dres)
max_id = max(dres.id);
l = max(dres.fr);
dres1 = dres;
for i=1:max_id
    ind = find(dres.id==i);
    p = length(ind);
    u1 = ind(1);
    u2 = ind(p);
    for j=1:p
        k = ind(j);
        p1 = max(u1,k-20);
        p2 = min(u2,k+20);
        dres.w(k) = sum(dres1.w(p1:p2))/(p2-p1+1);
        dres.h(k) = sum(dres1.h(p1:p2))/(p2-p1+1);
    end
end

end