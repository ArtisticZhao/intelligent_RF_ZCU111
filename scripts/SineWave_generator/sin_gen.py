from mat4py import loadmat
from bitstring import BitArray
data = loadmat('matlab.mat')


yh = []
f = open('sin_waveform.txt', 'w')
for each in data['y']:
    if each == 32768:
        each = 32767
        print("too big!")
    hex_string = str(BitArray(int=int(each), length=16).hex)
    yh.append(hex_string)
    f.write(hex_string + ',\n')
f.close()
