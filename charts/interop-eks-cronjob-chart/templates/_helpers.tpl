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
{{- if .Values.cronjob.image.tag }}
{{- $imageTag := "" }}
{{- $imageTag = ( print .Values.cronjob.image.tag | nospace ) }}
app.kubernetes.io/version: {{ $imageTag | quote }}
{{ else if .Values.cronjob.image.digest }}
{{- $digestSuffix := "" }}
{{- $digestSuffix = (nospace .Values.cronjob.image.digest) }}
app.kubernetes.io/version: {{ $digestSuffix }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "interop-eks-cronjob-chart.selectorLabels" -}}
app: {{ .Values.name }}
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

{{- define "interop-eks-cronjob-chart.check-tpl-value" -}}
  {{- $givenValue := typeIs "string" .value | ternary .value (.value | toYaml) }}
  {{- $givenContext := .context }}
  {{- $givenScope := .scope }}

  {{- $pattern := `{{\.Values[^}]+}}` }}
  {{- $valuesMatches := (regexFindAll $pattern $givenValue -1) }}

  {{- /* For every match check if the rendered template is valid, i.e. not empty/null */}}
  {{- range $index, $match := $valuesMatches }}
    {{- $renderedValue := include "interop-eks-cronjob-chart.render-tpl-value" (dict "value" $match "context" $givenContext "scope" $givenScope) }}
    {{- if or (eq $renderedValue nil) (eq $renderedValue "")  }}
      {{ fail (printf "Error: %s must be set and non-empty" $match) }}
    {{- end }}
  {{- end }}
{{- end -}}


{{- define "interop-eks-cronjob-chart.render-tpl-value" -}}
  {{- $givenValue := .value }}
  {{- $givenContext := .context }}
  {{- $givenScope := .scope }}
  {{- $renderedValue := "" }}

  {{- if and (ne $givenScope nil) (ne $givenScope "") }}
    {{- $renderedValue = tpl (cat "{{- with $.RelativeScope -}}" $givenValue "{{- end }}") (merge (dict "RelativeScope" $givenScope) $givenContext) }}
  {{- else }}
    {{- $renderedValue = tpl $givenValue $givenContext -}}
  {{- end }}

  {{- $renderedValue -}}
{{- end -}}

{{/*
Renders a value that contains template perhaps with scope if the scope is present.
Usage:
{{ include "interop-eks-cronjob-chart.render-template" ( dict "value" .Values.path.to.the.Value "context" $ ) }}
{{ include "interop-eks-cronjob-chart.render-template" ( dict "value" .Values.path.to.the.Value "context" $ "scope" $app ) }}
*/}}
{{- define "interop-eks-cronjob-chart.render-template" -}}
{{- $value := typeIs "string" .value | ternary .value (.value | toYaml) }}

{{- if and (typeIs "string" $value) (contains "{{" (toJson $value)) }}
  {{- $givenScope := .scope }}
  {{- $givenContext := .context }}

  {{- include "interop-eks-cronjob-chart.check-tpl-value" (dict "value" $value "context" $givenContext "scope" $givenScope) -}}
  {{- include "interop-eks-cronjob-chart.render-tpl-value" (dict "value" $value "context" $givenContext "scope" $givenScope) -}}
{{- else }}
  {{- $value -}}
{{- end -}}
{{- end -}}

{{/*
Contract marker for ExternalSecrets.
This is used to detect changes in the contract between the chart and ExternalSecrets.
If the contract changes, the hash will change, and ExternalSecrets can trigger a rollout of the CronJob to pick up the changes.
Expects dict with 'data' key.
*/}}
{{- define "externalsecrets.contractMarker" -}}
{{- $data := .data }}
{{- if $data }}
{{- toJson $data | sha256sum }}
{{- end -}}
{{- end -}}


{{/* Validate a single environment variable name. */}}
{{- define "interop-eks-cronjob-chart.validateEnvVarName" -}}
{{- $scope := .scope | default "values" -}}
{{- $path := .path | default "key" -}}
{{- $name := .name | default "" -}}
{{- if not (regexMatch "^[A-Za-z_][A-Za-z0-9_]*$" $name) -}}
{{- fail (printf "Invalid configuration: %s.%s='%s' is not a valid environment variable name. Allowed pattern: ^[A-Za-z_][A-Za-z0-9_]*$" $scope $path $name) -}}
{{- end -}}
{{- end -}}

{{/* Validate all keys of a map used as env var names. */}}
{{- define "interop-eks-cronjob-chart.validateEnvVarNamesFromMapKeys" -}}
{{- $scope := .scope | default "values" -}}
{{- $path := .path | default "map" -}}
{{- $entries := .entries | default dict -}}
{{- range $key, $_ := $entries }}
{{- include "interop-eks-cronjob-chart.validateEnvVarName" (dict "scope" $scope "path" (printf "%s[%s]" $path $key) "name" $key) -}}
{{- end -}}
{{- end -}}

{{/* Validate ExternalSecret secretKey values used by envFrom. */}}
{{- define "interop-eks-cronjob-chart.validateEnvVarNamesFromExternalSecretData" -}}
{{- $scope := .scope | default "externalSecrets" -}}
{{- $path := .path | default "data" -}}
{{- $entries := .entries | default (list) -}}
{{- range $idx, $entry := $entries }}
{{- $secretKey := get $entry "secretKey" | default "" -}}
{{- include "interop-eks-cronjob-chart.validateEnvVarName" (dict "scope" $scope "path" (printf "%s[%d].secretKey" $path $idx) "name" $secretKey) -}}
{{- end -}}
{{- end -}}