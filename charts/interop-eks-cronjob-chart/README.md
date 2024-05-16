
# interop-eks-cronjob-chart

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

A Helm chart for PagoPa Interop CronJobs

## Values

The following table lists the configurable parameters of the Interop-eks-cronjob-chart chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| activeDeadlineSeconds | int | 3600 | The activeDeadlineSeconds applies to the duration of the job, no matter how many Pods are created. Once a Job reaches activeDeadlineSeconds, all of its running Pods are terminated. |
| concurrencyPolicy | string | Allow | [concurrencyPolicy](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#concurrency-policy) field specifies how to treat concurrent executions of a Job that is created by this CronJob. |
| failedJobsHistoryLimit | int | 1 | [failedJobsHistoryLimit](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#jobs-history-limits) field specifies the number of failed finished jobs to keep. Setting this field to 0 will not keep any failed jobs. |
| image.digest | string | `nil` | Image digest |
| image.imagePullPolicy | string | `"Always"` |  |
| image.repositoryPrefix | string | `nil` | Image repository |
| image.tag | string | `nil` | Image tag |
| name | string | `nil` | Name of the service that will be deployed on K8s cluster |
| namespace | string | `nil` | Namespace hosting the service that will be deployed on K8s cluster |
| replicas | int | 1 | Number of desired replicas for the service being deployed |
| resources | object | `{"limits":{"cpu":null,"mem":null},"requests":{"cpu":null,"mem":null}}` | K8s container resources requests and limits |
| restartPolicy | string | `"OnFailure"` |  |
| roleArn | string | `nil` | ServiceAccount roleARN used for eks.amazonaws.com/role-arn annotation |
| schedule | string | `nil` | The [schedule](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#schedule-syntax) field is required. The value of that field follows the [Cron](https://en.wikipedia.org/wiki/Cron) syntax. |
| successfulJobsHistoryLimit | int | 0 | [successfulJobsHistoryLimit](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#jobs-history-limits) field specifies the number of successful finished jobs to keep. Setting this field to 0 will not keep any successful jobs |
| suspend | boolean | `false` | [suspend](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#schedule-suspension) field allows to suspend execution of Jobs for a CronJob.   @default -- false. |
| techStack | enum | `nil` | Defines the technology used to develop the container. The following values are allowed: [ "nodejs", "scala"] |

## 1. Configurazione di Cronjob

### 1.1. Env

#### 1.1.1. <ins>configmap - Referenziare la ConfigMap del Cronjob
Per referenziare una chiave dalla ConfigMap è necessario aggiungere una coppia chiave/valore nel blocco "configmap" nel file _values.yaml_ specifico per il Cronjob.
La coppia chiave/valore deve essere così definita:
* Chiave: è mappata con il nome (name) della variabile d'ambiente utilizzata dal Cronjob ed, al contempo, con la chiave definita nella ConfigMap; dunque le due chiavi coincidono;
* Valore: è il valore reale associato alla chiave precedentemente definita

Dichiarando la sezione "configmap" nel file _values.yaml_ di uno specifico Cronjob saranno applicati i seguenti automatismi:
* sarà creata una ConfigMap con lo stesso "name" del Cronjob;
* il campo "data" di tale ConfigMap sarà popolato con tutti le coppie chiave/valore definite in "configmap"
* nel Deployment sarà aggiunto nella sezione "env" un riferimento per ogni coppia chiave/valore definita nella ConfigMap del Cronjob

Definendo la seguente configurazione d'esempio nel _values.yaml_ del Cronjob, ad esempio "dashboard-metrics-report-generator" per ambiente "qa":

```
# /jobs/dashboard-metrics-report-generator/qa/values.yaml

configmap:
    ENV_FIELD_KEY: "ENV_FIELD_VALUE"
```

sarà creata una ConfigMap dedicata e contenente i dati indicati:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: "dashboard-metrics-report-generator"
  namespace: "qa"
data:
  ENV_FIELD_KEY: "ENV_FIELD_VALUE"
```

e sarà aggiunto un riferimento nel Cronjob nella sezione _env_:

```
env:
  - name: ENV_FIELD_KEY
    valueFrom:
      configMapKeyRef:
        name: "dashboard-metrics-report-generator"
        key: ENV_FIELD_KEY
```

Non c'è limite al numero di variabili d'ambiente configurabili nella sezione "configmap".

#### 1.1.2. <ins>envFromConfigmaps - Referenziare una ConfigMap esterna</ins>

Per referenziare una chiave da una ConfigMap esterna, è necessario aggiungere una coppia chiave/valore nel blocco "deployment.envFromConfigmaps" nel file _values.yaml_ specifico per il Cronjob.
La coppia chiave/valore deve essere così definita:
* Chiave: è mappata con il nome (name) della variabile d'ambiente utilizzata dal Cronjob
* Valore: è composto da due valori separati dal carattere "."; il primo valore rappresenta il nome della ConfigMap esterna referenziata, il secondo valore è la chiave desiderata definita nella ConfigMap

Definendo la seguente configurazione d'esempio nel _values.yaml_ del Cronjob, ad esempio "dashboard-metrics-report-generator" per ambiente "qa":

```
# /jobs/dashboard-metrics-report-generator/qa/values.yaml

deployment:
  envFromConfigmaps:
    CUSTOM_LABEL: "external-configmap-name.REFERENCED_LABEL"
```

sarà aggiunto un riferimento nel Cronjob nella sezione _env_:

```
env:
  - name: CUSTOM_LABEL
    valueFrom:
      configMapKeyRef:
        name: "external-configmap-name"
        key: REFERENCED_LABEL
```

Non c'è limite al numero di variabili d'ambiente configurabili nella sezione "envFromConfigmaps".

#### 1.1.3. <ins>envFromSecrets - Referenziare un Secret esterno</ins>

Per referenziare una chiave da un Secret esterno è necessario aggiungere una coppia chiave/valore nel blocco "deployment.envFromSecrets" nel file _values.yaml_ specifico per il Cronjob.
La coppia chiave/valore deve essere così definita:
* Chiave: è mappata con il nome (name) della variabile d'ambiente utilizzata dal Cronjob
* Valore: è composto da due valori separati dal carattere "."; il primo valore rappresenta il nome del Secret esterno referenziato, il secondo valore è la chiave desiderata definita nel Secret

Definendo la seguente configurazione d'esempio nel _values.yaml_ del Cronjob, ad esempio "dashboard-metrics-report-generator" per ambiente "qa":

```
# /jobs/dashboard-metrics-report-generator/qa/values.yaml

deployment:
  envFromSecrets:
    CUSTOM_LABEL: "external-secret-name.REFERENCED_LABEL"
```

sarà aggiunto un riferimento nel Cronjob nella sezione _env_:

```
- name: CUSTOM_LABEL
  valueFrom:
    secretKeyRef:
        name: "external-secret-name"
        key: REFERENCED_LABEL
```

Non c'è limite al numero di variabili d'ambiente configurabili nella sezione "envFromSecrets".

#### 1.1.4 <ins>env - Definire variabili d'ambiente custom</ins>

Per definire una variabile d'ambiente custom per il Cronjob è necessario aggiungere una coppia chiave/valore nel blocco "deployment.env" nel file _values.yaml_ specifico per il Cronjob.
Definendo la seguente configurazione d'esempio al file _values.yaml_ del Cronjob, ad esempio "dashboard-metrics-report-generator" per ambiente "qa":

```
# /jobs/dashboard-metrics-report-generator/qa/values.yaml

deployment:
  env:
    ENV_NAME: "ENV_VALUE"
```

sarà aggiunto un riferimento nel Cronjob nella sezione _env_:

```
- env:
  - name: "ENV_NAME"
    value: "ENV_VALUE"
```

Non c'è limite al numero di variabili d'ambiente configurabili nella sezione "env".

#### 1.1.5 <ins>envFieldRef - Referenziare informazioni del Pod</ins>

Per esporre dei campi del Pod al runtime del container, è possibile utilizzare il campo "fieldRef", come da [documentazione](https://kubernetes.io/docs/concepts/workloads/pods/downward-api/#downwardapi-fieldRef) ufficiale Kubernetes.
Un campo esposto con "fieldRef" può essere referenziato dal Deployment di un Cronjob, ad esempio "dashboard-metrics-report-generator" per ambiente "qa", inserendo la seguente configurazione nel file _values.yaml_ come segue:

```
# /jobs/dashboard-metrics-report-generator/qa/values.yaml

deployment:
  envFieldRef:
    NAMESPACE: "metadata.namespace"
```

Tale configurazione è mappata nel Cronjob in questo modo:

```
env:
 - name: "NAMESPACE"
   valueFrom:
     fieldRef:
       fieldPath: "metadata.namespace"
```

Non c'è limite al numero di variabili d'ambiente configurabili nella sezione "envFieldRef".

### 1.2 Volumi

Di seguito sono descritte le configurazioni da aggiungere al file _values.yaml_ del Cronjob per aggiungere uno o più volume e volumeMounts.

**Volumes**
Seguendo la documentazione Kubernetes ufficiale in merito ai [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/), per aggiungere un volume è necessario aggiornare il file _values.yaml_ del Cronjob da configurare, ad esempio "dashboard-metrics-report-generator" per ambiente "qa", utilizzando la seguente sintassi:

```
# /jobs/dashboard-metrics-report-generator/qa/values.yaml

deployment:
  volumes:
    - name: categories-index-volume
      emptyDir: {}
```

Il campo "volumes" può contenere la definizione di uno o più oggetti.

**Volume Mounts**
Per aggiungere un volumeMounts relativo ad un volume configurato, è necessario aggiornare il file _values.yaml_ del Cronjob, ad esempio "dashboard-metrics-report-generator" per ambiente "qa", utilizzando la seguente sintassi:

```
# /jobs/dashboard-metrics-report-generator/qa/values.yaml

deployment:
  volumeMounts:
    - name: categories-index-volume
      mountPath: /opt/docker/index/categories
```

Il campo "volumeMounts" può contenere la definizione di uno o più oggetti.

---

