function I = drawBox(bboxes,I)
leng = size(bboxes,1);
for i=1:leng
w = bboxes(i,3);
h = bboxes(i,4);
X = bboxes(i,1) + w/2;
Y = bboxes(i,2) + h/2;

for i=X-w/2:1:X+w/2,
    for j=Y-h/2:h:Y+h/2,
          I(round(j),round(i),1)=0;
          I(round(j),round(i),2)=255;
          I(round(j),round(i),3)=0;       
    end
end
for i=X-w/2:w:X+w/2,
    for j=Y-h/2:1:Y+h/2,
          I(round(j),round(i),1)=0;
          I(round(j),round(i),2)=255;
          I(round(j),round(i),3)=0;          
    end
end
end