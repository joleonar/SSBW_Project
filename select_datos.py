# Convierte datos desde select a formato texto
import numpy as np
import pandas as pd
from datetime import datetime, timedelta

def extrae_select(fname='select.out',crea_ev=False):
    import re
    fh = open(fname)
    year=[];month=[];day=[];hour=[];minu=[];sec=[];rloc=[]
    lat=[];lon=[];depth=[];agen=[];nsta=[];rms=[]; mag=[]
    
    for line in fh:
        line=line.rstrip()
        if re.match('^ 20.. ',line):
            year.append(line[1:5]);month.append(line[6:8]);day.append(line[8:10])
            hour.append(line[11:13]);minu.append(line[13:15]);sec.append(line[16:20])
            rloc.append(line[21:22]);lat.append(line[23:30]);lon.append(line[30:38])
            depth.append(line[38:43]);agen.append(line[45:48]);nsta.append(line[48:51])
            rms.append(line[51:55]); mag.append(line[56:59])
    
    #######  Crea el archivo eventos_2021.txt q
    if crea_ev==True:
        No = list(np.arange(1,len(year)+1))
        columnas_n=['No','Año','Mes','Día','H','M','S','Lat N','Lon O','Prof','N est','rms','Mag']
        datos= list(zip(No,year,month,day,hour,minu,sec,lat,lon,depth,nsta,rms,mag))   
        df_event=pd.DataFrame(datos,columns=columnas_n)
        #df_event=df_event.applymap(lambda x: str(x).replace('.',','))
        df_event.to_csv("eventos.txt",sep="\t",index=False)
    #######
    
    nombre_col=['year','month','day','hour','minute','sec','rloc','lat','lon','depth','age','nsta','rms','mag']
        
    lista_datos= list(zip(year,month,day,hour,minu,sec,rloc,lat,lon,depth,agen,nsta,rms,mag))   
    
    #Asigna los tipos de datos a cada columna
    tipos={'year':'int16','month':'int8','day':'int8','hour':'int8','minute':'int8','sec':'float16',
           'lat':'float16','lon':'float16', 'depth':'float16','nsta':'int8','rms':'float16','mag':'float16'}
    
    #Crea dataframe con los parametros del sismo
    df=(pd.DataFrame(lista_datos,columns=nombre_col)
        .astype(tipos)
        .assign(sec=lambda x: x.sec.apply(quita_60))
        )

    return(df)

def formato_basedatos(df):
    return df.drop(columns=['rloc','age','nsta','rms'])

def convert2date(row):
    return(datetime(row[0], row[1], row[2], row[3], row[4], row[5],row[6])) 

def quita_60(x):
    if x==60:
        return(59.9)
    else:
        return(x)
    
def modifica_df(datos):
    row = ['year','month','day','hour','minute','sec','microsec']
    
    return (datos
     #.astype({'year':'int16','month':'int8', 'day':'int8', 'hour':'int8','min':'int8',
     #        'sec':'float16','lat':'float16','lon':'float16','depth':'float16','mag':'float16'})
     .assign(microsec = lambda x:(1e6*(x.sec-x.sec.astype(int))).astype(int),
             sec = lambda x: x.sec.astype('int8'),
             T_orig =lambda x: x[row].apply(convert2date,axis=1).astype("datetime64[ms]")
            )

     .rename(columns={'lat':'Latitud (°)','lon':'Longitud (°)','depth':'Profundidad (km)','mag':'Magnitud (Mw)'})
     .drop(columns=['year','month','day','hour','minute','sec','microsec','rloc','nsta','age','rms'])
     .set_index('T_orig')
    )

    
#df = extrae_select('./SismoOriente2024/select.out')
#df2 = formato_basedatos(df)
#df2 = modifica_df(df)
#print(df2.head())