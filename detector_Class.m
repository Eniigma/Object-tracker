classdef detector_Class < handle
  % Detector class
  
  properties
    detector;
    detectorID;
  end
  
  methods
    % Constructor
    function obj = detector_Class(loadModel)
      switch loadModel
        case 1
          load('/home/shubham/mot_benchmark/toolbox/detector/models/AcfCaltech+Detector.mat');
        case 2
          load('/home/shubham/mot_benchmark/toolbox/detector/models/AcfInriaDetector.mat');
      end
      pModify.cascThr = -10;
      nmsParam.type='none';
      pModify.pNms = nmsParam;
      detector = acfModify(detector, pModify);
      obj.detector = detector;
      obj.detectorID = loadModel;
    end
    
    % Get detections. Returns [x,y,w, h]
    function [ bbox ] = detect(obj, frame)
      bbox=acfDetect(frame, obj.detector);
      if(size(bbox,1) > 0)
        bbox = (bbox(:,1:5));
      end
      [bbox,~,~,~] = nmsModified( bbox, [120, 240],0.7, 0);
    end
  end
end