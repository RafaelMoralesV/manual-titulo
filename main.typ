#import "paper_template.typ": paper
#show: doc => paper(
  // font: "palatino", // "Times New Roman"
  // fontsize: 12pt, // 12pt
  title: [Manual de Instrucciones - Stack ELK], // title 
  authors: (
    (
      name: "Rafael Morales Venegas",
      affiliation: "Universidad Tecnológica Metropolitana",
      email: "rmorales@utem.cl",
      note: "Alumno Tesista 2023",
    ),
  ),
  date: "July 2023",
  abstract: lorem(80), // replace lorem(80) with [ Your abstract here. ]
  keywords: [
    Elastic Stack,
    SISEI,
    Monitoreo de Logs
    Centralización de Logs,
    ],
  JEL: [G11, G12],
  acknowledgements: "This paper is a work in progress. Please do not cite without permission.", // Acknowledgements 
  bibloc: "My Library.bib",
  // bibstyle: "chicago-author-date", // ieee, chicago-author-date, apa, mla
  // bibtitle: "References",
  doc,
)

#set raw(block: true)
// Display inline code in a small box
// that retains the correct baseline.
#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

// Display block code in a larger block
// with more padding.
#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
)

// your main text goes here
#set heading(numbering: "1.")
#set text(spacing: 100%)
#set par(leading: 1.5em)
#set par(
  first-line-indent: 2em,
  justify: true,
)
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

= Primera Configuración
== Kibana
Cuando ya puedas acceder a Kibana, lo primero que verás es un Enrollment token. No sé si yo lo perdí al momento de instalar, o si simplemente no aparece, pero este puede regenerarse sin problemas. Para esto, necesitas el siguiente comando (por defecto):

```bash
sudo /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token --scope kibana
```

Pegamos el token, y nos pedira copiar un codigo de verificacion de 6 digitos, que se puede generar con el siguiente comando:

```bash
sudo /usr/share/kibana/bin/kibana-verification-code
```

Hecho esto, Kibana empezará a armar la configuración. Esto toma un buen rato! Anecdóticamente, a mí se me quedó pegado en esta etapa. Al abrir una pestaña de Kibana, podía logearme con el usuario de Elastic.

== Filebeat
Filebeat presenta muchas configuraciones distintas que se pueden usar para extraer datos de los logs de múltiples programas, que se encuentran en el directorio (por defecto) `/etc/filebeat/modules.d`. Todos los archivos toman la forma de `{programa}.yml.disabled` en un inicio. Como ejemplo, se configurará nginx tomando el archivo `/etc/filebeat/modules.d/nginx.yml`:

```yml
# Module: nginx
# Docs: https://www.elastic.co/guide/en/beats/filebeat/main/filebeat-module-nginx.html

- module: nginx
  # Access logs
  access:
    enabled: true

    # Set custom paths for the log files. If left empty,
    # Filebeat will choose the paths depending on your OS.
    var.paths: ["/home/rafael/Siga/nginx/access.log-*"]

  # Error logs
  error:
    enabled: true

    # Set custom paths for the log files. If left empty,
    # Filebeat will choose the paths depending on your OS.
    var.paths: ["/home/rafael/Siga/nginx/error.log-*"]

  # Ingress-nginx controller logs. This is disabled by default. It could be used in Kubernetes environments to parse ingress-nginx logs
  ingress_controller:
    enabled: false

    # Set custom paths for the log files. If left empty,
    # Filebeat will choose the paths depending on your OS.
    #var.paths:
```

A partir de aquí, se debería configurar el archivo de filebeat para conectarlo con nuestra instancia de Logstash. Para esto, modificamos el archivo `/etc/filebeat/filebeat.yml` tal que:

```yml
# ...
setup.kibana:
 host: "192.168.122.67:5601"

# ...
output.elasticsearch:
  hosts: ["192.168.122.67:9200"]

  # Cambiar según corresponda
  username: "elastic"
  password: "{la contraseña de este usuario}"
```

= Registro de problemas
El stack es hambriento en cuanto a RAM al parecer. Hace un rato estaba buscando un bug en el que logstash no parecía poder conectarse a Elasticsearch. Resulta que el servicio había sido matado por un OOM-killer, o sea, el kernel mató el proceso debido a que no poseía suficiente memoria para procesar.
