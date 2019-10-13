import numpy as np
import matplotlib.pyplot as plt
from scipy.fftpack import fft
from scipy.io import wavfile
from scipy import signal


# load data from wave file
fs, xn = wavfile.read("string1.wav")
xn = xn.T[0]


def plot_signal(xn):
    x=np.linspace(0, len(xn), len(xn))
    y=xn
    plt.plot(x[:],y[:])
    plt.show()   

# FIR case
# Impulse response delta(t) = 1 if t=0
#                  delta(t) = 0 if t!= 0
# x(t) delta(t)
# h(t) = alpha delta(t-D) + delta(t)   
# h(-D) = alpha
# h[0] = 1     

a = [1.0]
alpha = 0.9
d = 20000
b= np.zeros(d)
b[0] = 1.0
b[-1] = alpha

plot_signal(xn)
# apply filter
zn = signal.lfilter(b, a, xn)
plot_signal(zn)

# frequency response
freq, freq_response = signal.freqz(b, a)

plot_signal(freq_response)


#IFF case

beta = 0.2
a=[1, 0, 0, beta]
b = [alpha] 

# initial condition
zi = signal.lfilter_zi(b, a)
# apply filter
z, _ = signal.lfilter(b, a, xn, zi=zi*xn[0])







