import serial
import sys
from time import time

str1 = ''
ser = serial.Serial('/dev/ttyACM0',115200,timeout=0.01)
file_w = open("out_file.txt",'w')
while 1:
    # ser.write(b'G');
    r = ser.read(1)
    if (r != b''):
        str_tmp = r.decode("utf-8")
        # str1 += str_tmp
        # print(str1)
        file_w.write(str_tmp)

        # print(r)
