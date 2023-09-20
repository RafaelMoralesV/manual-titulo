== Logstash
Creamos un archivo `/etc/yum.repos.d/logstash.repo` con el siguiente contenido:

```toml
[logstash-8.x]
name=Elastic repository for 8.x packages
baseurl=https://artifacts.elastic.co/packages/8.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
```
e instalamos logstash con yum con el comando:

```bash
sudo yum install logstash
```

Luego de hacer toda esta wea, hay que habilitar los servicios:

```bash
sudo systemctl daemon-reload
sudo systemctl enable logstash.service
sudo systemctl start logstash.service
```
