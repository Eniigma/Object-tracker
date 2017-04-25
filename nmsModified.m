function [bbsGrp,bbsUnion, bbs, bbsIds] = nmsModified( bbs, max_sz,overlap, ovrDnm)

% discard bbs according to size and confidence
kp=bbs(:,3) <max_sz(1) & bbs(:,4) < max_sz(2); bbs=bbs(kp,:); 

if(isempty(bbs)), return; else  [bbsGrp,bbsUnion, bbs, bbsIds] = nmsMax(bbs,overlap,1,ovrDnm); end

  function [bbsGrp,bbsUnion, bbs, bbsIds] = nmsMax( bbs, overlap, greedy,ovrDnm )
    % for each i suppress all j st j>i and area-overlap>overlap
    [~,ord]=sort(bbs(:,5),'descend'); bbs=bbs(ord,:);
    n=size(bbs,1); kp=true(1,n); as=bbs(:,3).*bbs(:,4);
    xs=bbs(:,1); xe=bbs(:,1)+bbs(:,3); ys=bbs(:,2); ye=bbs(:,2)+bbs(:,4);
    
    bbs_count = 0;
    bbsIds = zeros(size(bbs,1),1);
    bbsUnion = zeros(50,4);
    for i=1:n 
      if(greedy && ~kp(i)), continue; end
      
      bbs_count = bbs_count+1;
      bbsIds(i) = bbs_count;
      for j=(i+1):n
        if(kp(j)==0), continue; end
        iw=min(xe(i),xe(j))-max(xs(i),xs(j)); if(iw<=0), continue; end
        ih=min(ye(i),ye(j))-max(ys(i),ys(j)); if(ih<=0), continue; end
        o=iw*ih; if(ovrDnm), u=as(i)+as(j)-o; else u=min(as(i),as(j)); end
        o=o/u; 
        if(o>overlap)
          kp(j)=0; bbsIds(j) = bbs_count;
          xe(i) = max(xe(i), xe(j)); xs(i) = min(xs(i), xs(j));
          ye(i) = max(ye(i), ye(j)); ys(i) = min(ys(i), ys(j));
          as(i) = (xe(i)-xs(i))*(ye(i)-ys(i)); 
        end
      end
      bbsUnion(bbs_count,:) = [xs(i),ys(i),xe(i)-xs(i),ye(i)-ys(i)];
    end
    bbsGrp=bbs(kp>0,:);
    bbsUnion = bbsUnion(1:size(bbsGrp,1),:);
  end
end
