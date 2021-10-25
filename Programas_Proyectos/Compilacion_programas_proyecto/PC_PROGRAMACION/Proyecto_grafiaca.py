import matplotlib.pyplot as plt
import matplotlib.animation as creador
import serial
import threading
import numpy as np

datos_t = [[],[],[],[]]
muestras = 200
num_sensores = 4
todo_pas = 0

def conexion(out_data):
    try:
        com_serial = serial.Serial(port='COM6',#Poner dirección del dispositivo si es sistema linux; Windows verificar puerto asignado al bluetooth.
                            baudrate=115200, #Velidicad de recepción de datos, HC-06 por defecto esta a 9600, si utilizamos otro baudrate hay que modificarlo.
                            bytesize=serial.EIGHTBITS, #Numero de bits a contar y empaquetar
                            parity=serial.PARITY_NONE, #Desabilitamos bits de paridad por el momento
                            stopbits = serial.STOPBITS_ONE, #Se detiene la recepción de datos cuando se detecta un estado alto. 
                            timeout=None)#Se epera por tiempo indefinido los bytes
        print(com_serial.name) #imprimimos el puerto serial a utilizar, conexión correcta
        while(1):        
            datos = com_serial.read(6) #Leemos los dos bits enviados de la FPGA
            out_data[0].append(datos[0])
            out_data[1].append(datos[1])
            out_data[2].append(datos[4])
            out_data[3].append(datos[5])

            if len(out_data[0]) > muestras:
                out_data[0].pop(0)
            if len(out_data[1]) > muestras:
                out_data[1].pop(0)
            if len(datos_t[2]) > muestras:
                out_data[2].pop(0)
            if len(datos_t[3]) > muestras:
                out_data[3].pop(0)   
    except:
        print("ERROR EN LA CONEXION") # se nos hace saber que hubo un error.

t_1 = threading.Thread(name="hilo1",target=conexion, args=(datos_t,))
t_1.start()

def inicio():
    ax.set_xlim(0,muestras)
    ax.set_ylim(-200,200)
    del x1data[:]
    del y1data[:],y2data[:],y3data[:]
    linea1.set_data(x1data,y1data)
    linea2.set_data(x1data,y2data)
    linea3.set_data(x1data,y3data)
    return linea1,linea2,linea3,

def animacion(i,linea1,linea2,linea3,d_t,todo_pas):
    x1data = np.array(range(len(d_t[0])))
    y1data = np.array(d_t[0])
    y2data = np.array(d_t[1])
    todo = [int.from_bytes([d_t[2][a],d_t[3][a]],byteorder='big',signed=True) for a in range(len(d_t[0]))]
    suma = sum([a for a in todo])
    todo_pas = todo_pas + suma/(131*muestras)
    y3data = np.array([todo_pas for a in range(len(d_t[0]))])
    linea1.set_data(x1data,y1data)
    linea2.set_data(x1data,y2data)
    linea3.set_data(x1data,y3data)
    return linea1,linea2,linea3,todo_pas,

graf, ax = plt.subplots()
linea1, = ax.plot([],[])
linea2, = ax.plot([],[])
linea3, = ax.plot([],[])

x1data,y1data = [],[]
y2data,y3data = [],[]

funcion = creador.FuncAnimation(graf,animacion,fargs=(linea1,linea2,linea3,datos_t,todo_pas),init_func=inicio,interval=10,repeat=False,blit=False)

plt.show()
t_1.join()

