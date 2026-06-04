{{- define "portfolio-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "portfolio-api.fullname" -}}
{{- printf "%s" (include "portfolio-api.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
