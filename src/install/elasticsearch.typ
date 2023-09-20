== Elasticsearch <repo>

Creamos un archivo `/etc/yum.repos.d/elasticsearch.repo` con el siguiente contenido:

```toml
[elasticsearch]
name=Elasticsearch repository for 8.x packages
baseurl=https://artifacts.elastic.co/packages/8.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md
```

e instalamos elastic con yum con el comando:

```bash
sudo yum install --enablerepo=elasticsearch elasticsearch
```

Luego de hacer toda esta wea, hay que habilitar los servicios:

```bash
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
```

=== Configuración de Elasticsearch
Elasticsearch viene con una configuración de TLS por defecto. Es posible que esta configuración por defecto provea conflictos con los deseos o arquitectura de SISEI según se trabaje, pero en un principio, se debería probar tal cual viene. Los únicos cambios sugeridos son los siguientes: se debe cambiar una propiedad del archivo de configuración (por defecto `/etc/elasticsearch/elasticsearch.yml`) y reiniciar el servicio.

```yml
# ...

# Descomenta esta línea:
node.name = node-1

# Descomenta y cambia el valor a:
network.host: 0.0.0.0

# Descomenta y cambia el valor a:
discovery.seed_hosts: ["127.0.0.1"]

# Indicamos el nodo maestro como este:
cluset.initial_master_nodes: ["node-1"]

#
```
