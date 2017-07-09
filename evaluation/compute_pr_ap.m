function R = compute_pr_ap( boxes, scores, gtBoxes, ...
    DETECTION_IoU_THRESHOLD, IMSHOW_DETECTION, APmethod )

if ~exist( 'DETECTION_IoU_THRESHOLD', 'var' ) || isempty( DETECTION_IoU_THRESHOLD )
    DETECTION_IoU_THRESHOLD = 0.5;
end

if ~exist( 'IMSHOW_DETECTION', 'var' ) || isempty( IMSHOW_DETECTION )
    IMSHOW_DETECTION = 0;
end

if ~exist('APmethod','var') || isempty(APmethod)
    APmethod = [];
end

%imageN the number of detected boxes
imageN = length(boxes); 
    
[num_gtboxes, p, gtDetectedIds] = evaluate_boxes_on_single_image( DETECTION_IoU_THRESHOLD,boxes, gtBoxes,[]);
resultIndicators = p;  
    
availP = p;
availS = scores;
availB = boxes;
[availS, sortedIdx] = sort( availS, 'descend' );
availP = availP(sortedIdx);
%sum(availP)

npos = num_gtboxes;
tp=cumsum(availP);
fp=cumsum(~availP);
REC  = tp./npos;
PREC = tp./(fp+tp);
AP   = average_precision(REC,PREC,APmethod);
numTP = tp;
numFP = fp;

R = var2struct( npos, PREC, REC, AP, numTP, numFP, availP, availS, availB, DETECTION_IoU_THRESHOLD );
end
