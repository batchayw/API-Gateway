{{/*--------- 
  gateway-api.name : Nom de base du déploiement
  Priorité :
  1. .Values.nameOverride si défini
  2. .Chart.Name par défaut
  Limité à 63 caractères (contrainte Kubernetes)
---------*/}}
{{- define "gateway-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*---------
  gateway-api.fullname : Nom complet avec gestion des overrides
  Logique :
  1. .Values.fullnameOverride si défini
  2. Sinon combine Release.Name et le nom de base
  3. Évite les doubles appellations si Release.Name contient déjà le nom
---------*/}}
{{- define "gateway-api.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "gateway-api.name" . -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*---------
  gateway-api.chart : Identifiant unique du chart
  Combine le nom et la version du chart
  Format utilisé dans les labels standards
---------*/}}
{{- define "gateway-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*---------
  gateway-api.labels : Labels standards Kubernetes
  Inclut :
  - Les labels Helm standards
  - Les selectorLabels
  - La version de l'application si définie
  - Le gestionnaire (Helm)
---------*/}}
{{- define "gateway-api.labels" -}}
helm.sh/chart: {{ include "gateway-api.chart" . }}
{{ include "gateway-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*---------
  gateway-api.selectorLabels : Labels pour les sélecteurs
  Version minimale utilisée dans les selectors de services/deployments
  Inclut :
  - Le nom standardisé de l'application
  - L'instance de release
---------*/}}
{{- define "gateway-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gateway-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*---------
  gateway-api.serviceAccountName : Nom du ServiceAccount
  Logique :
  1. Si .Values.serviceAccount.create = true, utilise le fullname
  2. Sinon utilise .Values.serviceAccount.name ou "default"
---------*/}}
{{- define "gateway-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "gateway-api.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*---------
  gateway-api.tlsSecretName : Nom du secret TLS
  Utilisé pour les certificats cert-manager
  Format : <release-name>-tls
---------*/}}
{{- define "gateway-api.tlsSecretName" -}}
{{- printf "%s-tls" (include "gateway-api.fullname" .) -}}
{{- end -}}

{{/*---------
  gateway-api.listenerPort : Helper pour les ports des listeners
  Exemple d'usage : {{ include "gateway-api.listenerPort" (dict "port" 443 "context" $) }}
---------*/}}
{{- define "gateway-api.listenerPort" -}}
{{- $ctx := .context -}}
{{- $port := .port -}}
{{- range $ctx.Values.gateway.listeners -}}
{{- if eq .port $port -}}
{{- $port -}}
{{- end -}}
{{- end -}}
{{- end -}}