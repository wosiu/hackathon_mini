# -*- coding: utf-8 -*-
from django.conf.urls import url
from .views import *

urlpatterns = [
    url(r'^echo$', echo, name='echo'),
    url(r'^ping$', ping, name='ping'),
    url(r'^user/create$', user_create, name='user_create'),
    url(r'^group/list$', group_list),
    url(r'^group/create$', group_create),
    url(r'^group/enter$', group_enter),
    url(r'^group/refresh$', group_refresh),
    url(r'^group/join$', group_join),
    url(r'^group/vote$', group_vote),
    url(r'^group/comment/add$', group_comment_add),
    url(r'^group/comment/delete$', group_comment_delete),
    url(r'^group/delete$', group_delete),
]
