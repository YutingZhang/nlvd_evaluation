import json
import pdb

rd = json.load(open('region_description.json'))
#change phrase_id to phrase_id
for k in rd['rid2r']:
    rd['rid2r'][k]['phrase_id'] = rd['rid2r'][k].pop('categ_id')
ds = json.load(open('subset_splits.json'))
l1 = json.load(open('level1_im2p.json'))
l2 = json.load(open('level2_im2p.json'))
im2s = {}
for k in ds:
    for i in ds[k]:
        im2s[i] = k
train_im2rid = {}
test_im2rid = {}
val_im2rid = {}
unused_im2rid = {}
for iid in rd['im2rid']:
    if im2s.get(int(iid)) is None:
        unused_im2rid[str(iid)] = rd['im2rid'][iid]
    elif im2s[int(iid)] == 'train':
        train_im2rid[str(iid)] = rd['im2rid'][iid]
    elif im2s[int(iid)] == 'test':
        test_im2rid[str(iid)] = rd['im2rid'][iid]
    elif im2s[int(iid)] == 'val':
        val_im2rid[str(iid)] = rd['im2rid'][iid]

train_rid2r = {}
test_rid2r = {}
val_rid2r = {}
unused_rid2r = {}

train_tid2p = {}
test_tid2p = {}
val_tid2p = {}
unused_tid2p = {}

tid2p = rd['tid2p']

for iid in train_im2rid:
    for rid in train_im2rid[iid]:
        train_rid2r[str(rid)] = rd['rid2r'][str(rid)] 
        tid = rd['rid2r'][str(rid)]['phrase_id']
        train_tid2p[str(tid)] = tid2p[str(tid)]

for iid in test_im2rid:
    for rid in test_im2rid[iid]:
        test_rid2r[str(rid)] = rd['rid2r'][str(rid)] 
        tid = rd['rid2r'][str(rid)]['phrase_id']
        test_tid2p[str(tid)] = tid2p[str(tid)]

for iid in l1:
    for tid in l1[iid]:
        test_tid2p[str(tid)] = tid2p[str(tid)]

for iid in l2:
    for tid in l2[iid]:
        test_tid2p[str(tid)] = tid2p[str(tid)]

for iid in val_im2rid:
    for rid in val_im2rid[iid]:
        val_rid2r[str(rid)] = rd['rid2r'][str(rid)] 
        tid = rd['rid2r'][str(rid)]['phrase_id']
        val_tid2p[str(tid)] = tid2p[str(tid)]

for iid in unused_im2rid:
    for rid in unused_im2rid[iid]:
        unused_rid2r[str(rid)] = rd['rid2r'][str(rid)] 
        tid = rd['rid2r'][str(rid)]['phrase_id']
        unused_tid2p[str(tid)] = tid2p[str(tid)]

json.dump({'im2rid': train_im2rid, 'rid2r': train_rid2r, 'tid2p': train_tid2p}, open('train_region_description.json', 'w'))
json.dump({'im2rid': test_im2rid, 'rid2r': test_rid2r, 'tid2p': test_tid2p}, open('test_region_description.json', 'w'))
json.dump({'im2rid': val_im2rid, 'rid2r': val_rid2r, 'tid2p': val_tid2p}, open('val_region_description.json', 'w'))
json.dump({'im2rid': unused_im2rid, 'rid2r': unused_rid2r, 'tid2p': unused_tid2p}, open('unused_region_description.json', 'w'))

