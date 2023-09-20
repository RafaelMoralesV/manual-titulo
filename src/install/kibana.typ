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
