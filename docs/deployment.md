# Deployment

Containerization patterns and deployment strategies for template adoption.

**Note**: This template contains no application code. Patterns shown are for documentation purposes.

## Container Patterns

### Podman Build

```dockerfile
# Dockerfile example
FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application (bring your own)
COPY ./src /app/src

# Run
CMD ["python", "-m", "src.main"]
```

Build:
```bash
podman build -t myapp:latest .
```

### Running Containers

Local development:
```bash
podman run -p 8080:8080 \
  -e DATABASE_URL=postgresql://localhost/db \
  -v $(pwd)/config:/app/config:ro \
  myapp:latest
```

Production:
```bash
podman run -d \
  --name myapp \
  -p 8080:8080 \
  --restart unless-stopped \
  -e DATABASE_URL=$DATABASE_URL \
  myapp:latest
```

## Kubernetes Patterns

### Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myapp:latest
        ports:
        - containerPort: 8080
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: url
```

### Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  selector:
    app: myapp
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
  type: LoadBalancer
```

## CI/CD Integration

### GitHub Actions Deployment

```yaml
name: Deploy

on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build container
        run: podman build -t myapp:${{ github.sha }} .

      - name: Push to registry
        run: |
          echo "${{ secrets.REGISTRY_TOKEN }}" | \
            podman login -u ${{ secrets.REGISTRY_USER }} --password-stdin registry.example.com
          podman tag myapp:${{ github.sha }} registry.example.com/myapp:latest
          podman push registry.example.com/myapp:latest

      - name: Deploy to Kubernetes
        run: |
          kubectl set image deployment/myapp myapp=registry.example.com/myapp:latest
          kubectl rollout status deployment/myapp
```

## Environment Configuration

### Secrets Management

Never commit secrets. Use environment variables or secret management tools.

**Development**:
```bash
# .env (git-ignored)
DATABASE_URL=postgresql://localhost/dev_db
API_KEY=dev_key_12345
```

**Production**:
- Kubernetes Secrets
- HashiCorp Vault
- Cloud provider secret managers (AWS Secrets Manager, Azure Key Vault)

### Configuration Files

```yaml
# config/production.yaml
database:
  pool_size: 20
  timeout: 30

logging:
  level: INFO
  format: json

cache:
  ttl: 3600
```

Load via environment:
```python
import os
import yaml

env = os.getenv('ENVIRONMENT', 'development')
with open(f'config/{env}.yaml') as f:
    config = yaml.safe_load(f)
```

## Health Checks

### Liveness Probe

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10
```

### Readiness Probe

```yaml
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```

## Scaling Strategies

### Horizontal Pod Autoscaler

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: myapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

## Rollback Strategy

### Kubernetes Rollback

```bash
# Check rollout status
kubectl rollout status deployment/myapp

# View rollout history
kubectl rollout history deployment/myapp

# Rollback to previous version
kubectl rollout undo deployment/myapp

# Rollback to specific revision
kubectl rollout undo deployment/myapp --to-revision=3
```

### Blue-Green Deployment

```yaml
# Blue deployment (current)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-blue
spec:
  replicas: 3
  # ... (same as above)

---
# Green deployment (new version)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-green
spec:
  replicas: 3
  # ... (new version)

---
# Service switches between blue and green
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  selector:
    app: myapp
    version: blue  # Change to 'green' to switch
```

## Monitoring

### Prometheus Metrics

```python
from prometheus_client import Counter, Histogram

request_count = Counter('http_requests_total', 'Total HTTP requests', ['method', 'endpoint'])
request_duration = Histogram('http_request_duration_seconds', 'HTTP request duration')

@app.middleware("http")
async def metrics_middleware(request, call_next):
    with request_duration.time():
        response = await call_next(request)
    request_count.labels(method=request.method, endpoint=request.url.path).inc()
    return response
```

### Logging

```python
import logging
import json

class JSONFormatter(logging.Formatter):
    def format(self, record):
        log_obj = {
            "timestamp": self.formatTime(record),
            "level": record.levelname,
            "message": record.getMessage(),
            "logger": record.name
        }
        return json.dumps(log_obj)

logger = logging.getLogger(__name__)
handler = logging.StreamHandler()
handler.setFormatter(JSONFormatter())
logger.addHandler(handler)
```

## Security Considerations

### Non-Root Containers

```dockerfile
FROM python:3.11-slim

# Create non-root user
RUN useradd -m -u 1000 appuser

WORKDIR /app

# Install as root
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY --chown=appuser:appuser . .

# Switch to non-root user
USER appuser

CMD ["python", "-m", "src.main"]
```

### Image Scanning

```bash
# Scan with Trivy
trivy image myapp:latest

# Scan with Clair
clairctl analyze myapp:latest
```

## References

- [Podman Documentation](https://docs.podman.io/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [12-Factor App](https://12factor.net/)
- [OWASP Container Security](https://owasp.org/www-project-docker-top-10/)
