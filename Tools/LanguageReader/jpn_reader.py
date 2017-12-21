# -*- coding:utf-8 -*-
"""Read Japanese vocabulary and output to json file."""
import re
import json

FILE_PATH = "Japanese.txt"
OUT_PATH = "Japanese.json"
SOUND_DIR = "Sound/"

def sound_reader(lesson_num):
    """Read the sound."""
    with open(SOUND_DIR + ("%06d" % lesson_num) + ".lrc", 'r') as sound_file:

        sound_match = re.compile(r"^\[([0-9]+)\:([0-9]+\.[0-9]+)\]")
        sound_list = []

        for sound_line in sound_file:
            sound_group = sound_match.match(sound_line)
            if not sound_group:
                print lesson_num, " error!"
                continue
            sound_time = round(int(sound_group.group(1)) * 60 + float(sound_group.group(2)), 2)
            sound_list.append(sound_time)

        return sound_list

def voc_reader():
    """Read the vocabulary."""
    with open(FILE_PATH, 'r') as voc_file:

        voc_list = []
        lesson_list = []

        voc_match = [
            re.compile(r"^(\S+)\s*（(\S*)）\s*〔(\S*)〕\s*(\S+)"),
            re.compile(r"^(\S+)\s*（(\S*)）\s*(\S+)"),
            re.compile(r"^(\S+)\s*〔(\S+)〕\s*(\S+)"),
            re.compile(r"^(\S+)\s*(\S+)")
        ]

        voc_key = [
            {"Voc": 1, "Ext": 2, "Type": 3, "Meaning": 4},
            {"Voc": 1, "Ext": 2, "Type": 0, "Meaning": 3},
            {"Voc": 1, "Ext": 0, "Type": 2, "Meaning": 3},
            {"Voc": 1, "Ext": 0, "Type": 0, "Meaning": 2},
        ]

        match_count = len(voc_match)
        voc_count = 0
        lesson_count = 0

        for voc_line in voc_file:
            if voc_line.find("第") != -1 and voc_line.find("课") != -1:
                voc_len = len(voc_list)
                if voc_len > 0:
                    lesson_list.append(voc_list)

                voc_list = []
                voc_count = 0
                lesson_count = lesson_count + 1
                sound_list = sound_reader(lesson_count)
            elif not voc_line.find("----") != -1 and voc_line != "\n":
                voc_line.strip()

                voc_dict = {}
                for i in range(0, match_count):
                    voc_group = voc_match[i].match(voc_line)
                    if voc_group:
                        for key, value in voc_key[i].items():
                            if value != 0:
                                voc_dict[key] = voc_group.group(value)
                            else:
                                voc_dict[key] = ""
                        break

                if not voc_dict.has_key("Voc"):
                    print voc_line
                    continue

                voc_dict["Time"] = sound_list[voc_count]
                voc_count = voc_count + 1
                voc_list.append(voc_dict)

        voc_len = len(voc_list)
        if voc_len > 0:
            lesson_list.append(voc_list)

        return lesson_list

def voc2json():
    """Output the vocabulary to json file."""
    lesson_list = voc_reader()

    json_file = open(OUT_PATH, 'w')
    json_file.write(json.dumps(lesson_list, encoding='utf-8', ensure_ascii=False,
                               indent=4, sort_keys=True))
    json_file.close()

voc2json()
