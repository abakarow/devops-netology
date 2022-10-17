# Домашнее задание к занятию "09.02 CI\CD"

## Знакомоство с SonarQube

### Подготовка к выполнению

1. Выполняем `docker pull sonarqube:8.7-community`
2. Выполняем `docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:8.7-community`
3. Ждём запуск, смотрим логи через `docker logs -f sonarqube`
4. Проверяем готовность сервиса через [браузер](http://localhost:9000)
5. Заходим под admin\admin, меняем пароль на свой

В целом, в [этой статье](https://docs.sonarqube.org/latest/setup/install-server/) описаны все варианты установки, включая и docker, но так как нам он нужен разово, то достаточно того набора действий, который я указал выше.

### Основная часть

1. Создаём новый проект, название произвольное
2. Скачиваем пакет sonar-scanner, который нам предлагает скачать сам sonarqube
3. Делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
### Решение
```
export PATH=$PATH:/var/lib/sonar-scanner-4.7.0.2747-linux/bin
 ```
4. Проверяем `sonar-scanner --version`
### Решение
```
ops@ops-Lenovo-G780:~$ sonar-scanner --version 
INFO: Scanner configuration file: /var/lib/sonar-scanner-4.7.0.2747-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Linux 5.15.0-50-generic amd64
```

5. Запускаем анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`
### Решение
```
ops@ops-Lenovo-G780:~/PycharmProjects/devops-netology/09-ci-02-cicd/example$ sonar-scanner   
-Dsonar.projectKey=Abakarow   
-Dsonar.sources=.   
-Dsonar.host.url=http://localhost:9000  
-Dsonar.login=4436686cab8530345637d062f8c8d8341663532f 
-Dsonar.coverage.exclusions=fail.py
```

6. Смотрим результат в интерфейсе
### Решение
![](src/2022-10-17_07-18.png)
7. Исправляем ошибки, которые он выявил(включая warnings)
### Решение
![](src/2022-10-17_07-23.png)
8. Запускаем анализатор повторно - проверяем, что QG пройдены успешно
9. Делаем скриншот успешного прохождения анализа, прикладываем к решению ДЗ
### Решение
![](src/2022-10-17_07-24.png)

## Знакомство с Nexus

### Подготовка к выполнению

1. Выполняем `docker pull sonatype/nexus3`
### Решение
```
ops@ops-Lenovo-G780:~$ docker pull sonatype/nexus3
Using default tag: latest
latest: Pulling from sonatype/nexus3
d5d2e87c6892: Pull complete 
008dba906bf6: Pull complete 
b4e2142a7ee0: Pull complete 
75bdf4e3eda5: Pull complete 
754b7a6e063a: Pull complete 
54fb6fd82993: Pull complete 
484f7f034926: Pull complete 
e0a41b95cd8d: Pull complete 
Digest: sha256:7e7abd3418d507d5263460eda83e239aff758cd362f8add54d9c9846cada2533
Status: Downloaded newer image for sonatype/nexus3:latest
docker.io/sonatype/nexus3:latest
```
2. Выполняем `docker run -d -p 8081:8081 --name nexus sonatype/nexus3`
### Решение
```
ops@ops-Lenovo-G780:~$ docker run -d -p 8081:8081 --name nexus sonatype/nexus3
42c974befdd3dca857bb7c529fb5002935e92b2b99f4f227753a8d62f5bbed1d
```
3. Ждём запуск, смотрим логи через `docker logs -f nexus`
### Решение
```
-------------------------------------------------

Started Sonatype Nexus OSS 3.42.0-01

-------------------------------------------------
```
4. Проверяем готовность сервиса через [бразуер](http://localhost:8081)
### Решение
![](src/2022-10-17_07-55.png)
5. Узнаём пароль от admin через `docker exec -it nexus /bin/bash`
### Решение
```

ops@ops-Lenovo-G780:~$ sudo docker exec -it nexus /bin/bash
bash-4.4$ cat /nexus-data/admin.password 
208ab907-9a05-4432-a397-4a56413e40aebash-4.4$ 
```


6. Подключаемся под админом, меняем пароль, сохраняем анонимный доступ
![](src/2022-10-17_08-01.png)
### Основная часть

1. В репозиторий `maven-public` загружаем артефакт с GAV параметрами:
   1. groupId: netology
   2. artifactId: java
   3. version: 8_282
   4. classifier: distrib
   5. type: tar.gz
2. В него же загружаем такой же артефакт, но с version: 8_102
### Решение
![](src/2022-10-17_08-13.png)
3. Проверяем, что все файлы загрузились успешно
### Решение
![](src/2022-10-17_08-14.png)
4. В ответе присылаем файл `maven-metadata.xml` для этого артефекта
### Решение
[maven-metadata.xml](https://github.com/abakarow/devops-netology/blob/main/09-ci-02-cicd/src/maven-metadata.xml)

### Знакомство с Maven

### Подготовка к выполнению

1. Скачиваем дистрибутив с [maven](https://maven.apache.org/download.cgi)
### Решение
```
ops@ops-Lenovo-G780:~$ wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.zip
--2022-10-17 08:23:55--  https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.zip
Распознаётся dlcdn.apache.org (dlcdn.apache.org)… 151.101.2.132, 2a04:4e42::644
Подключение к dlcdn.apache.org (dlcdn.apache.org)|151.101.2.132|:443... соединение установлено.
HTTP-запрос отправлен. Ожидание ответа… 200 OK
Длина: 8760013 (8,4M) [application/zip]
Сохранение в: «apache-maven-3.8.6-bin.zip»

apache-maven-3.8.6-bin.zip                   100%[===========================================================================================>]   8,35M   382KB/s    за 17s     

2022-10-17 08:24:13 (489 KB/s) - «apache-maven-3.8.6-bin.zip» сохранён [8760013/8760013]
```

2. Разархивируем, делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
### Решение
```
ops@ops-Lenovo-G780:~$ export PATH=$PATH:/var/lib/apache-maven-3.8.6/bin
```
3. Проверяем `mvn --version`
### Решение
```
ops@ops-Lenovo-G780:~$ mvn --version 
Apache Maven 3.8.6 (84538c9988a25aec085021c365c560670ad80f63)
Maven home: /var/lib/apache-maven-3.8.6
Java version: 11.0.16, vendor: Ubuntu, runtime: /usr/lib/jvm/java-11-openjdk-amd64
Default locale: ru_RU, platform encoding: UTF-8
OS name: "linux", version: "5.15.0-50-generic", arch: "amd64", family: "unix"

```

4. Забираем директорию [mvn](./mvn) с pom

### Основная часть

1. Меняем в `pom.xml` блок с зависимостями под наш артефакт из первого пункта задания для Nexus (java с версией 8_282)
2. Запускаем команду `mvn package` в директории с `pom.xml`, ожидаем успешного окончания
### Решение
```
$ mvn package
[INFO] Scanning for projects...
[INFO]
[INFO] --------------------< com.netology.app:simple-app >---------------------
[INFO] Building simple-app 1.0-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
...
[INFO] Building jar: /home/ops/devops-netology/9.2/mvn/target/simple-app-1.0-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  01:00 min
[INFO] Finished at: 2022-10-17T08:27:46Z
[INFO] ------------------------------------------------------------------------
```
3. Проверяем директорию `~/.m2/repository/`, находим наш артефакт

### Решение
![](src/2022-10-17_08-38.png)

4.В ответе присылаем исправленный файл `pom.xml`
### Решение
[pom.xml](https://github.com/abakarow/devops-netology/blob/main/09-ci-02-cicd/src/pom.xml)
