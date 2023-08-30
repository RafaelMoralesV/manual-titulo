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
== Llave GPG
El primer paso es instalar la llave GPG del stack de Elastic.

```bash
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
```

== Elasticsearch
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

== Motivation
@abarbanell1998abnormal11
#lorem(140)

= Data 
#cite("abarbanell1998abnormal11","abarbanell1998abnormal")
#lorem(100)

= Conclusion
#lorem(100)



