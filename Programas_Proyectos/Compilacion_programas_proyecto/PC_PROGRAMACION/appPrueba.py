import dash
import dash_bootstrap_components as dbc
import plotly.express as px
from dash import dcc 
from dash import html 
from math import pi
from dash.dependencies import Input, Output
import pandas as pd
import random as rnd
import threading
import time
from dash import dash_table





header={'Sensor 1':[0],'Sensor 2':[0],'Ángulo 1':[0],'Ángulo 2':[0]}
df=pd.DataFrame(header)
#print(df)

app = dash.Dash(__name__,external_stylesheets=[dbc.themes.CYBORG],meta_tags=[{'name':'viewport','content':'width-device-width, initial-scale=1.0'}])

def datosR():
    while(1):
        global df
        ultrasonico1=rnd.randint(1,100)
        ultrasonico2=rnd.randint(1,500)
        angulo=pi*rnd.randint(1,3)    
        df = df.append({'Sensor 1':ultrasonico1,'Sensor 2':ultrasonico2,'Ángulo 1':90,'Ángulo 2':angulo},ignore_index=True)
        time.sleep(0.001)

t_1 = threading.Thread(name="hilo1",target=datosR)
t_1.start()

app.layout=html.Div(children=[
    dbc.Row([
        dbc.Col([html.H1(children='Sensores de distancia',className='text-center text-primary,mb-4')])
        ]),
    dbc.Row([
        dbc.Col([
            html.Div(children=[
            html.H4(children="Sensor 1",className='text-center text-primary,mb-4'),
            dcc.Graph(id='graficasensor1')
            ])
        ]),

        dbc.Col([
            html.Div(children=[
            html.H4(children="Sensor 2",className='text-center text-primary,mb-4'),
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

datos=None
@app.callback(
    Output('graficasensor1','figure'),
    Output('graficasensor2','figure'),
    Output('table1','data'),
    Input('interval-component','n_intervals'))
def grafica1(n):  
    
    df3=pd.DataFrame(df.iloc[-1]).transpose()
    df3=df3.reset_index()
    del df3["index"]
    df4=df.tail(10)
    df4=df4.reset_index()
    del df4["index"]
    #print(df4)
    data1=df4.to_dict('records')
    #tabla=dash_table.DataTable(columns=[{"name":i,"id":i}for i in df4.columns],data=df4.to_dict('records'))
    fig1=px.scatter_polar(df3,r="Sensor 1",theta="Ángulo 1",template="plotly_dark",direction="counterclockwise",start_angle=0,title="Distancia [cm]")
    fig2=px.scatter_polar(df3,r="Sensor 2",theta="Ángulo 2",template="plotly_dark",direction="counterclockwise",start_angle=0,title="Distancia [cm]")
    return fig1,fig2,data1


if __name__ == '__main__':
    

    app.run_server(debug=True)



