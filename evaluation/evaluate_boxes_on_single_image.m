function [num_gtboxes, p, gtDetectedIds ] = evaluate_boxes_on_single_image( ...
    IoU_threshould, boxes, gtBoxes, gtBoxesNoCare )
% [ p, gtDetectedIds ] = evaluate_boxes_on_single_image( IoU_threshould, boxes, gtBoxes, gtBoxesNoCare )
% p - predicted label (1 - true postive, 0 - false postive, -2 - not care)
% Remark: senstive to the order of boxes when more than 1 boxes fits to the same bbox. 
%   To be consistent with VOC, boxes should be sorted with decreasing confidence.

N  = size(boxes,1);
M1 = size(gtBoxes,1);
M2 = size(gtBoxesNoCare,1);
p = zeros(N,1);

[num_gtboxes, bestIoU, bestIdx] = BestIoU_nonCell( boxes, [gtBoxes; gtBoxesNoCare], M1, M2);

% > IoU threshold
candidateIdx1 = (bestIoU>IoU_threshould);   % bestIdx should > 0

% Do not care
p( candidateIdx1 & bestIdx>M1 ) = -2; % Do not care

% Normal
candidateIdx2 = ( candidateIdx1 & bestIdx<=M1 );

[gtDetectedIds,firstDetectedIdx,~]=unique( bestIdx(candidateIdx2), 'first', 'legacy' );   % find the first detection of the gtboxes
truePosIdxB2 = false( sum(candidateIdx2),1 );
truePosIdxB2( firstDetectedIdx ) = true;
p(candidateIdx2) = truePosIdxB2;

end

