## Difficulty levels for detection

For a text phrase, a test image is positive if at least one ground truth region exists for the phrase; otherwise, the image is negative.
- Level-0: The query set was the same as for localization, so every text phrase was tested only on its positive images. (∼43 phrases per image)
- Level-1: For each text phrase, we randomly chose the same number of negative test images as the positive images. (∼92 phrases per image)
- Level-2: The number of negative images were 5 times as the positive and at least 20 (whichever is larger) for each phrase in the test set. (∼775 phrases per image)

As the level went up, it became more challenging for a detector to maintain its precision, as more negative test cases are included. The level-2 set also paid particular attention to infrequent phrases. In the level-1 and level-2 sets, text phrases depicting obvious non-object “stuff”, such as sky, were removed to better fit the detection task.

