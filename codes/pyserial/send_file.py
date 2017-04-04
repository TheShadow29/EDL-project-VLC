import serial
import sys
from time import time

ser = serial.Serial('/dev/ttyUSB0',115200,timeout=0.01)
# print(ser.name)
# while 1:
# ser.write(b'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG')
file_name = './file.txt'
# for i in sys.argv:
#     # print (i)

# t = time()
# fc = 0
with open(file_name) as f:
    while 1:
        c = f.read(1)
        if not c:
            print ("EOF")
            break
        ser.write(c.encode('ascii'))
    # #         # r = conn.read(1)
        # #         # print(r)
        # # #         fc += 1

# tt = time() - t;

# print ("Sent " + str(fc) + " Bytes")
