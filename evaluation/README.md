This folder contains APIs in MATLAB for evaluating stored test results (see [../development](../development) for storing test results). 

## Standard evaluation (Just one command in MATLAB)

`nlvd_evaluation` computes the performance metrics described in [DBNet](https://arxiv.org/abs/1704.03944), which are summarized as follows: 

* For localization tasks, it computes *recalls* (or, accuracies) and *mean/median IoUs* (IoU: intersection over union between detected region and the ground truth region), where the level-0 query set is used.
* For detection tasks, it computes detection *mean AP (mAP)* and *global AP (gAP)* for the level-0,1,2 query sets. AP: average precision. 

*Remark:* please refer to [the paper of PASCAL VOC challenge](http://host.robots.ox.ac.uk/pascal/VOC/pubs/everingham15.pdf) (The PASCAL Visual Object Classes Challenge: A Retrospective) if you are not familiar with the IoU and AP.

The evaluation command line in MATLAB is

	nlvd_evaluation(test_title, dataset_name, subset_name, parallel)

The function computes the performance metrics for all results stored in `[toolbox_folder]/results/[dataset_name]/[test_title]`. `'vg_v1'` is the default value for `dataset_name` and the only choice in the current version. If `level-0.txt` exists, it computes the localization metrics and detection APs on the level-0 query set. For `level-?.txt` (`?>0`), detection APs are computed. 

`subset_name` need to be specified to `test` (the default) or `val`, so that the function can load the annotations accordingly.  

`parallel` should be either `true` or `false` (the default). When it is set to `true`, MATLAB parallel toolbox is used for faster processing (with more memory usage). If memory allows, parallel computation is recommended. The non-parallel evaluation can take hours to finish.

**Remark:** *for an argument with default value, the empty array `[]` or no input means using the default value. This rule also holds for functions mentioned later in this README.md file.* 

### Result format

`[subset_name]_ACC.txt`: This file saved in folder `results/[dataset_name]/[test_title]`, is for the localization performance metrics (only for the level-0 query set). It contains the localization recall for the top-1 predictions under the IoU thresholds `[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7]` and the mean/median IoU. Here is an example file ([DBNet](https://arxiv.org/abs/1704.03944) with VGGNet-16):

>		0.559 0.468 0.390 0.314 0.241 0.169 0.101
>		topOverlap median: 0.162
>		topOverlap mean: 0.263

Note that, when multiple ground truth regions are presented on a single image, the best matched one is used. That is why the mean and median IoUs are noted as "topOverlap mean" and "topOverlap median".

`[subset_name]_level?_AP.txt` `?=0,1,2`: This file saved in `results/[dataset_name]/[test_title]`, is for the detection performance metrics. It contains the gAP and mAP for the IoU thresholds [0.3, 0.5, 0.7]. Here are some example files:

* [DBNet](https://arxiv.org/abs/1704.03944) with VGGNet-16 on the level-0 query set

>		threhshold: 0.3	gAP: 0.235691	mAP: 0.487341
>		threhshold: 0.5	gAP: 0.109252	mAP: 0.304111
>		threhshold: 0.7	gAP: 0.021150	mAP: 0.117586

* [DBNet](https://arxiv.org/abs/1704.03944) with VGGNet-16 on the level-1 query set

>		threhshold: 0.3	gAP: 0.205841	mAP: 0.453660
>		threhshold: 0.5	gAP: 0.096192	mAP: 0.285768
>		threhshold: 0.7	gAP: 0.018961	mAP: 0.111969

* [DBNet](https://arxiv.org/abs/1704.03944) with VGGNet-16 on the level-2 query set

>		threhshold: 0.3	gAP: 0.080186	mAP: 0.269943
>		threhshold: 0.5	gAP: 0.038967	mAP: 0.177297
>		threhshold: 0.7	gAP: 0.008379	mAP: 0.074776

### Evaluating example results

Note that you do not have to do this for using the evaluation code. This section just gives you an example of the actual stored results and its evaluation procedure. 

You can download our example test results by running the following command:

	[toolbox_folder]/results/vg_v1/dbnet_vgg16/download.sh

It downloads the test results for [DBNet](https://arxiv.org/abs/1704.03944) based on VGGNet-16. If you have problems running the script, you can obtain it via [this link](http://www.ytzhang.net/files/dbnet/results/vg_v1_vggnet16_sample_test.tar.gz) and extract it in `[toolbox_folder]/results/vg_v1/dbnet_vgg16/`.

After obtaining the example test results, you can compute the performance metrics by running the following command in MATLAB:

	nlvd_evaluation('dbnet_vgg16', 'vg_v1', false)

Another set of example test results are available via `[toolbox_folder]/results/vg_v1/dbnet_resnet101/download.sh` or [this link](http://www.ytzhang.net/files/dbnet/results/vg_v1_resnet101_sample_test.tar.gz)

## More flexible interfaces

In addition to the standard evaluation interface, we also provides more flexible APIs for computing the performance metrics. 

### Evaluating localization performance 

	[topOverlap, ACC] = eval_localization(test_output, subset_name, test_title, dataset_name, save_results, iouT, rankT)

- Input arguments:
    - `test_output`: The path to the test output txt file (e.g., `[toolbox_folder]/results/[dataset_name]/[test_title]/level_0.txt`). Note that localization is only applicable to the level-0 query set.
    - `subset_name`: should be `'train'`, `'val'` or `'test'` (default). It specifies which subset to load for the ground truth annotations.
    - `test_title`: the title of the experiment. The default value is `'sample_test'`.
    - `dataset_name`: `'vg_v1'` is the only choice in the current version, and the default value is `'vg_v1'`.
    - `save_results`: `true` or `false`, specifying whether to save the localization accuracy in mat files (`[subset_name]_ACC.mat` and `[subset_name]_topOverlap.mat`) in the folder `results/[dataset_name]/[test_title]`. The default value is `false`.   
    - `iouT`: IoU thresholds for localization recalls. It should be a vector of float numbers between 0 and 1, and the default value is `[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7]`.
    - `rankT`: `rankT=k` means computing the localization metrics based on the best out of the top-`k` predictions. By default, it outputs results for for the ranks `[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]`.

- Returns:
    - `topOverlap`: the overlap (IoU) between the best matched prediction and the ground truth. Note that there are multiple predicted regions when the rank is greater than 1, and there may be multiple ground truth regions on a single image.
    - `ACC`: a matrix of localization accuracy (or, recall), with each column corresponding to a rank and each row corresponding to an IoU threshold.

- Display:
	- The first column of `ACC` and mean/median IouS are printed out. The results are also saved in the folder `results/[dataset_name]/[test_title]` with file name `[subset_name]_ACC.txt`

For example, given a test result file for the level-0 query set stored in `[toolbox_folder]/results/vg_v1/sample_test/level_0.txt`, you can use the following commands to run the default evaluation on the test set:

	test_output='[toolbox_folder]/results/vg_v1/sample_test/level_0.txt'
	eval_localization(test_output)

Then `test_ACC.txt` will be saved in folder `[toolbox_folder]/results/vg_v1/sample_test`.

### Evaluating detection performance

`[gAP, global_PREC_REC, mAP, text_PREC_REC] =  eval_detection(test_output, level_id, parallel, subset_name, dataset_name, save_results, DETECTION_IoU_THRESHOLD)`

- Input arguments:
    - `test_output`: The path to the test output txt file (e.g., `[toolbox_path]/results/[dataset_name]/[test_title]/level_[level_id].txt`).
    - `level_id`: can be `0` (the default), `1`, or `2`. For more details about test difficulty levels, see [here](../docs/vg_v1_det_levels.md).
    - `parallel`: Use MATLAB parallel computing toolbox or not. It should be `true` or `false` (the default). The parallelism can potentially lead to a very significant speedup, so it is highly recommended to enable it if possible.  
    - `subset_name`: should be `'train'`, `'val'` or `'test'` (default). It specifies which subset to load for the ground truth annotations. Note that, in the current version, the level-1 and level-2 query sets are available only for the test set.
    - `test_title`: the title of the experiment. The default value is `'sample_test'`.
    - `dataset_name`: `'vg_v1'` is the only choice in the current version, and the default value is `'vg_v1'`.
    - `save_results`: `true` or `false`, specifying whether to save the global precision-recall (PR) curve into the file `[subset_name]_level[level_id]_th[detection_iou]_global_PR.mat` and the PR curves for the 100 most frequent text phrases (the 100 text phrase with the lowest text IDs) into `[subset_name]_level[level_id]_th[detection_iou]_text_PR.mat` in the folder `results/[dataset_name]/[test_title]`. The default value is `false`.
    - `DETECTION_IoU_THRESHOLD`: a vector of float numbers between 0 and 1 for specifying the IoU threshold for determining positive detections. The default value is `[0.3, 0.5, 0.7]`.

- Returns:
    - `gAP`: a vector of global APs. Each element corresponds to a detection threshold (note that the input `DETECTION_IoU_THRESHOLD` is a vector of detection threshold). For each detection threshold, average precision (AP) is calculated over all test cases across all images.
    - `global_PREC_REC`: a cell vector of global PR curves, where each cell corresponds to a detection threshold. More concretely, each cell is a struct with fields `PREC` and `REC`.
    - `mAP`: a vector of mean APs. Each element is the mean average precision under a detection threshold. For each detection threshold, the APs are first calculated for each query phrases, and then the mean value of the APs over all query phrases are computed.
    - `text_PREC_REC`: a cell vector, where each cell corresponds to a detection threshold. Each cell contains a struct array with 100 elements, each of which includes the text ID and PR curve for the 100 most frequent query phrases.

- Display:
    - gAP and mAP for each detection threshold are printed out. The results are also saved in the folder `results/[dataset_name]/[test_title]` with file name `[subset_name]_level[level_id]_AP.txt`.

For example, given a test result file for the level-0 query set stored in `[toolbox_folder]/results/vg_v1/sample_test/level_0.txt`, you can use the following commands to run the default evaluation on the test set:

	test_output='[toolbox_folder]/results/vg_v1/sample_test/level_0.txt'
	eval_detection(test_output)

To use parallel processing, you can run

	eval_detection(test_output, [], true)
where `[]` means using the default value for the second argument `level_id`.

Then `test_level0_AP.txt` will be saved in folder `[toolbox_folder]/results/vg_v1/sample_test`.

