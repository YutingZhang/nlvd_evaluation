classdef nlvd_dataset < handle

    properties (GetAccess=public, SetAccess=protected)
        dataset_name
        subset_name
        split_ids
        im2rid
        rid2r
        tid2p
        level1
        level2
        toolbox_path
    end

    methods (Access=public)

        function obj = nlvd_dataset(dataset_name, subset_name)
            obj.toolbox_path = fileparts(fileparts(fileparts(mfilename('fullpath'))));
            if ~exist('dataset_name', 'var') || isempty(dataset_name)
                dataset_name = 'vg_v1';
            end
            if ~exist('subset_name', 'var') || isempty(subset_name)
                subset_name = 'train';
            end
            obj.dataset_name = dataset_name;
            obj.subset_name = subset_name;
            data_dir = fullfile( ...
                    obj.toolbox_path, 'annotations', obj.dataset_name);
            fprintf('Annotatoin directory: %s\n', data_dir);

            fprintf('Loading region descriptions file ... \n');
            if ~strcmp(obj.subset_name, 'train')
                region_mat_file = sprintf('%s/%s_region_description.mat', data_dir, subset_name);
                tmp = load(region_mat_file);
                region_description = tmp.region_description;
                obj.im2rid = region_description.im2rid;
                obj.tid2p = region_description.tid2p;
                obj.rid2r = region_description.rid2r;
            else
                [obj.im2rid, obj.rid2r, obj.tid2p] = load_train_region_description(data_dir);
            end

            fprintf('Loading subset split file ... \n');
            split_file = sprintf('%s/subset_splits.json',data_dir);
            fid = fopen(split_file);
            raw = fread(fid,inf);
            str = char(raw');
            fclose(fid);
            obj.split_ids = jsondecode(str);
                       
            if strcmp(obj.subset_name, 'test')
                fprintf('Loading level1 query file ... \n');
                level1_file = sprintf('%s/level1_im2p.json', data_dir);
                fid = fopen(level1_file);
                raw = fread(fid,inf);
                str = char(raw');
                fclose(fid);
                obj.level1 = jsondecode(str);

                fprintf('Loading level2 query file ...\n');
                level2_file = sprintf('%s/level2_im2p.json', data_dir);
                fid = fopen(level2_file);
                raw = fread(fid,inf);
                str = char(raw');
                fclose(fid);
                obj.level2 = jsondecode(str);
            end
        end
        
        function phrases = text_id_to_phrase(obj, text_ids)
            phrases = [];
            for k =1:numel(text_ids)
                fieldname = sprintf('x%d', text_ids(k));
                phrases= [phrases; {obj.tid2p.(fieldname)}];
            end
        end
        
        function image_ids = image_ids_in_subset(obj)
            image_ids = obj.split_ids.(obj.subset_name);
        end
        
        function image_info = annotation(obj, image_id)
            image_info.image_id = image_id;
            image_dir = fullfile( ...
                                 obj.toolbox_path, 'images', obj.dataset_name);
            if(exist(sprintf('%s/%d.jpg', image_dir, image_id), 'file'))
                image_info.image_path = sprintf('%s/%d.jpg', image_dir, image_id);
            else
                image_info.image_path = sprintf('%d.jpg', image_id);
            end
            image_info.regions = [];
            fieldname = sprintf('x%d', image_id);
            if(isfield(obj.im2rid, fieldname))
                region_ids = obj.im2rid.(fieldname);
            else
                fprintf('no region information exist\n');
            end
            for k = 1:numel(region_ids)
                rid = region_ids(k);
                fieldname = sprintf('x%d', rid);
                region_info = obj.rid2r.(fieldname);
                %here the coordinate of bounding box is 1-based
                region_info.x = region_info.x+1;
                region_info.y = region_info.y+1;
                region_info.phrase = obj.tid2p.(sprintf('x%d', region_info.phrase_id));
                image_info.regions = [image_info.regions; region_info];
            end
        end
        
        function text_ids = test_text_ids(obj, image_id, level_id)
            % every subset should support 
            if ~exist('level_id', 'var') || isempty(level_id)
                level_id = 0;
            end
            if level_id > 0
                assert(strcmp(obj.subset_name, 'test'), ...
                    'only test set has different difficulty level for detection task\n')
            end
            text_ids = [];
            if(level_id==0)
                fieldname = sprintf('x%d', image_id);
                if(isfield(obj.im2rid, fieldname))
                    region_ids = obj.im2rid.(fieldname);
                else
                    fprintf('no text information exist\n');
                end
                for k = 1:numel(region_ids)
                    rid = region_ids(k);
                    fieldname = sprintf('x%d', rid);
                    region_info = obj.rid2r.(fieldname);
                    test_ids =[test_ids; region_info.phrase_id];
                end
            end
            if(level_id==1)
                fieldname = sprintf('x%d', image_id);
                if(isfield(obj.level1, fieldname))
                    text_ids = obj.level1.(fieldname);
                else
                    fprintf('no text information exist\n');
                end
            end
            if(level_id==2)
                fieldname = sprintf('x%d', image_id);
                if(isfield(obj.level1, fieldname))
                    text_ids = obj.level1.(fieldname);
                else
                    fprintf('no text information exist\n');
                end
            end
        end
        
        function test_obj = create_test(obj, test_title, level_id)
            test_dir = fullfile( ...
                obj.toolbox_path, ...
                'results', obj.dataset_name, test_title ...
            );
            test_obj = nlvd_test(obj, test_dir, level_id);
        end
        
    end
end
