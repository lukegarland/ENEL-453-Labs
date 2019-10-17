import numpy
# import matplotlib.pyplot as plt


voltage = numpy.linspace(0, 3500, 3500)

x_true = [300, 380, 405, 520, 650, 730, 810, 920, 1050, 1290, 1390, 1585, 1780, 2009, 2350, 2750, 3000]
y_true = [4000, 3500, 3000, 2500, 2000, 1800, 1585, 1400, 1200, 1000, 900, 800, 700, 600, 500, 400, 350]
# x_true = [0, 1380, 1860, 2200, 2760, 3050]
# y_true = [0, 40, 100, 200, 230, 300]
interploated_distances = numpy.interp(voltage, x_true, y_true)
for i in range(len(interploated_distances)):
    print("{}({}),".format(i,int(round(interploated_distances[i]))), end=' ')

