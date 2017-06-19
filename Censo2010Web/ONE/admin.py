
# Register your models here.
from django.contrib import admin

from .models import Censo
@admin.register(Censo)
class PlayAdmin(admin.ModelAdmin):
    list_display = ('Region','Pregunta','Respuesta','Cantidad')