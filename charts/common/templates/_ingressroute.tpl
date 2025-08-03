{{- define "common.ingressroute" -}}
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: {{ .Values.application.name }}
  annotations:
    traefik.ingress.kubernetes.io/router.middlewares: authelia@kubernetescrd
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`{{ .Values.ingress.host }}`)
      kind: Rule
      services:
        - name: {{ .Values.application.name }}
          port: {{ .Values.service.port }}
{{- end -}}
