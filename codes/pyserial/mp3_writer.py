import sys
import binascii

# print (sys.argv[1])
# file_r = open("begin.mp3",'rb')
file_r = "begin.mp3"
file_w = open("../tx_using_usb/tx.c",'w')
file_w.write("extern void send_sentence(char*,int);\n")
file_w.write("void send_file()\n{\n")

with open(file_r,'rb') as f:
    content = f.read()

# print(binascii.hexlify(content))
print(content)
# file_w.write("}\n")
