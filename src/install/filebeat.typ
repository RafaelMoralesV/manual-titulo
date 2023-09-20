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
