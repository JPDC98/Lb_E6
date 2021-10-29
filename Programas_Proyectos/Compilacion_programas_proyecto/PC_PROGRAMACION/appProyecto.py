import dash
import dash_bootstrap_components as dbc
import plotly.express as px
import pandas as pd
from dash import dcc 
from dash import html 
from dash.dependencies import Input, Output
from dash import dash_table


import serial
import threading
import time


tiempo_pasado=int(round(time.time()*1000))

dt=None
#conversiones
A_R=16384.0
G_R=131.0
RAD_A_DEG=57.295779


header={'Sensor 1':[],'Sensor 2':[],'Ángulo 1':[],'Ángulo 2':[]}
df=pd.DataFrame(header)
app = dash.Dash(__name__,external_stylesheets=[dbc.themes.CYBORG],meta_tags=[{'name':'viewport','content':'width-device-width, initial-scale=1.0'}])
angulo = 90


def conexion():
    try:
        com_serial = serial.Serial(port='COM6',#Poner dirección del dispositivo si es sistema linux; Windows verificar puerto asignado al bluetooth.
                            baudrate=115200, #Velidicad de recepción de datos, HC-06 por defecto esta a 9600, si utilizamos otro baudrate hay que modificarlo.
                            bytesize=serial.EIGHTBITS, #Numero de bits a contar y empaquetar
                            parity=serial.PARITY_NONE, #Desabilitamos bits de paridad por el momento
                            stopbits = serial.STOPBITS_ONE, #Se detiene la recepción de datos cuando se detecta un estado alto. 
                            timeout=None)#Se epera por tiempo indefinido los bytes
        print(com_serial.name) #imprimimos el puerto serial a utilizar, conexión correcta
        while(1):  
                  
            
            datos_bytes = com_serial.read(6) 
            ultrasonico1=datos_bytes[0]
            ultrasonico2=datos_bytes[1]
            AcZ1=int.from_bytes(datos_bytes[2],byteorder='big',signed=False)
            AcZ2=int.from_bytes(datos_bytes[3],byteorder='big',signed=False)
            AgZ1=int.from_bytes(datos_bytes[4],byteorder='big',signed=False)
            AgZ2=int.from_bytes(datos_bytes[5],byteorder='big',signed=False)
            AcZ=AcZ1<<8|AcZ2
            AgZ=AgZ1<<8|AgZ2

            AgZ=AgZ/G_R;
            dt=(int(round(time.time()*1000))-tiempo_pasado)/1000;
            
            tiempo_pasado=int(round(time.time()*1000))
            #angulo=0.98*(angulo+AgZ*dt)+0.02*(AcZ)#filtro complementario
            angulo=(angulo+AgZ*dt)+0.01541#Como esta en el arduino
            df=df.append({'Sensor 1':ultrasonico1,'Sensor 2':ultrasonico2,'Ángulo 1':90,'Ángulo 2':angulo},ignore_index=False)   
    except:
        print("ERROR EN LA CONEXION") # se nos hace saber que hubo un error.

t_1 = threading.Thread(name="hilo1",target=conexion)
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
    dbc.Row([
        dbc.Col([
            html.Div(children=[dash_table.DataTable(id='table1',
            columns=[{"name":i,"id":i}for i in (df.columns)],
            
            style_header={
            'backgroundColor': 'rgb(30, 30, 30)',
            'color': 'white'
            },
            style_data={
                'backgroundColor': 'rgb(50, 50, 50)',
                'color': 'white'
            },
            style_as_list_view=True,
            )],),

        ]),

    ]),
    dcc.Interval(
        id='interval-component',
        interval=500,
        n_intervals=0
    )
],style={'backgroundColor':'black', 'fontSize': 14},className='container')

@app.callback(
    Output('graficasensor1','figure'),
    Output('graficasensor2','figure'),
    Output('table1','data'),
    Input('interval-component','n_intervals'))
def grafica1(n):
    #df=pd.read_csv('sensor.csv')
    df2=pd.DataFrame(df.iloc[-1]).transpose()
    df2=df2.reset_index()
    del df2["index"]
    df4=df.tail(10)
    df4=df4.reset_index()
    del df4["index"]
    data1=df4.to_dict('records')
    fig1=px.scatter_polar(df2,r="Sensor 1",theta="Ángulo 1",template="plotly_dark",direction="counterclockwise",start_angle=0,title="Distancia [cm]")
    fig2=px.scatter_polar(df2,r="Sensor 2",theta="Ángulo 2",template="plotly_dark",direction="counterclockwise",start_angle=0,title="Distancia [cm]")
    return fig1,fig2,data1

if __name__ == '__main__':
    app.run_server(debug=True)

t_1.join()


