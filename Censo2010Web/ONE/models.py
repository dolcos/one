from django.db import models

# Create your models here.
class Censo(models.Model):
    Region = models.CharField(max_length=100)
    Provincia = models.CharField(max_length = 100)
    Municipio = models.CharField(max_length = 100)
    Distrito = models.CharField(max_length = 100)
    Zona = models.CharField(max_length = 100)
    Seccion = models.CharField(max_length = 100)
    Barrio = models.CharField(max_length = 100)
    Entidad = models.CharField(max_length =100)
    Grupo = models.CharField(max_length = 100)
    Pregunta = models.CharField(max_length = 255)
    Respuesta = models.CharField(max_length = 255)
    Cantidad = models.IntegerField()

    def as_json(self):
        return dict(
            Region = self.Region, Provincia = self.Provincia, Municipio = self.Municipio, Distrito = self.Distrito,
            Zona = self.Zona, Seccion = self.Seccion, Barrio = self.Barrio, Entidad = self.Entidad, Grupo = self.Grupo,
            Pregunta = self.Pregunta, Cantidad = self.Cantidad
        )


