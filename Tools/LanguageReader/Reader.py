"""Read vocabulary and output to json file."""
import re
import json

VOC_PATH = "EngVoc.txt"
LESSON_PATH = "English.txt"
OUT_PATH = "English.json"
MAX_LESSON_COUNT = 50

def voc_reader():
    """Read the vocabulary."""

    voc_dict = {}
    reg_alpha = re.compile("^[a-zA-Z]")

    with open(VOC_PATH, 'r') as voc_file:

        for voc_line in voc_file:
            if voc_line == "":
                continue
            voc_words = voc_line.split(" ")
            if len(voc_words) < 4:
                continue
            if len(voc_words) > 4:
                for i in range(4, len(voc_words)):
                    voc_words[3] += " " + voc_words[i]
            if not reg_alpha.match(voc_words[1]):
                continue
            for i in range(1, 4):
                voc_words[i] = voc_words[i].replace("\"", "")
                voc_words[i] = voc_words[i].replace("\n", "")
            voc_dict[voc_words[1]] = [voc_words[2], voc_words[3]]

    return voc_dict

def json_reader():
    """Output the vocabulary to json file."""

    group_list = []
    lesson_list = []

    reg_index = re.compile("^[0-9]+(.) .*")
    voc_dict = voc_reader()

    with open(LESSON_PATH, 'r') as lesson_file:

        for lesson_line in lesson_file:
            if not reg_index.match(lesson_line):
                continue
            lesson_line.strip()
            start_index = end_index = -1
            for i in range(0, len(lesson_line)):
                if lesson_line[i] == '.':
                    start_index = 0
                elif lesson_line[i].isalpha() and start_index == 0:
                    start_index = i
                elif not lesson_line[i].isalpha() and start_index > 0:
                    end_index = i
                    break

            if start_index == -1 or end_index == -1:
                continue

            lesson_word = lesson_line[start_index: end_index]
            if not voc_dict.has_key(lesson_word):
                continue

            ext = voc_dict[lesson_word][0]
            meaning = voc_dict[lesson_word][1]

            lesson_list.append({"Voc": lesson_word, "Ext": ext, "Type": "", "Meanning": meaning})
            if len(lesson_list) >= MAX_LESSON_COUNT:
                group_list.append(lesson_list)
                lesson_list = []

        lesson_len = len(lesson_list)
        if lesson_len > 0:
            group_list.append(lesson_list)

        json_file = open(OUT_PATH, 'w')
        json_file.write(json.dumps(group_list, encoding='utf-8', ensure_ascii=False,
                                   indent=4, sort_keys=True))
        json_file.close()

json_reader()
