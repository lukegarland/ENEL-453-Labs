import numpy
# import matplotlib.pyplot as plt


voltage = numpy.linspace(0, 3500, 3500)
x_true = [0, 1560, 1860, 2200, 2760, 3050]
y_true = [0, 40, 100, 200, 230, 300]
interploated_distances = numpy.interp(voltage, x_true, y_true)
for i in interploated_distances:
    print("({}),".format(int(round(i))), end=' ')
