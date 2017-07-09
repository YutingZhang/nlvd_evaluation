function [] =  nlvd_evaluation(test_title, dataset_name, subset_name, parallel)

if ~exist('dataset_name', 'var') || isempty(dataset_name)
    dataset_name = 'vg_v1';
end

if ~exist('subset_name', 'var') || isempty(subset_name)
    subset_name = 'test';
end

if ~exist('parallel', 'var') || isempty(parallel)
    parallel = false;
end

root_dir = fileparts(fileparts(mfilename('fullpath')));
output_dir = fullfile(root_dir, 'results', dataset_name, test_title);

if exist(fullfile(output_dir, 'level_0.txt'), 'file')
    fprintf('Evaluate localization based on the level_0.txt \n');
    eval_localization(fullfile(output_dir, 'level_0.txt'), subset_name, test_title, dataset_name);
    fprintf('Evaluate detection based on level_0.txt \n');
    eval_detection(fullfile(output_dir, 'level_0.txt'), 0, parallel,subset_name, test_title, dataset_name);
end

if exist(fullfile(output_dir, 'level_1.txt'), 'file')
    fprintf('Evaluate detection based on level_1.txt \n');
    eval_detection(fullfile(output_dir, 'level_1.txt'), 1, parallel,subset_name, test_title, dataset_name);
end

if exist(fullfile(output_dir, 'level_2.txt'), 'file')
    fprintf('Evaluate detection based on level_2.txt \n');
    eval_detection(fullfile(output_dir, 'level_2.txt'), 2, parallel,subset_name, test_title, dataset_name);
end


