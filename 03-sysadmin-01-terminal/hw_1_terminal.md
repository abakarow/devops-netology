# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"


1. Установите средство виртуализации:

`   sudo apt install virtualbox
`

2. Установите средство автоматизации:

`curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - `

`sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"`

`sudo apt-get update && sudo apt-get install vagrant`

3. Работа с Vagrant:

* Создание рабочей папки
* Инициализация
* Правка кода внутри файла 

4. Установка дистрибутива: 

* `vagrant up` - загрузка и установка дистибутива согласно конфигурации
* `vagrant suspend` - остановка с сохранением текущего состояния машины


