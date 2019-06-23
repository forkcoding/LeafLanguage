# -*- coding:utf-8 -*-
"""Read English vocabulary and output to json file."""
import re
import json

VOC_PATH = "EngVoc.txt"
LESSON_PATH = "English.txt"
OUT_PATH = "English.json"
MAX_WORD_COUNT = 50

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

def voc2json():
    """Output the vocabulary to json file."""
    words_count = 0
    word_list = []
    lesson_list = []

    reg_word = re.compile(r"[0-9]+\.\s*([a-zA-Z\S]+)")
    voc_dict = voc_reader()

    with open(LESSON_PATH, 'r') as word_file:

        for word_line in word_file:
            word_line.strip()
            word_line = word_line.replace("\xef", " ")
            word_line = word_line.replace("|", " ")
            word_match = reg_word.match(word_line)
            if not word_match:
                continue
            word_group = word_match.group(1)
            if not voc_dict.has_key(word_group):
                continue

            words_count = words_count + 1

            word_list.append({
                "Type": "",
                "Voc": word_group,
                "Ext": voc_dict[word_group][0],
                "Meaning": voc_dict[word_group][1],
                "Time": 0
            })

            if len(word_list) >= MAX_WORD_COUNT:
                lesson_list.append(word_list)
                word_list = []

        lesson_len = len(word_list)
        if lesson_len > 0:
            lesson_list.append(word_list)

        print words_count

        json_file = open(OUT_PATH, 'w')
        json_file.write(json.dumps(lesson_list, encoding='utf-8', ensure_ascii=False,
                                   indent=4, sort_keys=True))
        json_file.close()

voc2json()
