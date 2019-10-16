import numpy
# import matplotlib.pyplot as plt


voltage = numpy.linspace(0, 3500, 3500)
x_true = [300, 380, 405, 520, 650, 730, 810, 920, 1050, 1290, 1390, 1585, 1780, 2009, 2350, 2750, 3000]
y_true = [4000, 3500, 3000, 2500, 2000, 1800, 1585, 1400, 1200, 1000, 900, 800, 700, 600, 500, 400, 350]
interploated_distances = numpy.interp(voltage, x_true, y_true)
for i in interploated_distances:
    print("({}),".format(int(round(i))), end=' ')
