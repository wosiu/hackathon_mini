# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models


class User(models.Model):
    pass


class Group(models.Model):
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    hash = models.CharField(max_length=10, unique=True)
    description = models.CharField(max_length=100, default="")
    data = models.CharField(max_length=1000, default="")
    last_owner_activity = models.DateTimeField()
    class Meta:
        indexes = [
            models.Index(fields=["hash"]),
        ]


class IndoorRoomUser(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)  # unique
    indoor_room_id = models.CharField(max_length=100)
    last_activity = models.DateTimeField()


class GroupUser(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    group = models.ForeignKey(Group, on_delete=models.CASCADE)


class Vote(models.Model):
    group = models.ForeignKey(Group, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    time = models.DateTimeField()
    ok = models.NullBooleanField(default=None, blank=True, null=True)
    class Meta:
        indexes = [
            models.Index(fields=["group", "user"]),
            models.Index(fields=["group"]),
        ]
        unique_together = (("group", "user"),)


class Question(models.Model):
    group = models.ForeignKey(Group, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    time = models.DateTimeField()
    text = models.TextField()

