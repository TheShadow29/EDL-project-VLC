import serial
import sys
from time import time


while 1:
    try:
        ser = serial.Serial('/dev/ttyUSB2',115200,timeout=0.01)
        print('a')
        # ser.write(b'G');
        r = ser.read(1)
        # if (r != b''):
        print(r)
    except (FileNotFoundError,serial.serialutil.SerialException):
        print("Oops\n")
        
