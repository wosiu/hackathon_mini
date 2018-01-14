# if want to run at startup:
# crontab -e
# and put:
# @reboot /home/amy/repos/regdocOCR/django-upload/run.sh 192.168.0.3 >> /home/amy/repos/regdocOCR/django-upload/run.log &

pushd `dirname $0` > /dev/null
HOME=`pwd -P`
popd > /dev/null


if [ -z $1 ]
then
        host=localhost
else
        host=$1
fi

source $HOME/env/bin/activate

pushd $HOME/poll
python manage.py migrate || { echo "Problem with apllying migrations."; exit 1; }
python manage.py runserver ${host}:8081
popd

