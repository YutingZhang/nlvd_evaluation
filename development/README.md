# Development APIs in Python and MATLAB

This folder contains APIs to access the data and write test results onto disks. Please make sure the data is downloaded before running the code. You can refer to the [download](../README.md/#download) section in the main [README.md](../README.md).

In both Python and MATLAB APIs, two utility classes (`nlvd_dataset` and `nlvd_test`) are provided. `nlvd_dataset` is for reading annotations, and `nlvd_test` is for dumping test results. The interfaces in Python and MATLAB are largely consistent. 

## Python API

A demo code is available at [`[toolbox_folder]/development/python/demo.py`](python/demo.py).

**Manual**

- `nlvd_dataset.py`: This file defines the class `NLVDDataset` (alias: `nlvd_dataset`), which can be used to retrieve data.
    - Constructor `__init__(dataset_name, subset_name)`: Requires name of the dataset (`vg_v1` is the only choice in the current version) and the subset to create an dataset object. The `subset_name` includes `train`, `test` and `val`.
    - `image_ids_in_subset()`: Return the ids of all images in the subset.
    - `annotation(image_id)`: Return the annotation for an image in a `dict`. Coordinates in the 'region' fields start from 0.
    - `text_id_to_phrase(text_ids)`: Return a list of text phrases specified by the `text_ids`. `text_ids` should be iterable.
    - `test_text_ids(image_id, level_id)`: Return a list of text ids for the test query on the given difficulty level `level_id` and `image_id`. For more details about test difficulty levels, see [here](../docs/vg_v1_det_levels.md).
    - `create_test(test_title, level_id)`: Create an `NLVDTest` (alias: `nlvd_test`) object under the given difficulty level `level_id` (note that localization task is performed on level-`0`) for storing the test results. The result file path will be stored in the folder `[toolbox_folder]/results/[dataset_name]/[test_title]`. See below for details about the `NLVDTest` class.
- `nlvd_test.py`: This file defines the class `NLVDTest` (alias: `nlvd_test`). It can be used to get the test queries and write test results to a file in defined format.
    - Constructor `__init__(dataset, test_dir, level_id)`: Require an `NLVDDataset` object, the folder path `test_dir` for writing the result file, and the test difficulty level `level_id`. The path of the result file is `[test_dir]/level_[level_id].txt`, which is opened during construction. </br>
**It is highly recommended to use the `create_test` function in the `NLVDDataset` object to create the corresponding `NLVDTest` object.**
    - `text_ids(image_id)`: Return a list of text ids for the test query on the given difficulty level and `image_id`.
    - `set_results(image_id, boxes_and_scores)`: It writes the detection/localization result of the image specified by `image_id` to the result file. `boxes_and_scores` is a `dict` with text ids as the keys. For each key, the value is a list of detected bounding box and their scores (e.g., `[box_score_1, box_score_2, ..., box_score_N]`). For each bounding box, it is a 5D-tuple/list (e.g. `box_score=[y1, x1, y2, x2, score]`). The coordinates are 0-based.

    - `finish()`: Tell the object that testing is finished. It flushes and closes the result file.

## Matlab API
A demo code is available at [`[toolbox_folder]/development/matlab/demo.m`](matlab/demo.m).

**Manual**

- `nlvd_dataset.m`: This file defines the class `nlvd_dataset`, which can be used to retrieve data.
    - Constructor `nlvd_dataset(dataset_name, subset_name)`: Requires name of the dataset (`vg_v1` is the only choice in the current version) and the subset to create an dataset object. The `subset_name` includes 'train', 'test' and 'val'.
    - `image_ids_in_subset()`: Return the ids of all images in the subset.
    - `annotation(image_id)`: Return the annotation for an image in a struct with fields 'image_id', 'image_path' and 'regions'. 'regions' is a struct array including the 'x', 'y', 'height', 'width', 'phrase_id' and 'phrase' for each region. Coordinates in the 'regions' fields start from 1.
    - `text_id_to_phrase(text_ids)`: Return a cell array of text phrases specified by the `text_ids`. `text_ids` should be iterable.
    - `test_text_ids(image_id, level_id)`: Return a list of text ids for the test query on the given difficulty level `level_id` and `image_id`. For more details about test difficulty levels, see [here](../docs/vg_v1_det_levels.md).
    - `create_test(test_title, level_id)`: Create an `nlvd_test` object under the given difficulty level `level_id` (note that localization task is performed on level-`0`) for storing the test results. The result file path will be stored in the folder `[toolbox_folder]/results/[dataset_name]/[test_title]`. See below for details about the `nlvd_test` class.
- `nlvd_test.m`: This file defines the class `nlvd_test`. It can be used to get the test queries and write test results to a file in defined format.
    - Constructor `nlvd_test(dataset, test_dir, level_id)`: Require an `nlvd_dataset` object, the folder path `test_dir` for writing the result file, and the test difficulty level `level_id`. The path of the result file is `[test_dir]/level_[level_id].txt`, which is opened during construction. </br>
**It is highly recommended to use the `create_test` function in the `nlvd_dataset` object to create the corresponding `nlvd_test` object.**
    - `text_ids(image_id)`: Return a list of text ids for the test query on the given difficulty level and `image_id`.
    - `set_results(image_id, text_ids, boxes_and_scores)`: It writes the detection/localization result of the image specified by `image_id` to the result file. `text_ids` is a list. `boxes_and_scores` is a cell array with each cell corresponding to each text id in 'text_ids'. For each cell, the value is an matrix including the detection bounding boxes and their scores. Each row of the matrix is a 5D-list (e.g. `[y1, x1, y2, x2, score]`). The coordinates are 1-based.

    - `finish()`: Tell the object that testing is finished. It flushes and closes the result file.



## Result File
The result text file written by the development API (`nlvd_test` class) has the following format. 
<pre>
IMAGE_ID:
    Phrase_Id: [y1, x1, y2, x2, score] [y1, x1, y2, x2, score]
    Phrase_Id: [y1, x1, y2, x2, score] [y1, x1, y2, x2, score]
    ...
    Phrase_Id: [y1, x1, y2, x2, score] [y1, x1, y2, x2, score]
IMAGE_ID:
    ...
</pre>
The coordinates in the result file are **1-based**.

To evaluate the results, please refer to [the evaluation API](../evaluation).
