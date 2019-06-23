# -*- coding:utf-8 -*-
"""Read English vocabulary and output to json file."""
import re
import json
import codecs

VOC_PATH = '../Source/en/vocabulary.txt'
LESSON_PATH = "English.txt"
OUT_PATH = "English.json"
MAX_WORD_COUNT = 50


def json_save(path, data):
    file = codecs.open(path, 'w', 'utf-8')
    file.write(json.dumps(data, ensure_ascii=False, indent=4, sort_keys=True))
    file.close()


def voc_reader():
    """Read the vocabulary."""
    prefix = '\0'
    voc_count = 0
    voc_dict = {}
    voc_list = []
    lesson_list = []
    reg_voc = re.compile(r'^(\d+)\. ([a-zA-Z\-\' ]+) (\[.+\]) (.+)$')
    reg_voc_lite = re.compile(r'^(\d+)\. ([a-zA-Z\-\' ]+) (.+)$')

    with codecs.open(VOC_PATH, 'r', encoding='utf-8') as f:

        for line in f:
            if line == "":
                continue
            line = line.replace("\"", "")
            line = line.replace("\n", "")
            line = line.replace("  ", " ")
            voc_match = reg_voc.match(line) or reg_voc_lite.match(line)
            if not voc_match:
                continue

            symbol, meaning = "", ""
            orders = int(voc_match.group(1))
            key = voc_match.group(2)
            if voc_match.lastindex == 3:
                meaning = voc_match.group(3)
            elif voc_match.lastindex == 4:
                symbol = voc_match.group(3)
                meaning = voc_match.group(4)

            voc_dict[key] = [symbol, meaning]

            voc_count += 1
            if orders != voc_count:
                print(orders)

            if prefix != '\0' and prefix != key[0].lower():
                lesson_list.append(voc_list)
                voc_list = []

            prefix = key[0].lower()

            voc_list.append({
                "Type": "",
                "Voc": key,
                "Ext": symbol,
                "Meaning": meaning,
                "Time": 0
            })
        print(voc_count)

    json_save(OUT_PATH, lesson_list)

    return voc_dict


def voc2json():
    """Output the vocabulary to json file."""
    words_count = 0
    word_list = []
    lesson_list = []

    reg_word = re.compile(r"[0-9]+\.\s*([a-zA-Z\S]+)")
    voc_dict = voc_reader()

    with open(LESSON_PATH, 'r') as word_file:

        for line in word_file:
            line.strip()
            line = line.replace("\xef", " ")
            line = line.replace("|", " ")
            word_match = reg_word.match(line)
            if not word_match:
                continue
            word_group = word_match.group(1)
            if word_group not in voc_dict:
                continue

            words_count += words_count + 1

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

        print(words_count)

        json_save(OUT_PATH, lesson_list)


if __name__ == "__main__":
    voc_reader()
