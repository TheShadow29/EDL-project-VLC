count = 0

while 1:
    if count % 2 == 1:
        a = 0
    else:
        a = 1
    if count % 4 == 2:
        b = 1
    elif count % 4 == 0:
        b = 0
        count = 0
    print ("A:"+ str(a) + " B:" +str(b))
    count+=1
