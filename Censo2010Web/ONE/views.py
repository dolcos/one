from django.shortcuts import render

# Create your views here.
from django.db import connections
from django.db.models import Count
from django.http import JsonResponse
from django.shortcuts import render
from .models import Censo
from django.db import connection
import os
import ujson
import pandas as pd
from .CrearJSON import *


BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
file_dir = BASE_DIR + "\\static\\json\\"
GEOJSON_Directory = file_dir + "GeoJson\\"

def graph(request):
    return render(request, 'graph/graph.html')



def INFO_Ubicacion(request):
    """
    Funcion para buscar entre los directorios los archivos que cumplen con los filtros pasados desde el Front End.
    :param request: Contiene la ubicacion y filtro.
    :return: Un JSON con los datos del censo pertenecientes a ese filtro y los datos geograficos.
    """
    data = None
    ubicacion = request.GET.get('ubicacion')
    filtro = request.GET.get('filtro')

    file = ""
    geofile = ""

    if ubicacion != 'Region':
        file = file_dir + ubicacion + "\\Get_Info_" + ubicacion + filtro + ".json"
        geofile = GEOJSON_Directory + ubicacion + "\\GeoJson" + filtro + ".geojson"

    else:
        file = file_dir + "Get_Info_Region.json"
        geofile = GEOJSON_Directory + "regioncenso2010.geojson"

    censo_data = None
    with open(file) as f:
        censo_data = ujson.loads(f.read())

    geo_data = None
    with open(geofile) as f:
        geo_data = ujson.loads(f.read())


    data = dict(Censo=censo_data,
                Geo=geo_data)
    return JsonResponse(data, safe=False)






def INFO_Provincias(request):

    if not os.path.isfile(file_dir + "Get_Info_Region.json"):
        Crear_Archivos_JSON()

    if not os.path.isfile(GEOJSON_Directory + "regioncenso2010.geojson"):
        Crear_GeoJSON()

    #Convierte la lista en un JSON para un API.
    censo_data = None
    with open(file_dir + "Get_Info_Region.json") as f:
        censo_data = ujson.loads(f.read())

    geo_data = None
    with open(GEOJSON_Directory + "regioncenso2010.geojson") as f:
        geo_data = ujson.loads(f.read())


    data = dict( Censo = censo_data,
                 Geo = geo_data)


    return JsonResponse(data, safe=False)