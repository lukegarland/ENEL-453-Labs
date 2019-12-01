import math

for i in range(0,65536):
	print("({}),".format(int(32*math.sin(2*math.pi*i/65536))),end=" ")