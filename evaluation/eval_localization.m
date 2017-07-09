function [topOverlap, ACC] = eval_localization(test_output, subset_name, test_title, dataset_name, save_results, iouT, rankT)
    
if ~exist('rankT', 'var') || isempty(rankT)
    rankT  = 1:10;
end

if ~exist('iouT', 'var') || isempty(iouT)
    iouT  = 0.1:0.1:0.7;
end

if ~exist('save_results', 'var') || isempty(save_results)
    save_results = false;
end

if ~exist('dataset_name', 'var') || isempty(dataset_name)
    dataset_name = 'vg_v1';
end

if ~exist('test_title', 'var') || isempty(test_title)
    test_title = 'sample_test_matlab';
end

if ~exist('subset_name', 'var') || isempty(subset_name)
    subset_name = 'test';
end

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

fid = fopen(test_output);

load_image_info = false;
tline = fgetl(fid); 

k = 0; %k count the number of images
while(ischar(tline))
  if(~isspace(tline(1)))
     if(~isempty(strfind(tline, ':')))
         image_id = str2num(strtok(tline, ':'));
         image_idx = find(cat(1, gt.image_id)==image_id);
         if(isempty(image_idx))
             fprintf('non-existing image %d \n', image_id);
             tline = fgetl(fid);
             image_gt= [];
             load_image_info=false;
             continue;
         end
         image_gt = gt(image_idx).text_gt;
         load_image_info = true;
         if(k>0)
            if numPhrases_k == 0
                ACC_k = ones( [length(iouT),length(rankT),1] );
            else
                ACC_k = mean( double(permute(ACC_k, [2,3,1])), 3 );
            end
            ACC{k}   = ACC_k*numPhrases_k;
            numPhrases(k) = numPhrases_k;
            topOV{k} = topOV_k;
         end
         k = k+1;
         ACC_k = [];
         topOV_k = [];
         numPhrases_k = 0;
         fprintf('Processing the result for %dth image with image_id %d\n', k, image_id);
     else
         fprintf('Wrong Input Format! \n');
     end
  else
     if(load_image_info & ~isempty(strfind(tline, ':')))
         numPhrases_k = numPhrases_k+1;
         [cur_text_str, cur_box_str] = strtok(tline, ':');
         cur_text_id = str2num(cur_text_str);
         text_idx = find(cat(1, image_gt.text_id)==cur_text_id);
         if(isempty(text_idx))
            fprintf('non-existing text %d \n', cur_text_id);
            tline = fgetl(fid);
            continue;
         end
         cur_gtBoxes = image_gt(text_idx).gt_boxes;

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
         if isempty(cur_gtBoxes)
            ov_gt = zeros(size(cur_dcBoxes,1),1);
         else
            ov_gt = zeros(size(cur_dcBoxes,1),size(cur_gtBoxes,1));
            for i = 1:size(cur_gtBoxes,1)
                ov_gt(:,i) = PascalOverlap(cur_gtBoxes(i,:), cur_dcBoxes);
            end
            ov_gt = max(ov_gt,[],2);
         end
         ov_dontcare = zeros(size(cur_dcBoxes,1),1);
         top_pos = find( ov_dontcare<=ov_gt, 1 );
         if isempty(top_pos), top_pos = length(ov_gt); end
         topOV_k = [topOV_k, max( ov_gt(top_pos) )];
         ACC_kj = zeros(length(iouT), length(rankT));
         for i = 1:length(iouT)
            gt_rank = find( ov_gt>=iouT(i), 1 );
            if ~isempty(gt_rank)
                ACC_kj(i,rankT>=gt_rank) = true;
            end
         end
         ACC_k = [ACC_k;reshape(ACC_kj, [1, size(ACC_kj)])];
     end
  end
  tline = fgetl(fid);
end
fclose(fid);
if(k>0)
   if numPhrases_k == 0
      ACC_k = ones( [length(iouT),length(rankT),1] );
   else
      ACC_k = mean( double(permute(ACC_k, [2,3,1])), 3 );
   end
   ACC{k}   = ACC_k*numPhrases_k;
   numPhrases(k) = numPhrases_k;
   topOV{k} = topOV_k;
end

root_dir = fileparts(fileparts(mfilename('fullpath')));
output_dir = fullfile(root_dir, 'results', dataset_name, test_title);
fid = fopen(sprintf('%s/%s_ACC.txt', output_dir,subset_name), 'w');
ACC = seqfun( @plus, ACC{:} )/sum(numPhrases);
fprintf('ACC ')
for i = 1:size(ACC, 1)
  fprintf(fid, '%.3f ', ACC(i, 1));
  fprintf('%.3f ', ACC(i, 1));
end
fprintf(fid, '\n');
fprintf('\n');

topOV = cat( 2, topOV{:} );
topOverlap = struct();
topOverlap.data = topOV;
topOverlap.median = median(topOV);
topOverlap.mean   = mean(topOV);
fprintf(fid, 'topOverlap median: %.3f \n', topOverlap.median);
fprintf('topOverlap median: %.3f \n', topOverlap.median);
fprintf(fid, 'topOverlap mean: %.3f \n', topOverlap.mean);
fprintf('topOverlap mean: %.3f \n', topOverlap.mean);

if(save_results)
   file_prefix = sprintf('%s/%s_', output_dir, subset_name);
   save(strcat(file_prefix,'ACC.mat'), 'ACC');
   save(strcat(file_prefix,'topOverlap.mat'), 'topOverlap');
end

