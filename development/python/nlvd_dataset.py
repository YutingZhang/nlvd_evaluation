import json
import os.path as osp
from nlvd_test import nlvd_test


class NLVDDataset:

    def __init__(self, dataset_name='vg_v1', subset_name='train'):
        self.dataset_name = dataset_name
        self.root_dir = osp.dirname(osp.dirname(osp.dirname(osp.abspath(__file__))))
        self.data_dir = osp.join(self.root_dir, 'annotations', self.dataset_name)
        self.image_dir = osp.join(self.root_dir, 'images') 
        self.subset_name = subset_name
        print('Loading region description file ...')
        self.raw_data = json.load(open(osp.join(self.data_dir, '%s_region_description.json' % self.subset_name)))
        self.im2rid = self.raw_data['im2rid']
        self.rid2r = self.raw_data['rid2r']
        self.tid2p = self.raw_data['tid2p']
        print('Loading subset split file ...')
        self.raw_split = json.load(open(osp.join(self.data_dir, 'subset_splits.json'), 'r'))
        self.image_ids = self.raw_split.get(subset_name)
        if self.image_ids is None:
            raise ValueError('Please enter valid subset name <train|val|test>')
        if self.subset_name == "test":
            print('Loading level1 query file ...')
            self.level1 = json.load(open(osp.join(self.data_dir, 'level1_im2p.json'), 'r'))
            print('Loading level2 query file ...')
            self.level2 = json.load(open(osp.join(self.data_dir, 'level2_im2p.json'), 'r'))
    
    # return the image ids in the split
    def image_ids_in_subset(self):
        return self.image_ids

    # return a data dict for the query image id
    def annotation(self, image_id):
        data = {'image_id': image_id, 'regions': [],
                'image_path': osp.join(self.image_dir, '%s.jpg' % str(image_id))} 
        rids = self.im2rid[str(image_id)]
        for rid in rids:
            region = self.rid2r[str(rid)]
            region['phrase'] = self.tid2p[str(region['phrase_id'])]
            data['regions'].append(region)
        return data
    
    # return a list of phrases by given phrase ids
    def text_id_to_phrase(self, text_ids):
        phrases = []
        for tid in text_ids:
            phrases.append(self.tid2p[str(tid)])
        return phrases
    
    # return a list of required test phrases given test level and image ids
    def test_text_ids(self, image_id, level_id):
        if level_id == 0:
            text_ids = [self.rid2r[str(rid)]['phrase_id'] for rid in self.im2rid[str(image_id)]]
        elif level_id == 1:
            text_ids = self.level1[str(image_id)]
        elif level_id == 2:
            text_ids = self.level2[str(image_id)]
        else:
            raise ValueError('Please enter valid level <0|1|2>')
        return text_ids 
    
    def create_test(self, test_title, level_id):
        test_dir = osp.join(self.root_dir, 'results', self.dataset_name, test_title)
        return nlvd_test(self, test_dir, level_id)


nlvd_dataset = NLVDDataset


