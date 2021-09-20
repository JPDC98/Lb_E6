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
        datos_bytes = com_serial.read(1)
        numero = int.from_bytes(datos_bytes,"big")
        distancia = numero/2
        print("distancia: {} cm".format(distancia))


except:
    com_serial.close()
    print("ERROR")
