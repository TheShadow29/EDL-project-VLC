data_from_usb = 66

for j in range(8):
    print(( (data_from_usb >> j) & 1) << 2)
