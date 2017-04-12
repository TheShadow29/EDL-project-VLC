import sys
from pydub import AudioSegment
# print (sys.argv[1])
# file_r = open("tbc.mp3",'r')
# file_w = open("../tx_using_usb/tx.c",'w')
# file_w.write("extern void send_sentence(char*,int);\n")
# file_w.write("void send_file()\n{\n")
# for line in file_r:
    # str1 = 'send_sentence("'
    # str1 += line[:-1] + '\\n",' + str(len(line)) + ');\n'
    # file_w.write(str1);
song = AudioSegment.from_mp3("tbc.mp3")
two_seconds = 0.5*1000
first_two_seconds = song[:two_seconds]
beginning = first_two_seconds + 10;
raw_dat = beginning._data

# print (raw_dat)
beginning.export("begin.mp3",format = "mp3")

    
# file_w.write("}\n")
