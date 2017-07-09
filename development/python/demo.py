from nlvd_dataset import nlvd_dataset

if __name__ == '__main__':
    print('Create dataset object on test set')
    nd = nlvd_dataset(dataset_name='vg_v1', subset_name='test')
    print('Image list for test set')
    image_ids_list = nd.image_ids_in_subset()
    print(image_ids_list)
    print('Annotation for the first image')
    print(nd.annotation(image_id=image_ids_list[0]))
    print('Phrase id to text for Phrase 1 and 2')
    print(nd.text_id_to_phrase(text_ids=[1, 2]))
    print('Test queries (text ids) for Image 63 in Level 1')
    print(nd.test_text_ids(image_id=63, level_id=1))

    print('Create test object')
    sample_test = nd.create_test('sample_test_python', level_id=1)
    print('Alternative interface to get test queries (text ids) for Image 63 in Level 1')
    print(sample_test.text_ids(image_id=63))
    print('Write a very simple sample result to file')
    # 1-based [y1, x1, y2, x2, score] coordinates
    dummy_result = {10: [[100, 101, 102, 103, 0.11], [104, 105, 106, 107, 0.12]],
                    20: [[200, 201, 202, 203, 0.21], [204, 205, 206, 207, 0.22]]}
    sample_test.set_results(63, [10, 20], dummy_result)

