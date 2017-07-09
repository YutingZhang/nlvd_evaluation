import os.path as osp
import os


class NLVDTest:
    # dataset is a nlvd_dataset object created
    def __init__(self, dataset, test_dir, level_id):
        if not osp.exists(test_dir):
            os.makedirs(test_dir)
        self.dataset = dataset
        self.test_dir = test_dir
        self.level_id = level_id
        self.is_finished = False
        self.f = open(osp.join(self.test_dir, "level_%d.txt" % level_id), 'w')

    def text_ids(self, image_id):
        test_text_ids = self.dataset.test_text_ids(image_id, self.level_id)
        return test_text_ids

    # a function to write test result to a file in proper format
    # boxes_and_scores should be a map 
    # {phrase_id1: [[y1, x1, y2, x2, score1], [y1, x1, y2, x2, score2], ...]}
    # each phrase id maps with a list of detection results (bounding box coordinates with score)
    # all coordinates are 0-based
    def set_results(self, image_id, text_ids, boxes_and_scores):
        self.f.write(str(image_id) + ":")
        for t_id in text_ids:
            self.f.write("\n\t%s:" % t_id)
            # output the region informations
            regions = boxes_and_scores[t_id]
            for idx, box in enumerate(regions):
                # write in order [y1, x1, y2, x2]
                self.f.write(
                    " [%d, %d, %d, %d, %.6f]" %
                    (box[0] + 1, box[1] + 1, box[2] + 1, box[3] + 1, box[4])
                )
        self.f.write("\n")

    def finish(self):
        self.f.close()
        self.is_finished = True


nlvd_test = NLVDTest

