# Development Toolbox for Benchmarking Natural Language Visual Detection (NLVD)

## Introduction

A benchmarking protocol for visual localization and detection with natural language queries was proposed in [[DBNet](https://arxiv.org/abs/1704.03944)]. This repository provides the development toolbox for implementing this protocol. It includes utilities in both **MATLAB** and **Python 3** for reading the annotations, accessing the test query sets, storing test results in a standard format, etc. It also includes the MATLAB code for evaluating the test results in the way proposed in [[DBNet](https://arxiv.org/abs/1704.03944)].

The current version of the benchmarking protocol is built upon the [Visual Genome dataset](http://visualgenome.org/api/v0/api_home.html) (V1.2).

Please refer to the [DOWNLOAD](#download) section for obtaining necessary data for using this development toolbox.

## Citations

Please cite the following paper for the benchmarking protocol.    

**[Discriminative Bimodal Networks for Visual Localization and Detection with Natural Language Queries](https://arxiv.org/abs/1704.03944)**,
<br>
[Yuting Zhang](http://www.ytzhang.net/), Luyao Yuan, Yijie Guo, Zhiyuan He, I-An Huang, [Honglak Lee](https://web.eecs.umich.edu/~honglak/)
<br>
In *CVPR 2017* **(spotlight)**

Please cite the following paper for the Visual Genome dataset.

**Visual Genome: Connecting Language and Vision Using Crowdsourced Dense Image Annotations**
<br>
Ranjay Krishna, Yuke Zhu, Oliver Groth, Justin Johnson, Kenji Hata, Joshua Kravitz, Stephanie Chen, Yannis Kalantidis, Li Jia-Li, David Ayman Shamma, Michael Bernstein, Li Fei-Fei
<br>
*International Journal of Computer Vision*, Volume 123, Issue 1, Pages 32-73, May 2017 

## Protocol data

The benchmarking protocol on the Visual Genome dataset uses the original text phrase annotations on image regions with the following differences:

* Misspelled words are corrected by the [Enchant spell checker](https://www.abisource.com/projects/enchant/) from AbiWord.
* A period (.) is appended to any text phrase without an ending punctuation. 
* A space character is added between a punctuation and its preceding word. (e.g., "a black cat." becomes "a black cat .")

The annotations are organized in a format that is different from the original Visual Genome annotation data for easier access. 

This benchmark protocol split the datasets into training, validation, and test sets in the same way in [DenseCap](http://cs.stanford.edu/people/karpathy/densecap/). Results should be reported on the test set.

More detailed summary about the dataset can be found [here](docs/vg_v1_statistics.md).

In addition, the benchmarking protocol also provides test query sets (on the test set only) with different difficulty levels for the detection task. More details about the detection test query sets can be found [here](docs/vg_v1_det_levels.md).

<a name="download"></a>
### Downloading the protocol data

The protocol data on the Visual Genome dataset can be obtained by running the following command:

	./annotations/download_vg_v1.sh
	
If you would like to use only the MATLAB APIs, you can alternatively run `./annotations/download_vg_v1_matlab_only.sh` to download only the MAT version of the protocol data.

If you have difficulties in running the above scripts, you can download it manually via [this link](http://www.ytzhang.net/files/dbnet/data/vg_v1_json_splitted.tar.gz) (JSON format for the Python APIs) and [this link](http://www.ytzhang.net/files/dbnet/data/vg_v1_mat_splitted.tar.gz) (MAT format for the MATLAB APIs). Please extract them in `annotations/vg_v1`

More details about the data files can be found [here](docs/vg_v1_data_structure.md).

## Obtaining Visual Genome images

The Visual Genome images can be obtained by running the following command:

	./images/download_vg_v1.sh
	
The images will be extracted in `images/vg`, and a symlink to it will be created as `images/vg_v1`.

You can also obtain the images via the Visual Genome official links, as follows:

* https://cs.stanford.edu/people/rak248/VG_100K_2/images.zip
* https://cs.stanford.edu/people/rak248/VG_100K_2/images2.zip

Note that the Visual Genome images are NOT a contribution of this benchmarking protocol. The script and links are provided here only for the convenience of the users. 

## Development APIs

Development APIs are provided in both Python and MATLAB for accessing annotations and storing test results. 

See the [`development/`](development/) for the API code and the detailed manual.

## Evaluating test results

Evaluation code are provided in MATLAB to measure the localization and detection performance based on stored results. The evaluation statistics, such as average_precision (AP), average accuracy (ACC), are written into text files.

See the [`evaluation/`](evaluation/) for the evaluation code and detailed instructions.
 
## Acknowledgements

A few utility files (`BoxIntersection.m`, `BoxSize.m`, `PascalOverlap.m`) are borrowed from the [selective search toolbox](https://www.koen.me/research/selectivesearch/) developed by Jasper Uijlings et al.
 
Many thanks to **Yijie Guo** and **Luyao Yuan** for their great efforts in developing this toolbox.
