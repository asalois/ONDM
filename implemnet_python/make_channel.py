import numpy as np
import matplotlib.pyplot as plt
import math

fs = 1

a = np.arange(0,20,0.1)
x = np.cos(a)
b = np.array([0.22, 0.460, 0.688, 0.460, 0.227])

y = np.convolve(x,b)
y_plot = y[0:len(x)]

plt.plot(a,x)
plt.plot(a,y_plot)
plt.show()




