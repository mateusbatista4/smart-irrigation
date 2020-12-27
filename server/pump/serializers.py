from rest_framework import serializers
from .models import Pump


class PumpSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pump
        fields = ['id', 'onOff', 'label']