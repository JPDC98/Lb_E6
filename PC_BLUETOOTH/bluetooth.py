from typing import Type
import serial
from serial.serialutil import Timeout

try:
    com_serial = serial.Serial(port='COM8',
                            baudrate=9600,
                            bytesize=serial.EIGHTBITS,
                            parity=serial.PARITY_NONE,
                            stopbits = serial.STOPBITS_ONE, 
                            timeout=1)#COM8 en entrada de datos del bluetooth de la PC
    print(com_serial.name)
    while(1):
        datos_bytes = com_serial.read(2)
        datos = [(a/2) for a in datos_bytes]
        print("distancia_1: {} cm distancia_2: {} cm".format(datos[0],datos[1]))   

except:
    com_serial.close()
    print("ERROR")
