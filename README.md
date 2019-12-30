

# mtyamakov_infra
mtyamakov Infra repository

## Список работ
- [Homework 3 - ChatOPS](#homework-3-chatops)
- [Homework 4 - Bastion Host](#homework-4-bastion-host)
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
