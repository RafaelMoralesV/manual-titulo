= Registro de problemas
El stack es hambriento en cuanto a RAM al parecer. Hace un rato estaba buscando un bug en el que logstash no parecía poder conectarse a Elasticsearch. Resulta que el servicio había sido matado por un OOM-killer, o sea, el kernel mató el proceso debido a que no poseía suficiente memoria para procesar.
