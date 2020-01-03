  

# mtyamakov_infra
mtyamakov Infra repository

## Список работ
- [Homework 3 - ChatOPS](#homework-3-chatops)
- [Homework 4 - Bastion Host](#homework-4-bastion-host)
- [Homework 5 - cloud, test application](#homework-5-gcloud)
- ---

## Homework-3: ChatOPS

#### В процессе сделал:
- Добавил шаблон для PR, тест сборки;
- Настроил интеграцию чата в Slack и репозитория в Github;
- Настроил интеграцию репозитория в Github и TravisCi;

#### Как запустить проект:
- Сделать commit в репозитории.

#### Как проверить работоспособность:
- Перейти во вкладку [Build History](https://travis-ci.com/Otus-DevOps-2019-08/mtyamakov_infra/builds "Build History") и убедиться, что билд выполнен без ошибок.
---
## Homework-4: Bastion Host

#### В процессе сделал:
- Однострочник для подключения к someinternalhost:
 ```
 ssh -i ~/.ssh/otus-gcp -A -t m.tyamakov@35.210.197.114 ssh -A 10.132.0.3
 ```
- Настройки для подключения к хостам с локальной машины командой формата ```ssh hostname```:

1. В ~/.bash_profile добавить: 
```
eval `ssh-agent -s` 
```
```
ssh-add ~/.ssh/otus-gcp
``` 

2. В ~/.ssh/config добавить:
```
Host bastion
Hostname 35.210.197.114
IdentityFile /home/m.tyamakov/.ssh/otus-gcp
User m.tyamakov
    
Host someinternalhost
Hostname 10.132.0.3
ProxyCommand ssh -W %h:%p bastion
```
3. Для подключения использовать команды:
```
ssh bastion - подключение к bastion (35.210.197.114)
ssh someinternalhost - подключение к someinternalhost (10.132.0.3)
```
- Установил VPN сервер Pritunl;
- Подключил SSL-сертификат с помощью sslip.io и Let's Encrypt;

#### Как проверить работоспособность:
- Перейти во вкладку [Build History](https://travis-ci.com/Otus-DevOps-2019-08/mtyamakov_infra/builds "Build History") и убедиться, что билд выполнен без ошибок.
- Проверить валидность SSL-сертификата можно командой:
```
curl -v https://35.210.197.114.sslip.io >/dev/null 2>&1 && echo "SSL check - ok" || echo "SSL check - not ok"
SSL check - ok
```
#### Travis CI variables:
bastion_IP = 35.210.197.114  
someinternalhost_IP = 10.132.0.3

---
## Homework-5: gcloud 

#### В процессе сделал:
- Bash-cкрипт **install_ruby.sh** - для установки Ruby:
```
#!/bin/bash
sudo apt-get update
sudo apt-get install -y ruby-full ruby-bundler build-essential
```
- Bash-cкрипт **install_mongodb.sh** - для установки и запуска MongoDB:
```
#!/bin/bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl enable mongod
sudo systemctl start mongod
```
- Bash-cкрипт **deploy.sh** - для скачивания приложения и его зависимостей:
```
#!/bin/bash
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
```
- Bash-cкрипт **startup_script.sh** - для создания инстанса с запущенным приложением:
```
#!/bin/bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
sudo apt update
sudo apt install -y mongodb-org ruby-full ruby-bundler build-essential
sudo systemctl enable mongod
sudo systemctl start mongod
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
```
- Сделал все bash-скрипты исполняемыми - ```chmod +x *.sh```
- Создал bucket для размещения startup скрипта, скопировал **startup_script.sh** в bucket:
```
 gsutil mb gs://hw-otus-tyamakov
 gsutil cp startup_script.sh gs://hw-otus-tyamakov
  ```
#### Создание инстанса с автоматической настройкой и запуском приложения:
- С использованием **startup-script**:
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server-test \
  --restart-on-failure \
  --metadata-from-file startup-script=startup_script.sh
```
- С использованием **startup-script-url** (*для хранения скрипта предварительно был создан bucket*):
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server-test \
  --restart-on-failure \
  --metadata startup-script-url=gs://hw-otus-tyamakov/startup_script.sh
```
#### Создание правила firewall из консоли с помощью gcloud:
```
gcloud compute firewall-rules create default-puma-server \
 --source-ranges="0.0.0.0/0" \
 --allow=tcp:9292 --direction=INGRESS \
 --target-tags=puma-server \
 --description "Allow incoming traffic to TCP port 9292"
```
#### Как проверить работоспособность:
- Перейти по адресу [http://35.205.37.24:9292](http://35.205.37.24:9292/) и убедиться, что страница открывается;
- Перейти во вкладку [Build History](https://travis-ci.com/Otus-DevOps-2019-08/mtyamakov_infra/builds "Build History") и убедиться, что билд выполнен без ошибок.
#### Travis CI variables:
testapp_IP = 35.205.37.24
testapp_port = 9292

