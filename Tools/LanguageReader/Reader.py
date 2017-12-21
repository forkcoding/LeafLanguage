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
    reg_voc = re.compile("^[0-9]+\. ([a-zA-Z]+) (\[.+\]) (.+)$")

    with open(VOC_PATH, 'r') as voc_file:

        for voc_line in voc_file:
            if voc_line == "":
                continue
            voc_line = voc_line.replace("\"", "")
            voc_line = voc_line.replace("\n", "")
            voc_match = reg_voc.match(voc_line)
            if not voc_match:
                continue
            voc_dict[voc_match.group(1)] = [voc_match.group(2), voc_match.group(3)]

    return voc_dict

def json_reader():
    """Output the vocabulary to json file."""

    group_list = []
    lesson_list = []

    reg_index = re.compile("[0-9]+\.")
    reg_word = re.compile("[0-9]+\.\s*([a-zA-Z]+)")
    voc_dict = voc_reader()

    with open(LESSON_PATH, 'r') as lesson_file:

        for lesson_line in lesson_file:
            if not reg_index.match(lesson_line):
                continue
            lesson_line.strip()
            word_match = reg_word.match(lesson_line)
            if not word_match:
                continue
            lesson_word = word_match.group(1)
            if not voc_dict.has_key(lesson_word):
                continue

            ext = voc_dict[lesson_word][0]
            meaning = voc_dict[lesson_word][1]

            lesson_list.append({"Voc": lesson_word, "Ext": ext, "Type": "", "Meanning": meaning, "Time": 0})
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
