function dres = no_of_frames(dres,no_frames)
indices = find(dres.fr == no_frames);
u = max(indices);
dres.x = dres.x(1:u);
dres.y = dres.y(1:u);
dres.w = dres.w(1:u);
dres.h = dres.h(1:u);
dres.r = dres.r(1:u);
dres.fr = dres.fr(1:u);
end