## Protocol description

The current version of the benchmarking protocol is built upon the [Visual Genome dataset](http://visualgenome.org/api/v0/api_home.html) (V1.2). It contains 108,077 images, where ∼5M regions are annotated with text phrases to densely cover a wide range of visual entities. 

We split the Visual Genome datasets in the same way as in [DenseCap](http://cs.stanford.edu/people/karpathy/densecap/): 77398 images for training, 5000 for validation (tuning model parameters), and 5000 for testing; the remaining 20679 images are not included in the current version of the benchmarking protocol.

The text phrases were annotated from crowd sourcing and included a significant portion of misspelled words. We corrected misspelled words using the [Enchant spell checker](https://www.abisource.com/projects/enchant/) from AbiWord. After that, there were 2,113,688 unique phrases in the training set and 176,794 unique phrases in the testing set. In the test set, about one third (59,303) of the phrases appeared in the training set, and the rest two thirds (117,491) were unseen. About 43 unique phrases were annotated with ground truth regions per image.

