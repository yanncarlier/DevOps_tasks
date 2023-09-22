


## Note: This code is not ready and its just an example for the assignment. this needs revision prototyping / qa testing / before production 


## Below is an example Helm chart structure for deploying the task 2 bit.ly-like service. This Helm chart assumes that we are deploying the application to a Kubernetes cluster.

**Folder Structure**:

```
bitly-like-service/
├── charts/
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
├── values.yaml
├── Chart.yaml
├── README.md
```

**Chart.yaml**:

```yaml
apiVersion: v2
name: bitly-like-service
description: A Helm chart for deploying the bit.ly-like service.
version: 0.1.0
```

**values.yaml**:

```yaml
# Define configurable values for the deployment
replicaCount: 3
image:
  repository: your/bitly-like-service-image
  tag: 1.0.0
  pullPolicy: IfNotPresent
service:
  name: bitly-like-service
  type: ClusterIP
  port: 80
  targetPort: 8080
```

**templates/deployment.yaml**:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "bitly-like-service.fullname" . }}
  labels:
    {{- include "bitly-like-service.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "bitly-like-service.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "bitly-like-service.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.service.name }}
  labels:
    {{- include "bitly-like-service.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
  selector:
    {{- include "bitly-like-service.selectorLabels" . | nindent 4 }}
```

**templates/service.yaml**:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.service.name }}
  labels:
    {{- include "bitly-like-service.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
  selector:
    {{- include "bitly-like-service.selectorLabels" . | nindent 4 }}
```

This Helm chart defines the deployment and service for the bit.ly-like service. We can customize the values in the `values.yaml` file to control the number of replicas, image details, and service configuration. To deploy this chart, you would use Helm commands like `helm install`.

Remember to replace `your/bitly-like-service-image` with the actual Docker image location for your application. Additionally, you may need to add other resources like ConfigMaps or Persistent Volume Claims depending on the application's requirements.
