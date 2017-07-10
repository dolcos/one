from .models import Censo
import os
import unicodedata
import pandas as pd
import ujson
from django.db import connection

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
file_dir = BASE_DIR + "\\static\\json\\"
GEOJSON_Directory = file_dir + "GeoJson\\"


def borrar_acentos(s):
    return ''.join(c for c in unicodedata.normalize('NFD', s)
                   if unicodedata.category(c) != 'Mn')


def Crear_JSON(ubicacion, filtro):
    # Convierte el result set del query en una lista de diccionarios, por fila.
    cursor = connection.cursor()
    if ubicacion == 'Region':
        cursor.execute("EXEC Get_Info_Region")
    else:
        cursor.execute("EXEC Get_Info_Ubicacion @Ubicacion = '" + ubicacion + "', @Filtro = '" + filtro + "' ")
    for row in cursor:
        p = Censo()
        json_dict = {}
        count = 2
        if ubicacion == 'Region':
            p.Region = row[0].replace("Región ", "")
            json_dict["Region"] = p.Region
            count = 1
        elif ubicacion == 'Provincia':
            p.Region = row[0].replace("Región ", "")
            p.Provincia = row[1].replace("Provincia ", "")
            json_dict["Region"] = p.Region
            json_dict["Provincia"] = p.Provincia

        elif ubicacion == 'Municipio':
            p.Provincia = row[0].replace("Provincia ", "")
            p.Municipio = row[1].replace("Municipio ", "")
            json_dict["Provincia"] = p.Provincia
            json_dict["Municipio"] = p.Municipio

        elif ubicacion == 'Distrito':
            p.Municipio = row[0].replace("Municipio ", "")
            p.Distrito = row[1]
            json_dict["Municipio"] = p.Municipio
            json_dict["Distrito"] = p.Distrito

        elif ubicacion == 'Seccion':
            p.Distrito = row[0]
            p.Seccion = row[1].replace("Zona ", "").replace("Sección ", "")
            json_dict["Distrito"] = p.Distrito
            json_dict["Seccion"] = p.Seccion

        else:
            p.Seccion = row[0].replace("Zona ", "").replace("Sección ", "")
            p.Barrio = row[1].replace("Paraje ", "").replace("Barrio ", "")
            json_dict["Seccion"] = p.Seccion
            json_dict["Barrio"] = p.Barrio

        p.Entidad = row[count]
        p.Grupo = row[count + 1]
        p.Pregunta = row[count + 2]
        p.Respuesta = row[count + 3]
        p.Cantidad = row[count + 4]
        json_dict["Entidad"] = p.Entidad
        json_dict["Grupo"] = p.Grupo
        json_dict["Pregunta"] = p.Pregunta
        json_dict["Respuesta"] = p.Respuesta
        json_dict["Cantidad"] = p.Cantidad

        yield json_dict
    cursor.close()


def Get_INFO_Geografica():
    cursor = connection.cursor()
    cursor.execute("EXEC Get_Info_Geografica")
    result = []
    for row in cursor:
        p = Censo()
        json_dict = {}
        p.Codigo = row[0]
        p.Region = row[1].replace("Región ", "")
        p.Provincia = row[2].replace("Provincia ", "")
        p.Municipio = row[3].replace("Municipio ", "")
        p.Distrito = row[4]
        p.Seccion = row[5].replace("Zona ", "").replace("Sección ", "")
        p.Barrio = row[6].replace("Paraje ", "").replace("Barrio ", "")
        json_dict["Codigo"] = p.Codigo
        json_dict["Region"] = p.Region
        json_dict["Provincia"] = p.Provincia
        json_dict["Municipio"] = p.Municipio
        json_dict["Distrito"] = p.Distrito
        json_dict["Seccion"] = p.Seccion
        json_dict["Barrio"] = p.Barrio
        json_dict["EnlaceProvincia"] = p.Codigo[0:4]
        json_dict["EnlaceMunicipio"] = p.Codigo[0:6]
        json_dict["EnlaceDistrito"] = p.Codigo[0:8]
        json_dict["EnlaceSeccion"] = p.Codigo[0:8] + p.Codigo[9:11]
        result.append(json_dict)
    cursor.close()
    return result


def Clean_Nombre_Ubicacion(sububicaciones):
    sub_ubicaciones_originales = [borrar_acentos(sub_ubicacion.upper()) for sub_ubicacion in sububicaciones]
    sub_ubicaciones_originales = [s.replace("(D.M.)", "(D. M.).") for s in sub_ubicaciones_originales]
    sub_ubicaciones_originales = [s.replace("(", "").replace(")", "").
                                      replace("URBANA ", "") + " (ZONA URBANA)"
                                  if "URBANA" in s else s for s in
                                  sub_ubicaciones_originales]

    return sub_ubicaciones_originales


def Crear_Coordenadas(ubicacion, coordenadas):
    geo_json = {}
    geo_json["type"] = "Feature"
    geo_json["properties"] = dict(name = ubicacion)
    geo_json["geometry"] = dict(type = "MultiPolygon",
                                coordinates = coordenadas["geometry"]["coordinates"])
    return  geo_json


def Crear_GeoJSON():
    """
    Algunas ubicaciones cambiadas manualmente:
    Distrito Tavera: (D.M.) a (D. M.). Las Auyamas a La Auyama; Sabana  Palenque a Sabana Palenque
    Las Palomas  Arriba a Las Palomas Arriba
    Regiones no tienen "Region " en el nombre
    :return:
    """

    # Archivos y dimensiones de los GeoJSON
    files = ["reg", "prov", "mun", "dm", "sec", "bp"]
    geojson_files = [GEOJSON_Directory + file + "censo2010.geojson" for file in files]
    dims = ["Region", "Provincia", "Municipio", "Distrito", "Seccion", "Barrio"]

    # En este diccionario se almacenan los codigos de enlace de las ubicaciones

    print("Consiguiendo Nombres Geograficos Estandarizados")
    Geo_Dataframe = pd.DataFrame(Get_INFO_Geografica())

    for i in range(len(dims)):
        print("Creando GeoJSON de " + dims[i])
        ubicaciones = []

        if dims[i] != 'Region':
            ubicaciones = Geo_Dataframe[dims[i - 1]].unique()

        else:
            ubicaciones = ['Republica Dominicana']

        geojson_file = geojson_files[i]
        data_ubicacion = None

        with open(geojson_file, encoding='utf-8') as geojson_data:
            json_string = geojson_data.read()
            try:
                data_ubicacion = ujson.loads(json_string)
            except ValueError:
                if dims[i] == 'Region':
                    print("JSON sucio limpiando")
                    import static.json.Clean_GeoJSON as clean
                    clean.Limpiar_GeoJSON()
                    geojson_data.seek(0)
                    json_string = geojson_data.read()
                    data_ubicacion = ujson.loads(json_string[1:])
                else:
                    data_ubicacion = ujson.loads(json_string[1:])

        directory = ""
        if dims[i] != 'Region':
            directory = GEOJSON_Directory + dims[i]
            if not os.path.exists(directory):
                os.makedirs(directory)

        else:
            directory = GEOJSON_Directory

        data_ubicacion = data_ubicacion["features"]


        for ubicacion in ubicaciones:
            if dims[i] == 'Region':
                print("Creando geoJSON de regiones")
                file_ubicacion = directory + "regioncenso2010.geojson"
                sub_ubicaciones_unicas = Geo_Dataframe['Region'].unique()

            else:
                print("Creando geoJSON de sububicaciones de " + dims[i] + " " + ubicacion)
                file_ubicacion = directory + "\\GeoJson" + ubicacion + ".geojson"
                sub_ubicaciones = Geo_Dataframe.loc[Geo_Dataframe[dims[i - 1]] == ubicacion]

            if not os.path.isfile(file_ubicacion):
                geojson = {}
                geojson["type"] = "FeatureCollection"
                geojson_ubicacion = []
                if dims[i] == 'Barrio':
                        codigos = sub_ubicaciones.Codigo.unique()
                        for codigo in codigos:
                            sub_ubicaciones_unicas = \
                            sub_ubicaciones.loc[sub_ubicaciones.Codigo == codigo]['Barrio'].unique()[0]
                            propiedades_sub_ubicaciones_originales = [data for data in data_ubicacion
                                                                      if data["properties"]["CODIGO"] == codigo]

                            print("Consiguiendo propiedades de " + sub_ubicaciones_unicas)
                            geojson_ubicacion.append(Crear_Coordenadas(sub_ubicaciones_unicas,
                                                                       propiedades_sub_ubicaciones_originales[0]))


                else:
                        propiedades_sub_ubicaciones_originales = []
                        if dims[i] != 'Region':
                            sub_ubicaciones_unicas = sub_ubicaciones[dims[i]].unique()
                            enlaces = sub_ubicaciones['Enlace'+ dims[i]].unique()
                            for enlace in enlaces:
                                for data in data_ubicacion:
                                     if data["properties"]["ENLACE"] == enlace:
                                         propiedades_sub_ubicaciones_originales.append(data)


                        else:
                            for sub_ubicacion in sub_ubicaciones_unicas:
                                for data in data_ubicacion:
                                    print(data["properties"]["TOPONIMIA"])
                                    if data["properties"]["TOPONIMIA"] == sub_ubicacion.upper():
                                        propiedades_sub_ubicaciones_originales.append(data)

                        for j in range(len(sub_ubicaciones_unicas)):
                            print("Consiguiendo propiedades de " + sub_ubicaciones_unicas[j])
                            geojson_ubicacion.append(Crear_Coordenadas(sub_ubicaciones_unicas[j],
                                                                       propiedades_sub_ubicaciones_originales[j]))

                geojson["features"] = geojson_ubicacion
                with open(file_ubicacion, 'w', encoding='utf-8') as geojson_out:
                    ujson.dump(geojson, geojson_out)


def Crear_Archivos_JSON():
    dims = ["Region", "Provincia", "Municipio", "Distrito", "Seccion", "Barrio"]
    filtro_dict = {}
    i = 0
    for dim in dims:
        if dim == "Region":
            print("Creando JSON de Regiones")
            file = file_dir + "Get_Info_Region.json"
            if not os.path.isfile(file):
                with open(file, 'w') as jsonout:
                    json_list = []
                    filtro_dict[dims[i + 1]] = []
                    for item in Crear_JSON(dim, None):
                        if item[dims[i]] not in filtro_dict[dims[i + 1]]:
                            filtro_dict[dims[i + 1]].append(item[dims[i]])
                        json_list.append(item)
                    ujson.dump(json_list, jsonout)
        else:
            directory = file_dir + dim
            if not os.path.exists(directory):
                os.makedirs(directory)
            files = [directory + "\\Get_Info_" + dim + filtro + ".json" for filtro in filtro_dict[dims[i]]]

            if dim != 'Barrio':
                filtro_dict[dims[i + 1]] = []

            for j in range(len(files)):
                if not os.path.isfile(files[j]):
                    print("Creando JSON de " + dims[i] + " " + files[j].replace(directory + "\\Get_Info_" + dim, ""))
                    with open(files[j], 'w') as jsonout:
                        json_list = []
                        filtros = filtro_dict[dims[i]]
                        for item in Crear_JSON(dim, filtros[j]):
                            if dim != 'Barrio':
                                if item[dims[i]] not in filtro_dict[dims[i + 1]]:
                                    filtro_dict[dims[i + 1]].append(item[dims[i]])
                            json_list.append(item)
                        ujson.dump(json_list, jsonout)
        i += 1
