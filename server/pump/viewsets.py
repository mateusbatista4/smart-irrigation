
from .models import Pump
from rest_framework import  viewsets
from .serializers import PumpSerializer

class PumpViewSet(viewsets.ModelViewSet):
    queryset = Pump.objects.all()
    serializer_class = PumpSerializer
    http_method_names = ['get', 'put']
    