function [num_gtboxes, bestIoU, bestGtIdx] = BestIoU_nonCell( boxes, gtBoxes, M1, M2)

N1 = size( boxes , 1 );

bestIoU   = zeros( N1,1 );
bestGtIdx = zeros( N1,1 );

deleted_gtbox = false(M1, 1);
if isempty( gtBoxes )
    bestIoU(:) = 0;  % already 0 ...
    num_gtboxes = 0;
else
    %deal with the replicate annotation
    for i = 1:N1
      box = boxes(i,:);
      s = PairedIoU( box, gtBoxes ).';
      s([deleted_gtbox;false(M2,1)]) = -1;
      [bestiou, bestgtidx] = max(s,[],1);
      if bestgtidx <= M1 
        gt_S = PairedIoU( gtBoxes(bestgtidx,:), gtBoxes(1:M1,:) ).';
        rep = (gt_S > 0.9);
        deleted_gtbox(rep) = true;
        deleted_gtbox(bestgtidx) = false; 
      end
    end
    S = PairedIoU( boxes, gtBoxes ).';
    S([deleted_gtbox;false(M2,1)],:) = -1;
    [bestIoU(:), bestGtIdx(:)] = max( S, [], 1 );
    bestGtIdx(bestIoU<=0) = 0;

    num_gtboxes = sum(~deleted_gtbox);
end

end

