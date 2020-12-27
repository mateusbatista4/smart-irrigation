from django.db import models

# Create your models here.
class Pump(models.Model):
    onOff = models.BooleanField(default=False)
    label = models.TextField(max_length=30, null=True, blank=True)

   
    
    
    