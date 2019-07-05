{{- define "presto-hive-catalog-properties" -}}
connector.name=hive-hadoop2
hive.allow-drop-table=true
hive.allow-rename-table=true
hive.storage-format={{ .Values.hive.spec.config.defaultFileFormat | upper }}
hive.compression-codec=SNAPPY
hive.hdfs.authentication.type=NONE
hive.metastore.authentication.type=NONE
hive.metastore.uri={{ .Values.presto.spec.config.connectors.hive.metastoreURI }}
{{- if .Values.presto.spec.config.connectors.hive.metastoreTimeout }}
hive.metastore-timeout={{ .Values.presto.spec.config.connectors.hive.metastoreTimeout }}
{{- end }}
<<<<<<< HEAD
{{- if .Values.presto.spec.config.useHadoopConfig}}
=======
{{- if .Values.presto.spec.hive.config.useHadoopConfig}}
>>>>>>> efaddf2b697bce934a7c4cded77fb80c472bc91d
hive.config.resources=/hadoop-config/core-site.xml
{{- end }}

{{ end }}

{{- define "presto-jmx-catalog-properties" -}}
connector.name=jmx
{{ end }}

{{- define "presto-blackhole-catalog-properties" -}}
connector.name=blackhole
{{ end }}

{{- define "presto-memory-catalog-properties" -}}
connector.name=memory
{{ end }}

{{- define "presto-tpcds-catalog-properties" -}}
connector.name=tpcds
{{ end }}

{{- define "presto-tpch-catalog-properties" -}}
connector.name=tpch
{{ end }}


{{- define "presto-common-env" }}
- name: MY_NODE_ID
  valueFrom:
    fieldRef:
      fieldPath: metadata.uid
- name: MY_NODE_NAME
  valueFrom:
    fieldRef:
      fieldPath: spec.nodeName
- name: MY_POD_NAME
  valueFrom:
    fieldRef:
      fieldPath: metadata.name
- name: MY_POD_NAMESPACE
  valueFrom:
    fieldRef:
      fieldPath: metadata.namespace
- name: MY_MEM_REQUEST
  valueFrom:
    resourceFieldRef:
      containerName: presto
      resource: requests.memory
- name: MY_MEM_LIMIT
  valueFrom:
    resourceFieldRef:
      containerName: presto
      resource: limits.memory
{{- if or .Values.presto.spec.config.aws.secretName .Values.presto.spec.config.aws.createSecret }}
- name: AWS_ACCESS_KEY_ID
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.presto.spec.config.aws.secretName | default "presto-aws-credentials" }}"
      key: aws-access-key-id
- name: AWS_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.presto.spec.config.aws.secretName | default "presto-aws-credentials" }}"
      key: aws-secret-access-key
{{- end }}
{{- end }}
