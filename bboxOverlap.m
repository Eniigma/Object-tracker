function [iou]=bboxOverlap(bbox1,bbox2)

%%% convert from [x y w h] to [x1 y1 x2 y2]
bbox1(3) = bbox1(1)+bbox1(3);
bbox1(4) = bbox1(2)+bbox1(4);
bbox2(3) = bbox2(1)+bbox2(3);
bbox2(4) = bbox2(2)+bbox2(4);

xx1 = max(bbox1(1), bbox2(1));
yy1 = max(bbox1(2), bbox2(2));
xx2 = min(bbox1(3), bbox2(3));
yy2 = min(bbox1(4), bbox2(4));
w = max(0, xx2 - xx1);
h = max(0, yy2 - yy1);
area = w * h;
iou = area / ((bbox1(3)-bbox1(1))*(bbox1(4)-bbox1(2)) + (bbox2(3)-bbox2(1))*(bbox2(4)-bbox2(2)) - area);

end