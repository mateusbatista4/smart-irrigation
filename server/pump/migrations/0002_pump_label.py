# Generated by Django 3.1.4 on 2020-12-27 19:41

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('pump', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='pump',
            name='label',
            field=models.TextField(blank=True, max_length=30, null=True),
        ),
    ]
