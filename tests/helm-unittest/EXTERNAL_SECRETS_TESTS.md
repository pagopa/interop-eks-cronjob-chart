# Helm Unittest - External Secrets Refactor

## Test Coverage

Sono stati aggiunti test completi per validare la nuova struttura degli external secrets separati per container app e flyway init container.

### Test Suite by Component

#### 1. External Secret - App Container
**File Test**: `tests/helm-unittest/external-secret/external_secret_test.yaml`
**Template**: `templates/externalSecret.yaml`

Test cases:
- ✅ Does not render when app.create is disabled
- ✅ Renders ExternalSecret with correct app configuration
- ✅ Uses correct secretStoreRef and targetSecret
- ✅ Properly references data array from app config
- ✅ Handles remoteRef.property omission

#### 2. External Secret - Flyway Init Container
**File Test**: `tests/helm-unittest/external-secret/external-secret-flyway_test.yaml`
**Template**: `templates/externalSecret.flyway.yaml`

Test cases:
- ✅ Does not render when flywayInitContainer.create is disabled
- ✅ Renders ExternalSecret with "-flyway" naming convention
- ✅ Uses correct secretStoreRef and targetSecret
- ✅ Supports custom targetSecret name override
- ✅ Properly references data array from flywayInitContainer config

#### 3. Secret Resource - App Container
**File Test**: `tests/helm-unittest/external-secret/secret_test.yaml`
**Template**: `templates/secret.yaml`

Test cases:
- ✅ Does not render when app.create is disabled
- ✅ Renders Secret with correct metadata
- ✅ Uses correct namespace and labels
- ✅ Supports custom targetSecret name override

#### 4. Secret Resource - Flyway Init Container
**File Test**: `tests/helm-unittest/external-secret/secret-flyway_test.yaml`
**Template**: `templates/secret.flyway.yaml`

Test cases:
- ✅ Does not render when flywayInitContainer.create is disabled
- ✅ Renders Secret with "-flyway" naming convention
- ✅ Uses correct namespace and labels
- ✅ Supports custom targetSecret name override

#### 5. CronJob - Container Environment Variables
**File Test**: `tests/helm-unittest/cronjob/cronjob_env_test.yaml`
**Template**: `templates/cronjob.yaml`

Test cases:
- ✅ Does not render envFrom when external secrets disabled (app)
- ✅ Renders envFrom for app container when external secrets enabled
- ✅ Uses correct secret name reference for app container
- ✅ Supports custom secret name for app container
- ✅ Does not render envFrom when external secrets disabled (flyway)
- ✅ Renders envFrom for flyway init container when external secrets enabled
- ✅ Uses correct secret name reference for flyway container ("-flyway" suffix)
- ✅ Supports custom secret name for flyway container
- ✅ Renders envFrom for both containers simultaneously

## Running Tests

### Prerequisites
```bash
helm plugin install https://github.com/helm-unittest/helm-unittest
```

### Run All Tests
```bash
helm unittest charts/interop-eks-cronjob-chart
```

### Run Specific Test Suite
```bash
helm unittest -t tests/helm-unittest/external-secret/external_secret_test.yaml charts/interop-eks-cronjob-chart
helm unittest -t tests/helm-unittest/external-secret/external-secret-flyway_test.yaml charts/interop-eks-cronjob-chart
helm unittest -t tests/helm-unittest/external-secret/secret_test.yaml charts/interop-eks-cronjob-chart
helm unittest -t tests/helm-unittest/external-secret/secret-flyway_test.yaml charts/interop-eks-cronjob-chart
helm unittest -t tests/helm-unittest/cronjob/cronjob_env_test.yaml charts/interop-eks-cronjob-chart
```

### Run with Verbose Output
```bash
helm unittest -v charts/interop-eks-cronjob-chart
```

### Run with Coverage Report
```bash
helm unittest --update-snapshot charts/interop-eks-cronjob-chart
```

## Test Data Files

### External Secrets Test Values
Located in `tests/helm-unittest/external-secret/`:
- `external-secret.yaml` - App external secret with default naming
- `external-secret-no-property.yaml` - App external secret without remoteRef.property
- `external-secret-flyway.yaml` - Flyway external secret with default naming
- `external-secret-flyway-custom.yaml` - Flyway external secret with custom name

### Secret Resource Test Values
Located in `tests/helm-unittest/external-secret/`:
- `secret.yaml` - App secret with default naming
- `secret-custom.yaml` - App secret with custom name
- `secret-flyway.yaml` - Flyway secret with default naming
- `secret-flyway-custom.yaml` - Flyway secret with custom name

### CronJob Test Values
Located in `tests/helm-unittest/cronjob/`:
- `cronjob-external-secrets-app.yaml` - App external secrets enabled
- `cronjob-external-secrets-app-custom.yaml` - App with custom secret name
- `cronjob-external-secrets-flyway.yaml` - Flyway external secrets enabled
- `cronjob-external-secrets-flyway-custom.yaml` - Flyway with custom secret name
- `cronjob-external-secrets-both.yaml` - Both app and flyway enabled

## Base Configuration
The common base configuration used by all tests is in `tests/helm-unittest/common/base.yaml` and includes:
- Default namespace and name
- CronJob schedule and image settings
- Flyway init container disabled by default
- External secrets disabled by default (both app and flyway)

## Notes

- All tests follow helm-unittest conventions and patterns
- Test assertions use path navigation (JSONPath style) to verify rendered resources
- Custom secret name handling is tested to ensure template flexibility
- Naming conventions are validated (default "-flyway" suffix for flyway container)
- Tests ensure both containers can have external secrets independently
