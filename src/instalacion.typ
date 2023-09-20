= Instalación <intro>
@intro
Vamos a trabajar esta wea desde fedora, así que vamos a partir con un proceso de instalación para esta distro.

== Llave GPG <llave>
El primer paso es instalar la llave GPG del stack de Elastic.

```bash
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
```

#include("install/elasticsearch.typ");
#include("install/logstash.typ");
#include("install/kibana.typ");
#include("install/filebeat.typ");

