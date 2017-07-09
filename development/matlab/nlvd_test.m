classdef nlvd_test < handle
    
    properties (GetAccess=public, SetAccess=protected)
        dataset
        test_dir
        level_id
        is_finished
        fid
    end

    methods (Access=public)
        function obj = nlvd_test(dataset, test_dir, level_id)
            obj.dataset = dataset;
            obj.test_dir = test_dir;
            obj.level_id = level_id;
            if ~exist(obj.test_dir, 'file')
                mkdir(obj.test_dir)
            end
            obj.is_finished = false;
            % create the text files
            obj.fid = fopen(sprintf('%s/level_%d.txt', test_dir, level_id), 'w');
        end
        
        function test_text_ids = text_ids(obj, image_id)
            test_text_ids = obj.dataset.test_text_ids( ...
                image_id, obj.level_id);
        end

        % boxes_and_scores is an cell array, each cell conrresponding to one text_id.
        % The array in the cell is [y1, x1, y2, x2, score] and the coordinate is 1-based
        function set_results(obj, image_id, text_ids, boxes_and_scores)
            fprintf(obj.fid, '%d:\n', image_id);
            for k = 1:numel(text_ids)
                tid = text_ids(k);
                bs = boxes_and_scores{k};
                fprintf(obj.fid,'\t%d:', tid);
                for j=1:numel(boxes_and_scores)
                    fprintf(obj.fid, ' [%d, %d, %d, %d, %.6f]', bs(j,1), bs(j,2), bs(j,3), bs(j,4), bs(j,5));
                end
                fprintf(obj.fid, '\n');
            end

        end
        
        function finish(obj)
            % close the result files
            fclose(obj.fid);
            obj.is_finished = true;
        end
        
        function delete(obj)
            if ~obj.is_finished
                obj.finish()
            end
        end
        
    end

end
