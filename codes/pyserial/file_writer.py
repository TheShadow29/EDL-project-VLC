import sys
print (sys.argv[1])
file_r = open(sys.argv[1],'r')
file_w = open("../tx_using_usb/tx.c",'w')
file_w.write("extern void send_sentence(char*,int);\n")
file_w.write("void send_file()\n{\n")
for line in file_r:
    str1 = 'send_sentence("'
    str1 += line[:-1] + '\\n",' + str(len(line)) + ');\n'
    file_w.write(str1);

file_w.write("}\n")
