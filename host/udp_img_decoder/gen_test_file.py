# coding: utf-8
from bitstring import BitArray

b = BitArray()
for i in range(0, 256):
    b.append(BitArray(uint=i, length=8))
print(' '.join(format(x, '02x') for x in b.bytes))
with open('1.bin', 'wb') as f:
    f.write(b.bytes)
