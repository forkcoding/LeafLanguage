import re
import json
import codecs

def EReader():
    szFilePath = "English.txt"
    szVocPath  = "EngVoc.txt"
    szOutPath  = "English.json"
    MAX_LESSON_COUNT = 50

    reEng = re.compile("^[a-zA-Z]")
    reInx = re.compile("^[0-9]+(.) .*")

    wordDic = {}

    with codecs.open(szVocPath, 'r') as fl:

        for line in fl :
            if line == "" :
                continue
            words = line.split(" ");
            if len(words) < 4 :
                continue
            if len(words) > 4 :
                for i in range(4, len(words)) :
                    words[3] += " " + words[i];
            if not reEng.match(words[1]) :
                continue
            for i in range(1, 4) :
                words[i] = words[i].replace("\"", "")
                words[i] = words[i].replace("\n", "")
            
            pairs = [words[2], words[3]]
            wordDic[words[1]] = pairs

    with open(szFilePath, 'r') as fl:

        wordCount = 0
        eJson = []
        lesson = []

        for line in fl :
            if not reInx.match(line) :
                continue;
            line.strip()
            startIndex = endIndex = -1
            for i in range(0, len(line)) :
                if line[i] == '.' :
                    startIndex = 0;
                elif line[i].isalpha() and startIndex == 0 :
                    startIndex = i
                elif not line[i].isalpha() and startIndex > 0 :
                    endIndex = i
                    break

            if startIndex == -1 or endIndex == -1 :
                continue

            wordCount = wordCount + 1

            szWord = line[startIndex: endIndex]
            if not wordDic.has_key(szWord) :
                continue

            ext = wordDic[szWord][0]
            meaning = wordDic[szWord][1]

            lesson.append({"Voc": szWord, "Ext": ext, "Type": "", "Meanning": meaning})
            if len(lesson) >= MAX_LESSON_COUNT :
                eJson.append(lesson)
                lesson = []

        if len(lesson) > 0 :
            eJson.append(lesson)

        fJson = open(szOutPath, 'w')
        fJson.write(json.dumps(eJson, encoding='utf-8', ensure_ascii=False, indent = 4, sort_keys = True))
        fJson.close()

EReader()