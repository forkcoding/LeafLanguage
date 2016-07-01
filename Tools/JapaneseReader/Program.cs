using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Web.Script.Serialization;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace Language
{
    public class VocabularyStruct
    {
        String _Voc;
        public String Voc
        {
            get { return _Voc; }
            set { _Voc = value; }
        }

        String _Ext;
        public String Ext
        {
            get { return _Ext; }
            set { _Ext = value; }
        }

        String _Type;
        public String Type
        {
            get { return _Type; }
            set { _Type = value; }
        }

        String _Meaning;
        public String Meaning
        {
            get { return _Meaning; }
            set { _Meaning = value; }
        }

        double _Time;
        public double Time
        {
            get { return _Time; }
            set { _Time = value; }
        }

        public VocabularyStruct(String voc, double time)
            : this(voc, "", "", "", time)
        {

        }

        public VocabularyStruct(String voc, String ext, String type, String meaning)
            : this(voc, ext, type, meaning, 0)
        {

        }

        public VocabularyStruct(String voc, String ext, String type, String meaning, double time)
        {
            Voc = voc;
            Ext = ext;
            Type = type;
            Meaning = meaning;
            Time = time;
        }
    }

    class JapaneseJson
    {
        private static String JPN_FILE_PATH = "Japanese.txt";
        private static String JPN_OUT_PATH = "../Online/script/Japanese.json";
        private static String JPN_SOUND_DIR = "Sound/";

        private static bool IsJapanese(char c)
        {
            if (IsChinese(c)) return true;
            if (c < 0x3040) return false;
            if (c > 0x30FF) return false;
            return true;
        }

        private static bool IsChinese(char c)
        {
            if (c < 0x4E00) return false;
            if (c > 0x9FBF) return false;
            return true;
        }

        public static void CreateJson()
        {
            String szLine = "";
            String szSoundLine = "";
            //String szDir = System.Environment.CurrentDirectory;

            List<List<VocabularyStruct>> Japanese = new List<List<VocabularyStruct>>();
            List<VocabularyStruct> Lesson = null;

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            StreamReader sr = new StreamReader(JPN_FILE_PATH, Encoding.Default);
            StreamReader soundReader = null;
            int nLessonCount = 1;
            int nVocCount = 0;

            while ((szLine = sr.ReadLine()) != null)
            {
                if (szLine.Contains("第") && szLine.Contains("课"))
                {
                    if (Lesson != null)
                    {
                        Japanese.Add(Lesson);
                        soundReader.Close();
                        Console.WriteLine(nVocCount);
                        nVocCount = 0;
                    }

                    soundReader = new StreamReader(JPN_SOUND_DIR + String.Format("{0:D6}", nLessonCount++) + ".lrc", Encoding.Default);

                    Lesson = new List<VocabularyStruct>();
                }
                else if (!szLine.Contains("----") && szLine != null && szLine != "")
                {
                    szLine.Trim();

                    string[] szSplitArray;
                    szSplitArray = szLine.Split(' ');

                    List<string> szSplitList = szSplitArray.ToList();

                    while (szSplitList.Remove(""));

                    if (szSplitList.Count > 0 && szSplitList.Count <= 3 &&
                            (szSplitList[0][0] == '～' || IsJapanese(szSplitList[0][0])))
                        {
                            // 只有一个日文单词
                            if (szSplitList.Count == 1 && szSplitList[0].Contains("∕"))
                            {
                                string[] szWordSplit = szSplitList[0].Split('∕');

                                foreach (string wordSplit in szWordSplit)
                                {
                                    szSoundLine = soundReader.ReadLine();
                                    szSoundLine.Trim();
                                    String[] szSoundSplitArray = szSoundLine.Split('[', ']', ':');
                                    double dSoundTime = int.Parse(szSoundSplitArray[1]) * 60 + double.Parse(szSoundSplitArray[2]);

                                    VocabularyStruct word = new VocabularyStruct(wordSplit, dSoundTime);
                                    Lesson.Add(word);
                                    nVocCount++;
                                }
                            }
                            else
                            {
                                String szVoc = "";
                                String szExtVoc = "";
                                String szType = "";
                                String szMeaning = "";

                                if (szSplitList.Count > 1)
                                {
                                    if (szSplitList[1][0] == '〔' && szSplitList[1][szSplitList[1].Length - 1] == '〕')
                                    {
                                        szType = szSplitList[1].Substring(1, szSplitList[1].Length - 2);
                                    }
                                    else if (IsChinese(szSplitList[1][0]))
                                    {
                                        szMeaning = szSplitList[1];
                                    }
                                }

                                if (szSplitList.Count > 2)
                                {
                                    szMeaning = szSplitList[2];
                                }

                                string[] szJWordSplit = szSplitList[0].Split('∕');

                                foreach (string wordSplit in szJWordSplit)
                                {
                                    if (wordSplit.Contains("（") && wordSplit.Contains("）"))
                                    {
                                        wordSplit.Trim();

                                        string[] szWordSplit = wordSplit.Split('（', '）');

                                        szVoc = szWordSplit[0];
                                        szExtVoc = szWordSplit[1];
                                    }
                                    else
                                    {
                                        szVoc = wordSplit;
                                        szExtVoc = "";
                                    }

                                    szSoundLine = soundReader.ReadLine();
                                    szSoundLine.Trim();
                                    String[] szSoundSplitArray = szSoundLine.Split('[', ']', ':');
                                    double dSoundTime = int.Parse(szSoundSplitArray[1]) * 60 + double.Parse(szSoundSplitArray[2]);

                                    VocabularyStruct word = new VocabularyStruct(szVoc, szExtVoc, szType, szMeaning, dSoundTime);
                                    Lesson.Add(word);
                                    nVocCount++;
                                }
                            }
                        }
                }
            }

            if (Lesson != null)
            {
                Japanese.Add(Lesson);
                Console.WriteLine(nVocCount);
            }

            var json = serializer.Serialize(Japanese);

            FileStream fs = new FileStream(JPN_OUT_PATH, FileMode.Create);
            StreamWriter sw = new StreamWriter(fs);

            sw.WriteLine(json);
            sw.Flush();
            sw.Close();
        }
    }

    class EnglishJson
    {
        private static String m_szFilePath = "English.txt";
        private static String m_szVocPath = "EngVoc.txt";
        private static String m_szOutPath = "English.json";
        private static int MAX_LESSON_COUNT = 50;

        public static void CreateJson()
        {
            String szLine = "";
            Dictionary<String, KeyValuePair<String, String>> wordDic = new Dictionary<String, KeyValuePair<String, String>>();

            Regex regEnglish = new Regex("^[a-zA-Z]");
            Regex regIndex = new Regex("^[0-9]+(.) .*");

            //
            // Vocabulary Reader
            //

            StreamReader sr = new StreamReader(m_szVocPath, Encoding.Default);

            while ((szLine = sr.ReadLine()) != null)
            {
                szLine.Trim();

                if (szLine == "")
                {
                    continue;
                }

                String[] wordSplit = szLine.Split(' ');

                if (wordSplit.Length > 4)
                {
                    for (int i = 4; i < wordSplit.Length; i++)
                    {
                        wordSplit[3] += " " + wordSplit[i];
                    }
                }

                if (!regEnglish.IsMatch(wordSplit[1]))
                {
                    continue;
                }

                wordDic[wordSplit[1]] = new KeyValuePair<String, String>(wordSplit[2], wordSplit[3]);
            }



            //
            // Main Reader
            //

            int WordCounts = 0;

            List<List<VocabularyStruct>> English = new List<List<VocabularyStruct>>();
            List<VocabularyStruct> lesson = new List<VocabularyStruct>();

            sr.Close();
            sr = new StreamReader(m_szFilePath, Encoding.Default);

            while ((szLine = sr.ReadLine()) != null)
            {
                if (!regIndex.IsMatch(szLine))
                {
                    continue;
                }

                szLine.Trim();

                int startIndex = -1;
                int endIndex = -1;

                for (int i = 0; i < szLine.Length; i++)
                {
                    if (szLine[i] == '.')
                    {
                        startIndex = 0;
                    }
                    else if (Char.IsLetter(szLine[i]) && startIndex == 0)
                    {
                        startIndex = i;
                    }
                    else if (!Char.IsLetter(szLine[i]) && startIndex > 0)
                    {
                        endIndex = i;
                        break;
                    }
                }

                if (startIndex == -1 || endIndex == -1)
                {
                    continue;
                }

                WordCounts++;

                String szWord = szLine.Substring(startIndex, endIndex - startIndex);
                
                KeyValuePair<String, String> wordPair;

                if (!wordDic.TryGetValue(szWord, out wordPair))
                {
                    continue;
                }

                String szCWord = wordPair.Key;
                String szType = "";
                String szMeaning = wordPair.Value;

                VocabularyStruct word = new VocabularyStruct(szWord, szCWord, szType, szMeaning);

                lesson.Add(word);

                if (lesson.Count >= MAX_LESSON_COUNT)
                {
                    English.Add(lesson);
                    lesson = new List<VocabularyStruct>();
                }

            }

            if (lesson.Count > 0)
            {
                English.Add(lesson);
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var json = serializer.Serialize(English);
            //serializer.
            Console.WriteLine(WordCounts);

            FileStream fs = new FileStream(m_szOutPath, FileMode.Create);
            StreamWriter sw = new StreamWriter(fs);

            sw.WriteLine(json);
            sw.Flush();
            sw.Close();
        }
    }

    class Program
    {

        static void Main(string[] args)
        {
            //EnglishJson.CreateJson();
            JapaneseJson.CreateJson();
        }
    }
}
