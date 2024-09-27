def estaciones_ex(fname):
    '''
    Esta funcion extrae los nombres de las estaciones que tienen arribo de onda P
    en el Sfile, además las distancias al epicentro.
    Tiene como entrada el nombre del Sfile y salida dos listas: ESTACIONES  y 
    DISTANCIA

    ESTACIONES, DISTANCIA = estaciones_ex("10-1100-00L.S202011")

    '''
    import re

# Introduce nombre del archivo  de donde extrae la informacion
    #fname = "10-1100-00L.S202011"

    try:
        fhand = open(fname)
    except:
        print('No se puede abrir el archivo ', fname)
        exit()

    parsing = False
    ESTACIONES = list()
    DISTANCIAS = list()
    # Extrae codigos de estaciones leyendo lineas que estan entre STAT y
    # la linea vacía
    for line in fhand:
        line = line.rstrip() #elimina blanks


        if re.match('^ STAT ',line):
            parsing = True


        if parsing  and not re.match('^ STAT ',line):
            if re.findall('P ',line):
                sta = line.split()
                ESTACIONES.append(sta[0])
                DISTANCIAS.append(int(float(sta[-2])))
    
    return ESTACIONES, DISTANCIAS

#est, dist = estaciones_ex('10-1100-00L.S202011')
