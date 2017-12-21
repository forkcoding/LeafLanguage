"""Read vocabulary and output to json file."""
import re
import json

VOC_PATH = "EngVoc.txt"
LESSON_PATH = "English.txt"
OUT_PATH = "English.json"
MAX_LESSON_COUNT = 50

def voc_reader():
    """Read the vocabulary."""

    voc_count = 0
    voc_dict = {}
    reg_voc = re.compile(r"^[0-9]+\. (.+) (\[.+\]) (.+)$")
    reg_voc_lite = re.compile(r"^[0-9]+\. ([a-zA-Z\-]+) (.+)$")

    with open(VOC_PATH, 'r') as voc_file:

        for voc_line in voc_file:
            if voc_line == "":
                continue
            voc_line = voc_line.replace("\"", "")
            voc_line = voc_line.replace("\n", "")
            voc_line = voc_line.replace("  ", " ")
            voc_match = reg_voc.match(voc_line) or reg_voc_lite.match(voc_line)
            if not voc_match:
                continue

            if voc_match.lastindex == 2:
                voc_dict[voc_match.group(1)] = ["", voc_match.group(2)]
            elif voc_match.lastindex == 3:
                voc_dict[voc_match.group(1)] = [voc_match.group(2), voc_match.group(3)]

            voc_count = voc_count + 1

        print voc_count

    return voc_dict

def json_reader():
    """Output the vocabulary to json file."""

    words_count = 0
    group_list = []
    lesson_list = []

    reg_word = re.compile(r"[0-9]+\.\s*([a-zA-Z\S]+)")
    voc_dict = voc_reader()

    with open(LESSON_PATH, 'r') as lesson_file:

        for lesson_line in lesson_file:
            lesson_line.strip()
            lesson_line = lesson_line.replace("\xef", " ")
            lesson_line = lesson_line.replace("|", " ")
            word_match = reg_word.match(lesson_line)
            if not word_match:
                continue
            lesson_word = word_match.group(1)
            if not voc_dict.has_key(lesson_word):
                continue

            words_count = words_count + 1

            lesson_list.append({"Type": "",
                                "Voc": lesson_word,
                                "Ext": voc_dict[lesson_word][0],
                                "Meanning": voc_dict[lesson_word][1],
                                "Time": 0})

            if len(lesson_list) >= MAX_LESSON_COUNT:
                group_list.append(lesson_list)
                lesson_list = []

        lesson_len = len(lesson_list)
        if lesson_len > 0:
            group_list.append(lesson_list)

        print words_count

        json_file = open(OUT_PATH, 'w')
        json_file.write(json.dumps(group_list, encoding='utf-8', ensure_ascii=False,
                                   indent=4, sort_keys=True))
        json_file.close()

json_reader()
