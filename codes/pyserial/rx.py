import serial
import sys
from time import time

ser = serial.Serial('/dev/ttyUSB0',115200,timeout=0.01)
while 1:
    # ser.write(b'G');
    r = ser.read(1)
    # if (r != b''):
    print(r)
