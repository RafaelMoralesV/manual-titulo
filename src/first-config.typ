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
