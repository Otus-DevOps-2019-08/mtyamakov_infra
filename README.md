# mtyamakov_infra
mtyamakov Infra repository

# Домашнее задание №3 - ChatOps 

## В процессе сделал:
- Добавил шаблон для PR, тест сборки;
- Настроил интеграцию чата в Slack и репозитория в Github;
- Настроил интеграцию репозитория в Github и TravisCi;

## Как запустить проект:
- Сделать commit в репозитории.

## Как проверить работоспособность:
- Перейти во вкладку [Build History](https://travis-ci.com/Otus-DevOps-2019-08/mtyamakov_infra/builds?utm_medium=notification&utm_source=slack "Build History") и убедиться, что билд выполнен без ошибок.

!!!!
Сделать содержание более структурированным
Добавить оглавление
!!!!

# Домашнее задание №4 - Bastion Host, VPN Server

## В процессе сделал:
- Создал 2 инстанса на GCP: 
bastion с публичным ip-адресом и приватным ip-адресом,
someinternalhost только с приватным ip-адресом;
- На локальной машине изменил ssh-конфиг таким образом, что можно подключаться к инстансам bastion и someinternalhost командами 'ssh bastion' и 'ssh someinternalhost'. Ниже описываются шаги, которые надо выполнить для такого результата.
В ~/.bash_profile добавить: 
eval `ssh-agent -s`
ssh-add ~/.ssh/otus-gcp

В ~/.ssh/config добавить:
Host bastion
    Hostname 35.210.197.114
    IdentityFile /home/m.tyamakov/.ssh/otus-gcp
    User m.tyamakov

Host someinternalhost
    Hostname 10.132.0.3
    ProxyCommand ssh -W %h:%p bastion
- Установил VPN сервер Pritunl (пока ещё нет)
- Настроил SSL (пока ещё нет)

## Как проверить работоспособность


