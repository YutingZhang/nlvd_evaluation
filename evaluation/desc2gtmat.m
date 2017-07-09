function [] = desc2gtmat(data_dir, subset_name)

    if ~strcmp(subset_name, 'train')
        tmp = load(sprintf('%s/%s_region_description.mat', data_dir, subset_name));
        region_description = tmp.region_description;
        im2rid = region_description.im2rid;
        tid2p = region_description.tid2p;
        rid2r = region_description.rid2r;
    else
        [im2rid, rid2r, tid2p] = load_train_region_description(data_dir);
    end
                   
    gt = [];
    ids = vertcat(fieldnames(im2rid));
                   
    for image_idx = 1:numel(ids)
      fieldname = ids{image_idx};
      region_ids = im2rid.(fieldname);
      image_id = str2num(fieldname(2:end));
      fprintf('image_id: %d \n ', image_id);
      text_gt=[];
      for region_idx = 1:size(region_ids,1)
         region_id = region_ids(region_idx, 1);
         fieldname = sprintf('x%d', region_id);
         if(isfield(rid2r, fieldname))
             region_info = rid2r.(fieldname);
         else
             continue;
         end
         phrase_id = region_info.phrase_id;
         x1 = region_info.x+1;
         y1 = region_info.y+1;
         x2 = region_info.x + region_info.width;
         y2 = region_info.y + region_info.height;
         box = [y1, x1, y2, x2];
     
         if(isempty(text_gt) | isempty(find(vertcat(text_gt(:).text_id)==phrase_id)))
             R = struct('text_id', phrase_id, 'gt_boxes', box);
             text_gt = [text_gt; R];
         else
             %fprintf('multiple groundtruth \n');
             idx = find(vertcat(text_gt(:).text_id)==phrase_id);
             text_gt(idx).gt_boxes = [text_gt(idx).gt_boxes; box];
         end 
      end
      RR = struct('image_id', image_id, 'text_gt', text_gt);
      gt = [gt; RR];
   end
   if ~strcmp(subset_name, 'train')
      save(sprintf('%s/%s_gt.mat', data_dir, subset_name), 'gt');
   else
      save7(sprintf('%s/%s_gt.mat', data_dir, subset_name), 'gt');
   end
end
