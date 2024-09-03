{{/*
Expand the name of the chart.
*/}}
{{- define "interop-eks-cronjob-chart.name" -}}
{{- .Values.nameOverride | default .Chart.Name  | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "interop-eks-cronjob-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := .Values.nameOverride |  default .Chart.Name }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "interop-eks-cronjob-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "interop-eks-cronjob-chart.labels" -}}
app.kubernetes.io/name: {{ .Values.name }}
helm.sh/chart: {{ include "interop-eks-cronjob-chart.chart" . }}
{{ include "interop-eks-cronjob-chart.selectorLabels" . }}
{{- if .Values.image.tag }}
{{- $imageTag := "" }}
{{- $imageTag = (nospace .Values.image.tag) }}
app.kubernetes.io/version: {{ $imageTag }}
{{ else if .Values.image.digest }}
{{- $digestSuffix := "" }}
{{- $digestSuffix = (nospace .Values.image.digest) }}
app.kubernetes.io/version: {{ $digestSuffix }}
{{ else if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "interop-eks-cronjob-chart.selectorLabels" -}}
app: {{ .Values.name | quote }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "interop-eks-cronjob-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- .Values.serviceAccount.name |  default (include "interop-eks-cronjob-chart.fullname" .) }}
{{- else }}
{{- .Values.serviceAccount.name | default "default" }}
{{- end }}
{{- end }}

{{/*
Renders a value that contains template perhaps with scope if the scope is present.
Usage:
{{ include "common.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $ ) }}
{{ include "common.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $ "scope" $app ) }}
*/}}
{{- define "common.tplvalues.render" -}}
{{- $value := typeIs "string" .value | ternary .value (.value | toYaml) }}
{{- if contains "{{" (toJson .value) }}
  {{- if .scope }}
    {{- tpl (cat "{{- with $.RelativeScope -}}" $value "{{- end }}") (merge (dict "RelativeScope" .scope) .context) }}
  {{- else }}
    {{- tpl $value .context}}
  {{- end }}
{{- else }}
    {{ $value }}
{{- end }}
{{- end -}}

{{- define "interop-eks-cronjob-chart.render-template" -}}
    {{- if kindIs "string" .value }}
        {{- if contains "{{_local" (toJson .value) }}
            {{- include "common.tplvalues.render" ( dict "value" (.value | replace "{{_local" "{{.Values._local")  "context" .context) }}
        {{- else }}
            {{ .value }}
        {{- end -}}
    {{- end -}}
{{- end -}}
