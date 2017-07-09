function [im2rid, rid2r, tid2p] = load_train_region_description(data_dir)
    tmp = load7(sprintf('%s/train_region_description.mat', data_dir));
    im2rid_index = tmp.train_im2rid_index;
    im2rid_cell = tmp.train_im2rid;
    im = fieldnames(im2rid_index);
    im2rid = struct();
    for k=1:numel(im)
        field = im{k};
        idx = im2rid_index.(field);
        rid = im2rid_cell{idx};
        im2rid.(field) =rid;
    end

    rid2r_index = tmp.train_rid2r_index;
    rid2r_cell = tmp.train_rid2r;
    rid = fieldnames(rid2r_index);
    rid2r = struct();
    for k=1:numel(rid)
        field = rid{k};
        idx = rid2r_index.(field);
        r = rid2r_cell{idx};
        rid2r.(field) =r;
    end

    tid2p_index = tmp.train_tid2p_index;
    tid2p_cell = tmp.train_tid2p;
    tid = fieldnames(tid2p_index);
    tid2p = struct();
    for k=1:numel(tid)
        field = tid{k};
        idx = tid2p_index.(field);
        p = tid2p_cell{idx};
        tid2p.(field) =p;
    end

end
