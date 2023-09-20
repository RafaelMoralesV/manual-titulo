= Instalación <intro>
@intro
Vamos a trabajar esta wea desde fedora, así que vamos a partir con un proceso de instalación para esta distro.

== Llave GPG <llave>
El primer paso es instalar la llave GPG del stack de Elastic.

```bash
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
```

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

== Kibana
creamos el archivo de repo `/etc/yum.repos.d/kibana.repo` con el siguiente contenido:

```toml
[kibana-8.x]
name=Kibana repository for 8.x packages
baseurl=https://artifacts.elastic.co/packages/8.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
```

e instalamos con yum con el comando:
```bash
sudo yum install kibana
```

Luego de hacer toda esta wea, hay que habilitar los servicios:

```bash
sudo systemctl daemon-reload
sudo systemctl enable kibana.service
sudo systemctl start kibana.service
```

=== Configuraciones de Kibana
A continuación, se provee una tabla con valores de configuración y archivos importantes de Kibana
#table(
  columns: 4,
  [*tipo*], [*Descripción*], [*Default*], [*Config*],
  [*home*], [`$KIBANA_HOME`], [`/usr/share/kibana`], [],
  [*bin*], [Ejecutables, tanto `kibana` como `kibana-plugin`], [`/usr/share/kibana/bin`], [],
  [*config*], [Archivos de configuración, como `kibana.yml`], [`/etc/kibana`], [`KBN_PATH_CONF`],
  [*data*], [], [`/var/lib/kibana`], [`path.data`],
  [*logs*], [], [`/var/log/kibana`], [`path.logs`],
  [*plugins*], [], [`/usr/share/kibana/plugins`], [],
)

En el archivo de configuración de Kibana (por defecto `/etc/kibana/kibana.yml`) es importante cambiar la propiedad del host del servidor. Por defecto, en la linea 11, descomenta la propiedad `server.host`, y seteala a la ip pública del servidor. Para la máquina virtual, el resultado fue:

```yml
# ...
server.host: "192.168.122.67"
# ...
```

== Filebeat
Filebeat es un servicio a instalar en cada máquina que se quiera monitorear. El proceso es similar a lo ya visto:

Con la llave GPG instalada (revisar @llave), configuramos un archivo repo de elastic en `/etc/yum.repos.d/elastic.repo` (revisar @repo).

A partir de aquí, filebeats es instalable con el siguiente comando:
```bash
sudo yum install filebeat
```

Solo queda habilitar el servicio con:
```bash
# Habilitar al inicio
sudo systemctl enable filebeat

# Iniciar Filebeat
sudo systemctl start filebeat

# Detener Filebeat
sudo systemctl stop filebeat
```

