import dash
import dash_bootstrap_components as dbc
import plotly.express as px
from dash import dcc 
from dash import html 
from dash.dependencies import Input, Output
import pandas as pd
import csv
import serial
import threading

datos_t = []
header=['s1','s2','agl1','agl2']
app = dash.Dash(__name__,external_stylesheets=[dbc.themes.BOOTSTRAP],meta_tags=[{'name':'viewport','content':'width-device-width, initial-scale=1.0'}])
angulo = 0

"""def datosRandom(dat):
    header=['s1','s2','agl1','agl2']
    with open("sensor.csv",'w',encoding='UTF8',newline='') as sensor:
        writer=csv.writer(sensor)
        writer.writerow(header)
        for a in range(5):
            b=[int(dat[0]),int(dat[1]),int(dat[2]),int(dat[2])]
        writer.writerow(b)
    return pd.read_csv('sensor.csv')
"""
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
            file = open("sensor.csv",'w',encoding='UTF8',newline='')
            entrada = csv.writer(file)
            entrada.writerow(header)
            datos_bytes = com_serial.read(6) 
            out_data = [datos_bytes[0],datos_bytes[1],90,int.from_bytes([datos_bytes [4],datos_bytes[5]],byteorder='big',signed=True)/131]
            entrada.writerow(out_data)
            file.close()
    except:
        print("ERROR EN LA CONEXION") # se nos hace saber que hubo un error.

t_1 = threading.Thread(name="hilo1",target=conexion, args=(datos_t,))
t_1.start()



app.layout=html.Div(children=[
    dbc.Row([
        dbc.Col([html.H1(children='Sensores de distancia',className='text-center text-primary,mb-4')])
        ]),
    dbc.Row([
        dbc.Col([
            html.Div(children=[
            html.H3(children="Sensor 1",className='text-center text-primary,mb-4'),
            dcc.Graph(id='graficasensor1')
            ])
        ]),

        dbc.Col([
            html.Div(children=[
            html.H3(children="Sensor 2",className='text-center text-primary,mb-4'),
            dcc.Graph(id='graficasensor2')
            ])
        ]),

    ]),
    dcc.Interval(
        id='interval-component',
        interval=500,
        n_intervals=0
    )
])

@app.callback(
    Output('graficasensor1','figure'),
    Output('graficasensor2','figure'),
    Input('interval-component','n_intervals'))
def grafica1(n):
    df=pd.read_csv('sensor.csv')
    fig1=px.scatter_polar(df,r="s1",theta="agl1",template="plotly_dark",direction="counterclockwise",start_angle=0,title="Distancia [cm]")
    fig2=px.scatter_polar(df,r="s2",theta="agl2",template="plotly_dark",direction="counterclockwise",start_angle=0,title="Distancia [cm]")
    return fig1,fig2

if __name__ == '__main__':
    app.run_server(debug=True)

t_1.join()