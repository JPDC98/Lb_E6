import numpy as np
import matplotlib.pyplot as plt

def numero_binari_12(bits_int,num):
    escritura = ['0' for a in range(bits_int-len(format(num,'b')))]
    escritura.append(format(num,'b'))
    total = ''.join(escritura)
    return total

a = np.pi/2
b = 3*np.pi/2
espacios = 500

x = np.linspace(a,b,int(espacios))
datos = [(np.sin(float(a))+1)*4096/2 for a in x]
numero_programa = [int(a) for a in datos]
print(len(numero_programa))
f = open("escritura_secuencia_2.txt",'a')
[f.write("\""+numero_binari_12(12,a)+"\""+",") for a in numero_programa]
f.close