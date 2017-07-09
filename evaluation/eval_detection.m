function [gAP, global_PREC_REC, mAP, text_PREC_REC] =  eval_detection(test_output, level_id, parallel, subset_name, test_title, dataset_name, save_results, DETECTION_IoU_THRESHOLD)
% test_output is the txt file where the user save the result, which is the input file for evaluation

% dataset_name and subset_name is used to find the ground truth information

% level_id helps to decide for each image, which texts should be detected

% save_results is whether the user what to save the evaluation result PREC and REC curves or not

% parallel is whether the user what to parallel process and speed up the evaluation

% DETECTION_IoU_THRESHOLD has default [0.3, 0.5, 0.7]

%gAP: get P and S and npos for each image each text and concatenate all of them and then sort P according to S and then get PREC_REC_all and then calculate AP

%mAP: get P and S and npos for each text and then sort P according to S and then get PREC and REC for each text and then get AP for each text and then get AP_average_text

if ~exist('DETECTION_IoU_THRESHOLD', 'var') || isempty(DETECTION_IoU_THRESHOLD)
   DETECTION_IoU_THRESHOLD = [0.3 0.5 0.7];
end

if ~exist('save_results', 'var') || isempty(save_results)
   save_results = false;
end

if ~exist('dataset_name', 'var') || isempty(dataset_name)
   dataset_name = 'vg_v1';
end

if ~exist('test_title', 'var') || isempty(test_title)
    test_title = 'sample_test';
end


if ~exist('subset_name', 'var') || isempty(subset_name)
    subset_name = 'test';
end

if ~exist('parallel', 'var') || isempty(parallel)
    parallel = false;
end

if ~exist('level_id', 'var') || isempty(level_id)
   level_id = 0;
end

if level_id > 0
   assert(strcmp(subset_name, 'test'), ...
   'only test set has different difficulty level for detection task')
end

text_R = process_test_output(test_output, level_id, subset_name, dataset_name);

if parallel
  [gAP, global_PREC_REC, mAP, text_PREC_REC] =  eval_det_parfor(text_R, level_id, subset_name, test_title, dataset_name, save_results,DETECTION_IoU_THRESHOLD);
else
  [gAP, global_PREC_REC, mAP, text_PREC_REC] =  eval_det_for(text_R, level_id, subset_name, test_title, dataset_name, save_results, DETECTION_IoU_THRESHOLD);
end

