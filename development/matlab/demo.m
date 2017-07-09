fprintf('Create dataset object on test set\n');
nd = nlvd_dataset('vg_v1', 'test');

fprintf('Image list for test set\n');
image_ids_list = nd.image_ids_in_subset()

fprintf('Annotation for the first image');
nd.annotation(image_ids_list(1))

fprintf('Phrase id to text for Phrase 1 and 2\n');
nd.text_id_to_phrase([1,2])

fprintf('Test queries (text ids) for Image 63 in Level 1\n');
nd.test_text_ids(63, 1)

fprintf('Create test object\n')
sample_test = nd.create_test('sample_test_matlab', 1);

fprintf('Alternative interface to get test queries (text ids) for Image 63 in Level 1\n')
sample_test.text_ids(63)

fprintf('Write a very simple sample result to file\n');

%1-based [y1, x1, y2, x2, score] coordinates
boxes_and_scores{1} = [101, 102, 103, 104, 0.11; 105, 106, 107, 108, 0.12];
boxes_and_scores{2} = [201, 202, 203, 204, 0.21; 205, 206, 207, 208, 0.22];
sample_test.set_results(63, [10,20], boxes_and_scores);

sample_test.finish();
sample_test.delete();

