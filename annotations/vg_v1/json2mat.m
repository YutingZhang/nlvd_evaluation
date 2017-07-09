fname = 'test_region_description.json';
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
region_description = jsondecode(str);
save('test_region_description.mat', 'region_description');

fname = 'val_region_description.json';
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
region_description = jsondecode(str);
save('val_region_description.mat', 'region_description');

fname = 'unused_region_description.json';
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
region_description = jsondecode(str);
save('unused_region_description.mat', 'region_description');

fname = 'train_region_description.json';
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
region_description = jsondecode(str);
train_im2rid = region_description.im2rid;
train_rid2r = region_description.rid2r;
train_tid2p = region_description.tid2p;

train_im = fieldnames(train_im2rid);
train_im2rid_index = struct();
for k =1:numel(train_im)
    field = train_im{k};
    train_im2rid_index.(field) = k;
end

train_im2rid = struct2cell(train_im2rid);

train_rid = fieldnames(train_rid2r);
train_rid2r_index = struct();
for k=1:numel(train_rid)
    field = train_rid{k};
    train_rid2r_index.(field) = k;
end

train_rid2r = struct2cell(train_rid2r);

train_tid = fieldnames(train_tid2p);
train_tid2p_index = struct();
for k=1:numel(train_tid)
    field = train_tid{k};
    train_tid2p_index.(field) = k;
end

train_tid2p = struct2cell(train_tid2p);
save7('train_region_description.mat', 'train_im2rid_index', 'train_im2rid', 'train_rid2r_index', 'train_rid2r', 'train_tid2p_index', 'train_tid2p');
           

fname = 'level1_im2p.json';
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
im2p = jsondecode(str);
save('level1_im2p.mat', 'im2p');
           
fname = 'level2_im2p.json';
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
im2p = jsondecode(str);
save('level2_im2p.mat', 'im2p');


fname = 'freq.json';
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
freq = jsondecode(str);
save('freq.mat', 'freq');

