# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.http import HttpResponseRedirect, HttpResponseBadRequest, JsonResponse, HttpResponse
from django.shortcuts import render
from django.db.models import Count, Model


from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import *
from datetime import datetime, timedelta

from collections import defaultdict
import string, random

#import hashlib

import json


# TODO get rid of replace(tzinfo=None)


USER_ID = "user-id"
SESSION_TOKEN = "session-token"
NAME = "name"
GROUP_ID = "group-id"
GROUP_NAME = "group-name"
OWNER_ID = "owner-id"
GROUP_HASH = "group-hash"
CURRENT_VIEWERS_NUM = "current-viewers-num"
VOTE = "vote"
TIME = "time"
IDLE = "idle"
BAD = "bad"
OK = "ok"
VOTES = "votes"
# todo should be fixed, decide whether we name it "question" or "comment"
QUESTIONS = "questions"
QUESTION_ID = "question-id"
TEXT = "text"


def validAndGetUID(session_token):
    # todo do it in future
    uid = session_token
    if isinstance(uid, int):
        return uid
    else:
        return int(uid)


def validAndGetUser(session_token):
    uid = validAndGetUID(session_token)
    u = User.objects.get(id=uid)
    return u


def validAndGetGroup(group_id):
    try:
        return Group.objects.get(id=group_id)
    except Group.DoesNotExist:
        return None


def deserialize(request):
    # returns dict
    return json.loads(request.body)


@api_view(["GET", "POST"])
def ping(request):
    return Response("OK")


@api_view(["GET", "POST"])
def echo(request):
    return Response(deserialize(request))


@api_view(["GET", "POST"])
def user_create(request):
    new_user = User()
    new_user.save()
    return Response({USER_ID: new_user.id})


def getLastVotes(range_sec=900):
    tres = datetime.now() - timedelta(seconds=range_sec)
    return Vote.objects.filter(time__gte=tres)


def getLastVotesForGroup(group_id, range_sec=900):
    return getLastVotes(range_sec=range_sec).filter(group_id=group_id)


def markIdleIfNoVotes(gid, uid, range_sec=900):
    try:
       v = Vote.objects.filter(group_id=gid, user_id=uid).get()
       now = datetime.now().replace(tzinfo=None)
       if (now - v.time.replace(tzinfo=None)).total_seconds() > range_sec:
           v.time = now
           v.ok = None
           v.save()
    except Vote.DoesNotExist:
        v = Vote(group_id=gid, user_id=uid, ok=None, time=datetime.now())
        v.save()


@api_view(["GET", "POST"])
def group_list(request):
    d = deserialize(request)
    uid = validAndGetUID(d[SESSION_TOKEN])
    # get groups user owns
    groups = Group.objects.filter(owner_id=uid)

    # todo that could be done nicer probably, cannot google that at the moment tho:
    groups2 = GroupUser.objects.filter(user_id=uid).values_list("group", flat=True).distinct()
    groups2 = Group.objects.filter(id__in=groups2)
    groups |= groups2
    groups = groups.distinct()  # in case of a bug when owner is as a participant

    # join votes count for each group
    votesQuery = getLastVotes().values("group").annotate(total=Count("group")).order_by('total')
    counters = defaultdict(int)

    for obj in list(votesQuery):
        counters[obj["group"]] = obj["total"]
    # todo could be done nicer by left join, don't have time for that now

    # serialize
    result = []
    for g in groups:
        result.append({
            GROUP_ID: g.id,
            GROUP_HASH: g.hash,
            GROUP_NAME: g.name,
            OWNER_ID: g.owner.id,
            CURRENT_VIEWERS_NUM: counters[g.id]
        })

    return Response(result)


# assuming group exist
def collect_group_votes(gid):
    #g = validAndGetGroup(gid)
    votes = list(getLastVotesForGroup(gid))
    stats = {
        IDLE: 0,
        OK: 0,
        BAD: []
    }
    now = datetime.now().replace(tzinfo=None)
    # bad[seconds back] = number of votes
    #bad = defaultdict(int)

    for v in votes:
        if v.ok is None:
            stats[IDLE] += 1
        elif v.ok:
            stats[OK] += 1
        else:
            diff_sec = (now - v.time.replace(tzinfo=None)).total_seconds()
            #bad[int(diff_sec / 60) * 60] += 1
            stats[BAD].append(int(diff_sec / 60) * 60)
    #stats[BAD] = bad.items()
    return stats


def collect_group_questions(gid, range_sec=None):
    questions = Question.objects.filter(group_id=gid).order_by('-time')
    now = datetime.now().replace(tzinfo=None)
    if range_sec != -1 and range_sec is not None:
        tres = now - timedelta(seconds=range_sec)
        questions = questions.filter(time__gte=tres)

    result = []
    for q in questions:
        time = int((now - q.time.replace(tzinfo=None)).total_seconds())
        result.append(
            {
                QUESTION_ID: q.id,
                TEXT: q.text,
                TIME: time
            }
        )
    return result


@api_view(["GET", "POST"])
def group_create(request):
    d = deserialize(request)
    u = validAndGetUser(d[SESSION_TOKEN])
    name = d[NAME]

    # ensure hash has not been used so far
    # todo optimize generating hashes
    while True:
        group_hash = ''.join(random.sample(string.ascii_uppercase, 6))
        already_used = Group.objects.filter(hash=group_hash).exists()
        if not already_used:
            break

    new_group = Group(owner=u, name=name, hash=group_hash)
    new_group.save()
    return Response({GROUP_ID: new_group.id, GROUP_HASH: group_hash})


@api_view(["GET", "POST"])
def group_enter(request):
    # shhhh, I know.. it's damn hackathon maaan..
    return group_refresh(request)


# assuming group exists
def groupViewResponse(g):
    if g is None:
        return Response({
            OWNER_ID: -1,
            GROUP_ID: -1,
            GROUP_HASH: "",
            NAME: "Grupa została usunięta przez właściciela",
            VOTES: [],
            QUESTIONS: []
        })

    stats = collect_group_votes(g.id)
    questions = collect_group_questions(g.id)

    return Response({
        OWNER_ID: g.owner.id,
        GROUP_ID: g.id,
        GROUP_HASH: g.hash,
        NAME: g.name,
        VOTES: stats,
        QUESTIONS: questions
    })


@api_view(["GET", "POST"])
def group_refresh(request):
    d = deserialize(request)
    uid = validAndGetUID(d[SESSION_TOKEN])
    # todo valid if user has rights to a group
    gid = d[GROUP_ID]
    g = validAndGetGroup(gid)
    if g is None:
        return groupViewResponse(g)
    if g.owner.id != uid:
        markIdleIfNoVotes(gid, uid)
    return groupViewResponse(g)

#deprecated
@api_view(["GET", "POST"])
def group_join_old(request):
    d = deserialize(request)
    uid = validAndGetUID(d[SESSION_TOKEN])
    gid = d[GROUP_ID]
    g = validAndGetGroup(gid)

    if g is None:
        return groupViewResponse(g)

    if g.owner.id != uid:
        # only if not the owner
        # do not add one more if already exist
        GroupUser.objects.get_or_create(user_id=uid, group_id=gid)
        # voting is only for participants
        markIdleIfNoVotes(gid, uid)

    return groupViewResponse(g)


@api_view(["GET", "POST"])
def group_join(request):
    d = deserialize(request)
    uid = validAndGetUID(d[SESSION_TOKEN])
    ghash = d[GROUP_HASH].upper().strip()
    print(ghash)

    try:
        g = Group.objects.filter(hash=ghash).get()
        if g.owner.id != uid:
            # only if not the owner
            # do not add one more if already exist
            GroupUser.objects.get_or_create(user_id=uid, group=g)
            markIdleIfNoVotes(g.id, uid)
        return groupViewResponse(g)
    except Group.DoesNotExist:
        return groupViewResponse(None)


@api_view(["GET", "POST"])
def group_vote(request):
    d = deserialize(request)
    uid = validAndGetUID(d[SESSION_TOKEN])

    print("d[GROUP_ID]" + str(d[GROUP_ID]))

    g = validAndGetGroup(d[GROUP_ID])

    if g is None:
        # todo handle better? the case when group deleted
        return Response()

    vote = bool(d[VOTE])
    range_sec = d[TIME]
    time = datetime.now() - timedelta(seconds=range_sec)
    try:
        v = Vote.objects.filter(group=g, user_id=uid).get()
        v.time = time
        v.ok = vote
    except Vote.DoesNotExist:
        #g = validAndGetGroup(gid)
        #u = validAndGetUser(uid)
        v = Vote(time=time, group=g, user_id=uid, ok=vote)
    v.save()
    return Response()


@api_view(["GET", "POST"])
def group_comment_add(request):
    d = deserialize(request)
    g = validAndGetGroup(d[GROUP_ID])
    comment = d[TEXT].strip()
    if g is None or not comment:
        return groupViewResponse(g)

    uid = validAndGetUID(d[SESSION_TOKEN])
    q = Question(group=g, user_id=uid, time=datetime.now(), text=comment)
    q.save()

    return groupViewResponse(g)


@api_view(["GET", "POST"])
def group_comment_delete(request):
    d = deserialize(request)
    g = validAndGetGroup(d[GROUP_ID])
    uid = validAndGetUID(d[SESSION_TOKEN])

    if g is None:
        return groupViewResponse(g)

    qid = d[QUESTION_ID]

    try:
        q = Question.objects.filter(group=g, id=qid).get()
        if g.owner.id == uid or q.user.id == uid:
            q.delete()
    except Question.DoesNotExist:
        return groupViewResponse(g)

    return groupViewResponse(g)


@api_view(["GET", "POST"])
def group_delete(request):
    d = deserialize(request)
    uid = validAndGetUID(d[SESSION_TOKEN])
    g = validAndGetGroup(d[GROUP_ID])
    if g.owner.id == uid and (g is not None):
        # todo use django internal cascade delete mechanism (maybe default one, I don't have time to check)
        GroupUser.objects.filter(group=g).delete()
        Vote.objects.filter(group=g).delete()
        Question.objects.filter(group=g).delete()
        g.delete()

    # todo optimize
    return group_list(request)
