function write_results(dres,name)
l = length(dres.x);
m = zeros(l,10);

for i=1:l
    m(i,:) = [dres.fr(i) dres.id(i) dres.x(i) dres.y(i) dres.w(i) dres.h(i) -1 -1 -1 -1];
end

csvwrite(name,m);
end