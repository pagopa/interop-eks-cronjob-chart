
# interop-eks-cronjob-chart

![Version: 1.11.0](https://img.shields.io/badge/Version-1.11.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

A Helm chart for PagoPa Interop CronJobs

## Values

The following table lists the configurable parameters of the Interop-eks-cronjob-chart chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cronjob.activeDeadlineSeconds | int | 3600 | The activeDeadlineSeconds applies to the duration of the job, no matter how many Pods are created. Once a Job reaches activeDeadlineSeconds, all of its running Pods are terminated. |
| cronjob.automountServiceAccountToken | bool | true | [automountServiceAccountToken](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#use-the-default-service-account-to-access-the-api-server) |
| cronjob.backoffLimit | int | `6` | [backoffLimit](https://kubernetes.io/docs/concepts/workloads/controllers/job/#handling-pod-and-container-failures) the number of retries before marking a Job as failed. |
| cronjob.concurrencyPolicy | string | Allow | [concurrencyPolicy](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#concurrency-policy) field specifies how to treat concurrent executions of a Job that is created by this CronJob. |
| cronjob.env | object | `nil` | List of environment variables for a container, specifying a value directly for each named variable |
| cronjob.envFromConfigmaps | object | `nil` | List of environment variables for a container, specifying a key from a Configmap for each named variable (k8s equivalent of envFrom.configMapRef) |
| cronjob.envFromFieldRef | object | `nil` | List of pod fields used as values for environment variablesenvironment variables for a container, specifying a key from a Secret for each named variable (k8s equivalent of env.valueFrom.fieldRef.fieldPath) |
| cronjob.envFromSecrets | object | `nil` | List of environment variables for a container, specifying a key from a Secret for each named variable (k8s equivalent of envFrom.secretRef) |
| cronjob.failedJobsHistoryLimit | int | 1 | [failedJobsHistoryLimit](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#jobs-history-limits) field specifies the number of failed finished jobs to keep. Setting this field to 0 will not keep any failed jobs. |
| cronjob.flywayInitContainer.create | bool | `false` |  |
| cronjob.flywayInitContainer.downloadRedshiftDriver | bool | `false` | downloadRedshiftDriver: if true, the init container will download the Redshift JDBC driver from the official AWS S3 bucket and place it in the Flyway drivers directory before executing any Flyway command. This is required when using Flyway with Redshift, as the driver is not included in the default Flyway image. |
| cronjob.flywayInitContainer.env | object | `{}` | List of environment variables for a container, specifying a value directly for each named variable |
| cronjob.flywayInitContainer.envFromConfigmaps | object | `{}` | List of environment variables for a container, specifying a key from a Configmap for each named variable (k8s equivalent of envFrom.configMapRef) |
| cronjob.flywayInitContainer.envFromFieldRef | object | `{}` | List of pod fields used as values for environment variablesenvironment variables for a container, specifying a key from a Secret for each named variable (k8s equivalent of env.valueFrom.fieldRef.fieldPath) |
| cronjob.flywayInitContainer.envFromSecrets | object | `{}` | List of environment variables for a container, specifying a key from a Secret for each named variable (k8s equivalent of envFrom.secretRef) |
| cronjob.flywayInitContainer.executeFlywayMigrate | bool | `true` | execute Flyway migrate command to apply migrations to the database |
| cronjob.flywayInitContainer.executeFlywayRepair | bool | `false` | execute Flyway repair command to recompute applied migrations checksum metadata; useful for whitespace changes |
| cronjob.flywayInitContainer.image.digest | string | `nil` | if set, overrides tag with the specified digest |
| cronjob.flywayInitContainer.image.repositoryName | string | `nil` | must be set if create is true, e.g. "interop-flyway-migrations" |
| cronjob.flywayInitContainer.image.repositoryPrefix | string | `nil` |  |
| cronjob.flywayInitContainer.image.tag | string | `nil` | defaults to deployment image tag if not set |
| cronjob.flywayInitContainer.migrationPaths | string | `nil` | List of comma separated paths to migration files or directories containing migration files (e.g. "/migrations/a_directory,v1_migration.sql,/migrations/b_directory") |
| cronjob.flywayInitContainer.migrationsConfigmap | string | `nil` | Configmap with migrations |
| cronjob.image | object | `{"digest":null,"imagePullPolicy":"Always","repositoryName":null,"repositoryPrefix":null,"tag":null}` | Cronjob image configuration |
| cronjob.image.digest | string | `nil` | Image digest |
| cronjob.image.imagePullPolicy | string | `"Always"` | Image pull policy |
| cronjob.image.repositoryName | string | `nil` | Alternative image name |
| cronjob.image.repositoryPrefix | string | `nil` | Image repository |
| cronjob.image.tag | string | `nil` | Image tag |
| cronjob.resources | object | `{"limits":{"cpu":null,"memory":null},"requests":{"cpu":null,"memory":null}}` | K8s container resources requests and limits |
| cronjob.restartPolicy | string | `"OnFailure"` |  |
| cronjob.schedule | string | `nil` | The [schedule](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#schedule-syntax) field is required. The value of that field follows the [Cron](https://en.wikipedia.org/wiki/Cron) syntax. |
| cronjob.successfulJobsHistoryLimit | int | 0 | [successfulJobsHistoryLimit](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#jobs-history-limits) field specifies the number of successful finished jobs to keep. Setting this field to 0 will not keep any successful jobs |
| cronjob.suspend | boolean | `false` | [suspend](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#schedule-suspension) field allows to suspend execution of Jobs for a CronJob.  @default -- false. |
| cronjob.timeZone | string | `nil` | [Time zone](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#time-zones) to use when calculating schedule |
| name | string | `nil` | Name of the service that will be deployed on K8s cluster |
| namespace | string | `nil` | Namespace hosting the service that will be deployed on K8s cluster |
| serviceAccount.roleArn | string | `nil` | Optional IAM Role ARN for ServiceAccount annotation eks.amazonaws.com/role-arn (supports templating) |

## 1. CronJob Configuration

### 1.1. Env

#### 1.1.1. <ins>configmap - Reference the CronJob ConfigMap</ins>

To reference a key from the ConfigMap, a key/value pair must be added to the "configmap" block in the CronJob-specific _values.yaml_ file.
The key/value pair must be defined as follows:
* Key: mapped to both the name of the environment variable used by the CronJob and the key defined in the ConfigMap; therefore the two keys coincide;
* Value: the actual value associated with the key defined above

By declaring the "configmap" section in a CronJob's _values.yaml_ file, the following will happen automatically:
* a ConfigMap with the same "name" as the CronJob will be created;
* the "data" field of that ConfigMap will be populated with all the key/value pairs defined in "configmap";
* a reference for each key/value pair defined in the CronJob's ConfigMap will be added to the "env" section of the CronJob definition.

Given the following example configuration in the CronJob _values.yaml_, e.g. "dashboard-metrics-report-generator" for environment "qa":

```
# /jobs/dashboard-metrics-report-generator/qa/values.yaml

configmap:
    ENV_FIELD_KEY: "ENV_FIELD_VALUE"
```

a dedicated ConfigMap containing the specified data will be created:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: "dashboard-metrics-report-generator"
  namespace: "qa"
data:
  ENV_FIELD_KEY: "ENV_FIELD_VALUE"
```

and a reference will be added to the CronJob in the _env_ section:

```
env:
  - name: ENV_FIELD_KEY
    valueFrom:
      configMapKeyRef:
        name: "dashboard-metrics-report-generator"
        key: ENV_FIELD_KEY
```

There is no limit to the number of environment variables configurable in the "configmap" section.

#### 1.1.2. <ins>envFromConfigmaps - Reference an external ConfigMap</ins>

To reference a key from an external ConfigMap, a key/value pair must be added to the "cronjob.envFromConfigmaps" block in the CronJob-specific _values.yaml_ file.
The key/value pair must be defined as follows:
* Key: mapped to the name of the environment variable used by the CronJob
* Value: composed of two values separated by "."; the first value is the name of the referenced external ConfigMap, the second value is the desired key defined in the ConfigMap

Given the following example configuration in the CronJob _values.yaml_, e.g. "dashboard-metrics-report-generator" for environment "qa":

```
# /jobs/dashboard-metrics-report-generator/qa/values.yaml

job:
  envFromConfigmaps:
    CUSTOM_LABEL: "external-configmap-name.REFERENCED_LABEL"
```

a reference will be added to the CronJob in the _env_ section:

```
env:
  - name: CUSTOM_LABEL
    valueFrom:
      configMapKeyRef:
        name: "external-configmap-name"
        key: REFERENCED_LABEL
```

There is no limit to the number of environment variables configurable in the "envFromConfigmaps" section.

#### 1.1.3. <ins>envFromSecrets - Reference an external Secret</ins>

To reference a key from an external Secret, a key/value pair must be added to the "cronjob.envFromSecrets" block in the CronJob-specific _values.yaml_ file.
The key/value pair must be defined as follows:
* Key: mapped to the name of the environment variable used by the CronJob
* Value: composed of two values separated by "."; the first value is the name of the referenced external Secret, the second value is the desired key defined in the Secret

Given the following example configuration in the CronJob _values.yaml_, e.g. "dashboard-metrics-report-generator" for environment "qa":

```
# /jobs/dashboard-metrics-report-generator/qa/values.yaml

job:
  envFromSecrets:
    CUSTOM_LABEL: "external-secret-name.REFERENCED_LABEL"
```

a reference will be added to the CronJob in the _env_ section:

```
- name: CUSTOM_LABEL
  valueFrom:
    secretKeyRef:
        name: "external-secret-name"
        key: REFERENCED_LABEL
```

There is no limit to the number of environment variables configurable in the "envFromSecrets" section.

#### 1.1.4 <ins>env - Define custom environment variables</ins>

To define a custom environment variable for the CronJob, a key/value pair must be added to the "cronjob.env" block in the CronJob-specific _values.yaml_ file.
Given the following example configuration in the CronJob _values.yaml_, e.g. "dashboard-metrics-report-generator" for environment "qa":

```
# /jobs/dashboard-metrics-report-generator/qa/values.yaml

job:
  env:
    ENV_NAME: "ENV_VALUE"
```

a reference will be added to the CronJob in the _env_ section:

```
- env:
  - name: "ENV_NAME"
    value: "ENV_VALUE"
```

There is no limit to the number of environment variables configurable in the "env" section.

#### 1.1.5 <ins>envFromFieldRef - Reference Pod information</ins>

To expose Pod fields at container runtime, you can use the "fieldRef" field, as described in the official Kubernetes [documentation](https://kubernetes.io/docs/concepts/workloads/pods/downward-api/#downwardapi-fieldRef).
A field exposed via "fieldRef" can be referenced in the K8s configuration file of a CronJob, e.g. "dashboard-metrics-report-generator" for environment "qa", by adding the following configuration to the _values.yaml_ file:

```
# /jobs/dashboard-metrics-report-generator/qa/values.yaml

job:
  envFromFieldRef:
    NAMESPACE: "metadata.namespace"
```

This configuration is mapped in the CronJob as follows:

```
env:
 - name: "NAMESPACE"
   valueFrom:
     fieldRef:
       fieldPath: "metadata.namespace"
```

There is no limit to the number of environment variables configurable in the "envFromFieldRef" section.

### 1.2 Volumes

The following describes the configurations to add to the CronJob _values.yaml_ file to add one or more volumes and volumeMounts.

**Volumes**
Following the official Kubernetes documentation on [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/), to add a volume the _values.yaml_ file of the CronJob to be configured must be updated, e.g. "dashboard-metrics-report-generator" for environment "qa", using the following syntax:

```
# /jobs/dashboard-metrics-report-generator/qa/values.yaml

job:
  volumes:
    - name: categories-index-volume
      emptyDir: {}
```

The "volumes" field can contain the definition of one or more objects.

**Volume Mounts**
To add a volumeMount for a configured volume, the CronJob _values.yaml_ file must be updated, e.g. "dashboard-metrics-report-generator" for environment "qa", using the following syntax:

```
# /jobs/dashboard-metrics-report-generator/qa/values.yaml

job:
  volumeMounts:
    - name: categories-index-volume
      mountPath: /opt/docker/index/categories
```

The "volumeMounts" field can contain the definition of one or more objects.

---

## 2. FlywayInitContainer Configuration

The `flywayInitContainer` is an optional init container that runs database migrations via [Flyway](https://flywaydb.org/) before the main container starts.

To enable it, set `cronjob.flywayInitContainer.create: true` and configure at least `cronjob.flywayInitContainer.image.repositoryName`.

### 2.1 Image

The Flyway container image is built from the following fields:

| Field | Default behaviour |
|-------|-------------------|
| `image.repositoryPrefix` | If not set, defaults to `cronjob.image.repositoryPrefix` |
| `image.repositoryName` | **Required** when `create` is `true` |
| `image.tag` | If not set, defaults to `cronjob.image.tag` |
| `image.digest` | If set, overrides `image.tag` |

Example:

```yaml
cronjob:
  flywayInitContainer:
    create: true
    image:
      repositoryName: "interop-flyway-migrations"
      tag: "1.2.3"
```

### 2.2 Flyway Actions

You can control which Flyway commands are executed via the `executeFlywayMigrate` and `executeFlywayRepair` flags.

| Configuration | Executed action |
|---------------|-----------------|
| `executeFlywayMigrate: true`, `executeFlywayRepair: false` | `migrate` |
| `executeFlywayMigrate: false`, `executeFlywayRepair: true` | `repair` |
| `executeFlywayMigrate: true`, `executeFlywayRepair: true` | `repair` followed by `migrate` |
| both `false` | **Error** — at least one action must be enabled |

### 2.3 Migration Paths

There are two mutually exclusive ways to provide SQL migration files:

#### 2.3.1 migrationPaths

Allows you to specify a comma-separated list of paths (files or directories):

```yaml
cronjob:
  flywayInitContainer:
    migrationPaths: "/migrations/a_directory,v1_migration.sql,/migrations/b_directory"
```

The value is passed to the container as the `INTERNAL_FLYWAY_MIGRATIONS_PATHS` environment variable.

#### 2.3.2 migrationsConfigmap

Allows you to mount a ConfigMap containing migration files into the `/flyway/sql` directory:

```yaml
cronjob:
  flywayInitContainer:
    migrationsConfigmap: "my-migrations-configmap"
```

> **Note:** `migrationPaths` and `migrationsConfigmap` cannot be defined at the same time.

### 2.4 Resources

If not set, the Flyway container uses the same resources defined in `cronjob.resources`. They can be overridden by specifying:

```yaml
cronjob:
  flywayInitContainer:
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
      limits:
        cpu: "200m"
        memory: "256Mi"
```

### 2.5 Environment Variables

The `flywayInitContainer` supports the same environment variable configuration modes as the main container:

- `env` — direct values
- `envFromConfigmaps` — references to keys from external ConfigMaps
- `envFromSecrets` — references to keys from external Secrets
- `envFromFieldRef` — Pod fields (downward API)

Refer to sections [1.1.2](#112-envfromconfigmaps---reference-an-external-configmap), [1.1.3](#113-envfromsecrets---reference-an-external-secret), [1.1.4](#114-env---define-custom-environment-variables) and [1.1.5](#115-envfromfieldref---reference-pod-information) for the syntax.

---

## 3. ServiceAccount Configuration

You can optionally set `serviceAccount.roleArn` to add the `eks.amazonaws.com/role-arn` annotation to the generated ServiceAccount.

When `serviceAccount.roleArn` is not set (or empty), no annotation is added.

Example:

```yaml
serviceAccount:
  roleArn: "arn:aws:iam::123456789012:role/my-irsa-role"
```

The resulting ServiceAccount metadata includes:

```yaml
annotations:
  eks.amazonaws.com/role-arn: "arn:aws:iam::123456789012:role/my-irsa-role"
```

