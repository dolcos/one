from django.shortcuts import render

# Create your views here.
from django.db import connections
from django.db.models import Count
from django.http import JsonResponse
from django.shortcuts import render

from .models import Censo
from django.db import connection
import json
import os

def graph(request):
    return render(request, 'graph/graph.html')



def INFO_Provincias(request):
    """
     Ejecuta un Stored Procedure en la DB para conseguir informacion agrupada por las distintas ubicaciones Geograficas.
    """

    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    file_name = BASE_DIR + "\\\static\\\json\\\GeoUbicacion.json"
    if not os.path.isfile(file_name):

        cursor = connection.cursor()
        result = None
        try:
            cursor.execute('EXEC [dbo].[Get_Info_Provincias]')
            result = cursor.fetchall()
        finally:
            cursor.close()

        #Convierte el result set del query en una lista de diccionarios, por fila.
        result_list = []
        for  row in result:
            p = Censo()
            p.Region = row[0]
            p.Provincia = row[1]
            p.Municipio = row[2]
            p.Distrito = row[3]
            p.Seccion = row[4]
            p.Barrio = row[5]
            p.Cantidad = row[6]
            result_list.append(dict(Region = p.Region.replace("Región ",""),
                                    Provincia = p.Provincia.replace("Provincia ",""),
                                    Municipio = p.Municipio.replace("Municipio ",""),
                                    Distrito =  p.Distrito,
                                    Seccion = p.Seccion.replace("Zona ","").replace("Sección ",""),
                                    Barrio = p.Barrio.replace("Paraje ","").replace("Barrio ",""),
                                    Cantidad = p.Cantidad))

        with open(file_name,'w') as jsonout:
            json.dump(result_list,jsonout)

    #Convierte la lista en un JSON para un API.
    data = None
    with open(file_name) as f:
        data = json.loads(f.read())
    return JsonResponse(data, safe=False)