function [dres] = velocity_model(dres,ratio)
no_frames = max(dres.fr);
for i=1:no_frames
    ind = find(dres.fr==i);
    if(i<no_frames-1)
    for k=1:length(ind)
        j = ind(k);
        temp1 = dres.tr1(j).bbox;
        temp2 = dres.tr2(j).bbox;
        vel = temp1(2,1:2)-temp1(1,1:2);
        [dres.tr1(j).bbox,dres.tr2(j).bbox]= fit_motion_model(temp1,temp2,vel,ratio);
    end 
    end
end