# KKisilevsky_infra repository

[![Build Status](https://travis-ci.com/Otus-DevOps-2020-05/KKisilevsky_infra.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2020-05/KKisilevsky_infra)

## Bastion host SSH forwarding with alias for destination host
> Необходимо сгенерировать ssh key для подключения к серверу;

```
ssh-add ~/.ssh/kkisilevsky # добавляем ключ
eval $(ssh-agent -s) # запускаем агент
nano ~/.ssh/config # редактируем файл

Host    84.201.138.84
        ForwardAgent yes

Host    someinternalhost
        Hostname 10.129.0.25
        User kkisilevsky
        ProxyCommand ssh -A kkisilevsky@84.201.138.84 -W %h:%p
```
## Open VPN
 > Установить сервер можно с помощью скрипта setupvpn.sh используя команду "sudo bash setupvpn.sh"
 После успешной настройки сервера необходимо открыть назначеный порт (16270/udp) на сервере bastion;

```
sudo iptables -A INPUT -p udp -m udp --dport 16270 -j ACCEPT 

```
> Для подключения необходимо использовать OpenVPN клиент (Tunnelblick), добавив в него конфигурационный файл *.ovpn
 Данные для аутентификации задаются в разделе веб-интерфейса https://84.201.138.84/#/users;
- bastion_IP = 84.201.138.84 
- someinternalhost_IP = 10.129.0.25


- testapp_IP = 84.201.159.109
- testapp_port = 9292

## Packer
> Создание образа packer необходимо описать в файле .json , пример: 
- packer/immutable.json) 

> Пример использования переменных для сборки образа:
- packer/variables.json.example

- Проверка сборки 
```
packer validate -var-file=variables.json ./immutable.json

```
- Запуск сборки 
```
packer build -var-file=variables.json ./immutable.json

```

> Пример скрипта для запсука ВМ из созданного образа:
- cofig-scripts/create-reddit-vm.sh 

## Terraform 
> Описание основого инстанса: 
- terraform/main.tf

> Объявление input переменных:
- terraform/variables.tf

> Пример описанных input переменных: 
- terraform/terraform.tfvars.example

> Output переменные 
- terraform/output.tf 

> Для хранения файла состояние необходимо создать бакет и описать backend 
- terraform/stage/backend.tf

> После описания backend необходима инициализация
```
terraform init
```

> Для загрузки модулей, после указания в main.tf их необходимо загрузить
```
terrafrom get
```

> Основные команды 
```
terraform plan\apply

terraform destroy
```

## Ansible
> Пример описания inventory
- ansible/inventory.yml

> Использование модулей
```
ansible app -m shell/systemd/service/git -a "{command}"
```

> Пример написания плейбука 
-ansible/clone.yml

> Отличие выполнение модуля  и команды заключается в идемпотентности, модуль не будет повторно пытаться применить изменения, если они уже осуществлены.
Для проверки используется аргумент --check, для указания группы хостов к которым будет применяться play book --limit, --tags для срабатывания тасков с указанным тегом;  

```
ansible-playbook reddit_app.yml --check --limit app --tags deploy-tag
```

* Примеры ansible/*

> Для создание структуры роли ansible-galaxy:

```
ansible-galaxy init app
```

> Для использования inventory конкретного окружения:

```
ansible-playbook -i environments/prod/inventory deploy.yml
```

> Установка роли ansible-galaxy

```
ansible-galaxy install -r environments/stage/requirements.yml
```

> Шифрование чувствительный данный с помощью ansible-vault. " ault_password_file = vault.key " задается в ansible.cfg

```
ansible-vault encrypt/decrypt/edit environments/prod/credentials.yml
```

### Для работы dynamic inventory, необходим скрипт выгружающий данные из terraform 
- /environments/prod/inventory.sh

### Вызов скрипта указывается в ansible.cfg

```
[defaults]
inventory = ./environments/prod/inventory.sh
```
### Проверка yaml на отступы 
```
ansible-lint playbooks/site.yml
```

## Vagrant 
```
vagrant up/halt/destroy # Запустить/Потушить/Убить

vagrant box list # Список боксов

vagrant status # Статус ВМ

vagrant provision dbserver # Запустить провижинеров конкретного инстанса 

vagrant ssh appserver # Подключиться по ssh 
```
## Vagrant inventory

cat .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory

pip install molecule-vagrant # Добавления драйвера vagrant 
