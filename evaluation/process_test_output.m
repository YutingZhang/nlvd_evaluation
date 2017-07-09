function text_R =  process_test_output(test_output, level_id, subset_name, dataset_name)
   %load the detection result from the user
   gt_file = sprintf('../annotations/%s/%s_gt.mat', dataset_name, subset_name);

   if(~exist(gt_file, 'file'))
       desc2gtmat(sprintf('../annotations/%s', dataset_name), subset_name);
   end

   if ~strcmp(subset_name, 'train')
       gt_info = load(gt_file);
       gt = gt_info.gt;
   else
       gt_info = load7(gt_file);
       gt = gt_info.gt;
   end

   if(level_id>0)
       im2p_file = sprintf('../annotations/%s/level%d_im2p.mat', dataset_name, level_id);
       tmp = load(im2p_file);
       level_im2p = tmp.im2p;
   end

   map_text_R = [];
   custom_texts = [];
   image_id = 0;
   image_count = 0;
   fid = fopen(test_output);

   load_image_info = false;
   tline = fgetl(fid);
   while(ischar(tline))
      if(~isspace(tline(1)))
         if(~isempty(strfind(tline, ':')))
             if(~isempty(custom_texts) & level_id>0 &image_id > 0 & isfield(level_im2p, sprintf('x%d', image_id)))
                  level_texts = level_im2p.(sprintf('x%d', image_id));
                  more_texts = setdiff(level_texts, custom_texts);
                  if(~isempty(more_texts))
                      fprintf('Warning: on level %d, for image %d, some texts should be detected but not exists in your output file.\n', level_id, image_id);
                      more_texts
                  end
                  for k= 1:numel(more_texts)
                      cur_text_id = more_texts(k);
                      text_idx = find(cat(1, image_gt.text_id)==cur_text_id);
                      if(isempty(text_idx))
                      %the AP of this text on this image is 0, availP=[], availS=[], npos=0, PREC=[], REC=[]
                          cur_gtBoxes = [];
                          cur_dcBoxes = [];
                          cur_scores = [];
                      else
                      %the AP of this text on this image is 0, availP=0, availS=0, PREC=0, REC=0, npos=1
                          cur_gtBoxes = image_gt(text_idx).gt_boxes;
                          cur_dcBoxes = [0, 0, 0, 0];
                          cur_scores = [0];
                      end
                      R = struct('image_id', image_id, 'gt_boxes', cur_gtBoxes, 'boxes', cur_dcBoxes, 'scores', cur_scores);
                      if(isempty(map_text_R))
                          map_text_R = containers.Map({int2str(cur_text_id)}, {[R]});
                      else
                          if(~isKey(map_text_R, int2str(cur_text_id)))
                              map_text_R(int2str(cur_text_id)) = [R];
                          else
                              map_text_R(int2str(cur_text_id)) = [map_text_R(int2str(cur_text_id)) ;R];
                          end
                      end
                  end
             end
             image_id = str2num(strtok(tline, ':'));
             image_idx = find(cat(1, gt.image_id)==image_id);
             if(isempty(image_idx))
                 tline = fgetl(fid);
                 load_image_info=false;
                 image_gt = [];
                 continue;
             end
             image_gt = gt(image_idx).text_gt;
             custom_texts = [];
             load_image_info = true;
             image_count = image_count+1;
             fprintf('Processing the result for %dth image with image_id %d\n', image_count, image_id);
         else
             fprintf('Wrong Input Format! \n');
         end
      else
         if(load_image_info & ~isempty(strfind(tline, ':')))
             [cur_text_str, cur_box_str] = strtok(tline, ':');
             cur_text_id = str2num(cur_text_str);
             if(level_id>0) custom_texts = [custom_texts,cur_text_id ]; end
             text_idx = find(cat(1, image_gt.text_id)==cur_text_id);
             if(isempty(text_idx))
                 cur_gtBoxes = [];
             else
                 cur_gtBoxes = image_gt(text_idx).gt_boxes;
             end
             cur_box_str = cur_box_str(3:end);
             cur_dcBoxes = [];
             cur_dcScores = [];
             remain = cur_box_str;
             while(~strcmp(remain,''))
                [token,remain] = strtok(remain, '[]');
                [y1, x1, y2, x2, score] = strread(token, '%d, %d, %d, %d, %f');
                cur_box = [y1, x1, y2, x2];
                cur_dcBoxes = [cur_dcBoxes; cur_box];
                cur_dcScores = [cur_dcScores; score];
             end
             R = struct('image_id', image_id, 'gt_boxes', cur_gtBoxes, 'boxes', cur_dcBoxes, 'scores', cur_dcScores);
             if(isempty(map_text_R))
                map_text_R = containers.Map({int2str(cur_text_id)}, {[R]});
             else 
                if(~isKey(map_text_R, int2str(cur_text_id)))
                    map_text_R(int2str(cur_text_id)) = [R];
                else
                    map_text_R(int2str(cur_text_id)) = [map_text_R(int2str(cur_text_id)) ;R];
                end
             end
         else
             if(load_image_info) fprintf('Wrong Input Format! \n'); end
         end
      end
      tline = fgetl(fid);
   end
   if(~isempty(custom_texts) & level_id>0 &image_id > 0 & isfield(level_im2p, sprintf('x%d', image_id)))
      level_texts = level_im2p.(sprintf('x%d', image_id));
      more_texts = setdiff(level_texts, custom_texts);
      if(~isempty(more_texts))
           fprintf('Warning: on level %d, for image %d, some texts should be detected but not exists in your output file.\n', level_id, image_id);
           more_texts
      end
      for k= 1:numel(more_texts)
         cur_text_id = more_texts(k);
         text_idx = find(cat(1, image_gt.text_id)==cur_text_id);
         if(isempty(text_idx))
            %the AP of this text on this image is 0, availP=[], availS=[], npos=0, PREC=[], REC=[]
            cur_gtBoxes = [];
            cur_dcBoxes = [];
            cur_scores = [];
         else
            %the AP of this text on this image is 0, availP=0, availS=0, PREC=0, REC=0, npos=1
            cur_gtBoxes = image_gt(text_idx).gt_boxes;
            cur_dcBoxes = [0, 0, 0, 0];
            cur_scores = [0];
         end
         R = struct('image_id', image_id, 'gt_boxes', cur_gtBoxes, 'boxes', cur_dcBoxes, 'scores', cur_scores);
         if(isempty(map_text_R))
            map_text_R = containers.Map({int2str(cur_text_id)}, {[R]});
         else
            if(~isKey(map_text_R, int2str(cur_text_id)))
               map_text_R(int2str(cur_text_id)) = [R];
            else
               map_text_R(int2str(cur_text_id)) = [map_text_R(int2str(cur_text_id)) ;R];
            end
         end
      end
   end
   fclose(fid);
        
   text_R = struct('text_id', keys(map_text_R), 'R', values(map_text_R));
   clear map_text_R;
