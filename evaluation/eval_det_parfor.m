function [gAP_th, global_PREC_REC_th, mAP_th, text_PREC_REC_th] =  eval_det_parfor(text_R, level_id, subset_name, test_title, dataset_name, save_results, DETECTION_IoU_THRESHOLD)
   nThreshold = numel(DETECTION_IoU_THRESHOLD);

   gAP_th = [];
   global_PREC_REC_th ={};
   mAP_th = [];
   text_PREC_REC_th = {};

   root_dir = fileparts(fileparts(mfilename('fullpath')));
   output_dir = fullfile(root_dir, 'results', dataset_name, test_title);
   fid = fopen(sprintf('%s/%s_level%d_AP.txt', output_dir, subset_name, level_id), 'w');

   for threshold_idx = 1:nThreshold
      text_PS = [];
      parfor cur_text_idx = 1:numel(text_R)
         cur_text_id = text_R(cur_text_idx).text_id;
         cur_R=text_R(cur_text_idx).R;
         for cur_R_idx = 1:numel(cur_R)
            gtBoxes = cur_R(cur_R_idx).gt_boxes;
            dcBoxes = cur_R(cur_R_idx).boxes;
            dcScores = cur_R(cur_R_idx).scores;
            image_id = cur_R(cur_R_idx).image_id;
            R= compute_pr_ap(dcBoxes, dcScores, gtBoxes, DETECTION_IoU_THRESHOLD(threshold_idx));
            PS = struct('image_id', image_id, 'P', R.availP, 'S', R.availS, 'npos', R.npos);
            text_PS(cur_text_idx).text_id = cur_text_id;
            text_PS(cur_text_idx).PS(cur_R_idx) = PS;
         end
      end


      all_npos = 0;
      all_PS = [];

      gAP = 0;
      global_PREC_REC = [];
      mAP = 0;
      text_PREC_REC = [];

      parfor cur_text_idx = 1:numel(text_PS)
         P = cat(1, text_PS(cur_text_idx).PS.P);
         all_PS(cur_text_idx).P = P;
         S = cat(1, text_PS(cur_text_idx).PS.S);
         all_PS(cur_text_idx).S = S;
         npos = sum(cat(1, text_PS(cur_text_idx).PS.npos));
         all_npos = all_npos+npos;
         if npos ~=0
            [S, sortedIdx] = sort(S, 'descend' );
            P = P(sortedIdx);

            tp=cumsum(P);
            fp=cumsum(~P);
            REC  = tp./npos;
            PREC = tp./(fp+tp);
            AP   = average_precision(REC,PREC,[]);
            mAP = mAP+AP;
            if(cur_text_idx <= 100)
                text_PREC_REC(cur_text_idx).text_id =  text_PS(cur_text_idx).text_id;
                text_PREC_REC(cur_text_idx).PREC =  PREC;
                text_PREC_REC(cur_text_idx).REC =  REC;
            end
         end
      end
   
      clear text_PS

      all_P = cat(1, all_PS.P);
      all_S = cat(1, all_PS.S);
      clear all_PS
      [S, sortedIdx] = sort(all_S, 'descend' );
      P = all_P(sortedIdx);

      tp=cumsum(P);
      fp=cumsum(~P);
      REC  = tp./all_npos;
      PREC = tp./(fp+tp);
      gAP = average_precision(REC,PREC,[]);
      fprintf('gAP with threshold %.1f is %f\n', DETECTION_IoU_THRESHOLD(1, threshold_idx), gAP);

      fprintf(fid, 'threhshold: %.1f\tgAP: %f\t', DETECTION_IoU_THRESHOLD(1, threshold_idx), gAP);

      global_PREC_REC = struct('PREC',PREC, 'REC', REC);
                         
      mAP = mAP/numel(text_R);
      fprintf('mAP with threshold %.1f is %f\n', DETECTION_IoU_THRESHOLD(1, threshold_idx), mAP);
      fprintf(fid, 'mAP: %f\n', mAP);

      if(save_results)
          file_prefix = sprintf('%s/%s_level%d_th%.1f_', output_dir, subset_name, level_id, DETECTION_IoU_THRESHOLD(1, threshold_idx));
          save(strcat(file_prefix,'text_PR.mat'), 'text_PREC_REC');
          save(strcat(file_prefix,'global_PR.mat'), 'global_PREC_REC');
      end

      gAP_th(threshold_idx) = gAP;
      global_PREC_REC_th{threshold_idx} = global_PREC_REC;
      mAP_th(threshold_idx) = mAP;
      text_PREC_REC_th{threshold_idx} = text_PREC_REC; 
   end
   fclose(fid);
end
