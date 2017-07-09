
## Data files 

The protocol data are stored in the json format. We assign unique id for every image and every phrase and use it as the index in our dataset. These ids are the same id we used in all the json files. We use the image ids from Visual Genome dataset, which are not in consecutive numbers. The phrase id starts from 1, and all phrases are ordered according how frequent they appear in the dataset. 

The data for the benchmarking protocol data (after downloading and extracting) are located in `annotations/vg_v1`. The structure of the data is as follows.

- `region_description.json`: It includes the main annotations, which contains three maps:
    - `im2rid`: image id to region id.
    - `rid2r`: region id to region annotations includes bounding box coordinates and phrase id.
    - `tid2p`: phrase id to actual phrase
- `subset_splits.json`: The split of the dataset images by their ids, has keys `'train'`, `'test'` and `'val'`. 
- `?_region_description.json` (`?=train/val/test/unused`): we split `region_description.json` into subsets according to `subset_splits.json` so that the APIs do not need to always load all annotations on the whole dataset. 
- `freq.json`: The frequency of phrase appearing in the dataset, which we used to sample random phrases across images. 
- `level1_im2p.json`: This files stores a map from an image to the phrases that it uses for object detection test with difficulty level1. Use image id as mapping key.
- `level2_im2p.json`: Similar with `level1_im2p.json`, for test with difficulty level2.
- `meteor.json`: A matrix stores the meteor similarity between phrases. [i, j] stores the similarity between phrase i and phrase j. This is a upper triangle matrix. If you use 1-base indexing, i and j are just phrase id.

*Remarks:*

* `?_region_description.json` (`?=train/val/test/unused`) are generated based on `region_description.json` and `subset_splits.json` using `[toolbox_folder]/annotations/vg_v1/split_rd.py`. `?_region_description.json` can be obtained using the default download script, but `region_description.json` is not present by default.
*  MAT files are converted from the json files using `[toolbox_folder]/annotations/vg_v1/json2mat.m`. It uses `save7.m` and `load7.m` (contributed by [Yuing Zhang](http://www.ytzhang.net/)) to save and load >2G variables with mat v7 format (faster access and smaller file size than mat v7.3).
*  The above file conversion steps are illustrated in `[toolbox_folder]/annotations/download_vg_v1_origin.sh`, where the download link for `region_description.json` is provided.

