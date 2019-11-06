import math

for i in range(0,512):
	print("({}),".format(int(255*math.sin(2*math.pi*i/512))+256),end=" ")

	