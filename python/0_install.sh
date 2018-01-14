#!/bin/bash

set -e

sudo apt install -y python-pip virtualenv

virtualenv env
source env/bin/activate

pip install django
pip install djangorestframework


