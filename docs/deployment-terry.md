# Deployment: Running Your Application

How to package and deploy applications using containers and cloud platforms.

**Note**: This template doesn't include an application - these are patterns you can use with your own code.

## What is Deployment?

"Deployment" means getting your application running on a server so other people can use it. This guide covers modern deployment using containers.

## Understanding Containers

### What's a Container?

Think of a container like a shipping container for software:
- Packages your application with everything it needs
- Works the same on any computer
- Isolated from other applications
- Easy to move between computers

**Traditional Deployment** (old way):
```
Your Computer → Install dependencies → Copy code → Configure → Hope it works
```

**Container Deployment** (modern way):
```
Your Computer → Build container → Run anywhere → It just works
```

## Creating a Container

### The Dockerfile

A Dockerfile is a recipe for building your container.

```dockerfile
# Start with Python already installed
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install your application's dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your application code
COPY ./src /app/src

# Tell the container how to start your app
CMD ["python", "-m", "src.main"]
```

**What Each Line Means**:
- `FROM python:3.11-slim` - Start with a minimal Python 3.11 environment
- `WORKDIR /app` - All commands run in the `/app` folder
- `COPY requirements.txt .` - Copy your dependency list into the container
- `RUN pip install ...` - Install dependencies
- `COPY ./src /app/src` - Copy your application code
- `CMD [...]` - Command to run when container starts

### Building the Container

```bash
podman build -t myapp:latest .
```

**What Just Happened?**
- `podman build` read your Dockerfile and created a container image
- `-t myapp:latest` named it "myapp" with tag "latest"
- `.` means "look for Dockerfile in current folder"

This takes a few minutes the first time as it downloads and installs everything.

## Running Your Container

### Local Testing

```bash
podman run -p 8080:8080 myapp:latest
```

**What This Does**:
- `podman run` starts the container
- `-p 8080:8080` maps port 8080 on your computer to port 8080 in the container
- `myapp:latest` specifies which container to run

Your application is now running! Open `http://localhost:8080` in your browser.

**What Just Happened?**
The container is like a mini computer running inside your computer. The `-p` flag creates a "tunnel" so you can access it.

### Adding Environment Variables

```bash
podman run -p 8080:8080 \
  -e DATABASE_URL=postgresql://localhost/db \
  -e API_KEY=your_api_key_here \
  myapp:latest
```

**What Just Happened?**
`-e` sets environment variables inside the container. Your application can read these to configure itself.

**IMPORTANT**: Never put real API keys in commands! Use a `.env` file (git-ignored) for local development.

### Running in the Background

```bash
podman run -d \
  --name myapp \
  -p 8080:8080 \
  --restart unless-stopped \
  myapp:latest
```

**New Flags**:
- `-d` - "Detached" mode (runs in background)
- `--name myapp` - Give it a friendly name
- `--restart unless-stopped` - Automatically restart if it crashes

**What Just Happened?**
The container now runs in the background. You can close your terminal and it keeps running.

**Useful Commands**:
```bash
# See running containers
podman ps

# See container logs
podman logs myapp

# Stop the container
podman stop myapp

# Remove the container
podman rm myapp
```

## Deploying to Kubernetes

Kubernetes (K8s) is a system for running many containers across many servers.

### Why Kubernetes?

**Problem**: Running one container on one server is easy. But what about:
- Running 100 containers?
- Automatically restarting crashed containers?
- Load balancing traffic across containers?
- Rolling updates without downtime?

**Solution**: Kubernetes manages all of this automatically.

### Deployment Configuration

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3  # Run 3 copies
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
```

**What This Means**:
- `replicas: 3` - Run 3 copies of your application
- `image: myapp:latest` - Which container to run
- `containerPort: 8080` - Your app listens on port 8080

**What Just Happened?**
This YAML file tells Kubernetes "keep 3 copies of myapp running at all times". If one crashes, Kubernetes automatically starts a replacement.

### Making it Accessible

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
    port: 80      # External port (what users connect to)
    targetPort: 8080  # Container port (where your app listens)
  type: LoadBalancer
```

**What Just Happened?**
This creates a load balancer that distributes traffic across your 3 containers. Users connect to port 80, Kubernetes routes it to one of the containers on port 8080.

## Automated Deployment

### GitHub Actions Deployment

This workflow automatically deploys when you push to the main branch:

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      # Download code
      - uses: actions/checkout@v4

      # Build container
      - name: Build container
        run: podman build -t myapp:${{ github.sha }} .

      # Push to container registry
      - name: Push to registry
        run: |
          podman push registry.example.com/myapp:latest

      # Update Kubernetes
      - name: Deploy
        run: |
          kubectl set image deployment/myapp myapp=registry.example.com/myapp:latest
```

**What Just Happened?**
Every time you push code to the main branch, GitHub:
1. Builds a new container
2. Uploads it to your container registry
3. Tells Kubernetes to use the new version
4. Kubernetes gradually replaces old containers with new ones

## Managing Secrets

**NEVER put passwords or API keys in your code or containers!**

### Development (Local)

Create a `.env` file (add to `.gitignore`):
```
DATABASE_URL=postgresql://localhost/dev_db
API_KEY=dev_key_12345
```

Load in your application:
```python
import os
from dotenv import load_dotenv

load_dotenv()

database_url = os.getenv('DATABASE_URL')
api_key = os.getenv('API_KEY')
```

**What Just Happened?**
`.env` file stores secrets locally but never gets committed to git. Your application loads them at startup.

### Production (Kubernetes)

Create a Kubernetes Secret:
```bash
kubectl create secret generic db-credentials \
  --from-literal=url=postgresql://prod-server/db \
  --from-literal=password=super_secret_password
```

Reference in your deployment:
```yaml
env:
- name: DATABASE_URL
  valueFrom:
    secretKeyRef:
      name: db-credentials
      key: url
```

**What Just Happened?**
Kubernetes stores secrets encrypted and injects them into containers as environment variables. The secrets never appear in your code or container images.

## Monitoring Your Application

### Health Checks

Kubernetes needs to know if your application is working:

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10
```

**What This Does**:
- Every 10 seconds, Kubernetes requests `http://your-app:8080/health`
- If it fails 3 times in a row, Kubernetes restarts the container
- `initialDelaySeconds: 30` waits 30 seconds before starting checks (gives app time to start)

**What Just Happened?**
Kubernetes monitors your application and automatically restarts it if it's not responding. No manual intervention needed!

### Viewing Logs

```bash
# View logs from all copies of your app
kubectl logs -l app=myapp --tail=100

# Follow logs in real-time
kubectl logs -l app=myapp -f

# View logs from a specific container
kubectl logs myapp-deployment-abc123
```

## Scaling

### Manual Scaling

```bash
# Scale to 5 copies
kubectl scale deployment myapp --replicas=5

# Check status
kubectl get pods
```

**What Just Happened?**
Kubernetes created 2 more copies of your application (you had 3, now have 5). The load balancer automatically includes the new copies.

### Automatic Scaling

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: myapp-hpa
spec:
  scaleTargetRef:
    kind: Deployment
    name: myapp
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        averageUtilization: 70
```

**What This Does**:
- Keep at least 2 copies running
- Scale up to 10 copies if needed
- Add copies when CPU usage exceeds 70%
- Remove copies when load decreases

**What Just Happened?**
Kubernetes monitors CPU usage and automatically adds/removes containers to handle traffic. No manual intervention needed!

## Rolling Back

### Undo a Deployment

```bash
# See deployment history
kubectl rollout history deployment/myapp

# Rollback to previous version
kubectl rollout undo deployment/myapp
```

**What Just Happened?**
If the new version has problems, this reverts to the previous working version. Kubernetes gradually replaces the bad containers with the old ones.

## Common Problems

**Problem**: "Container won't start"
**Solutions**:
- Check logs: `podman logs <container-name>`
- Check if ports conflict: `podman ps` to see what's running
- Verify Dockerfile syntax

**Problem**: "Can't connect to application"
**Solutions**:
- Check port mapping is correct: `-p 8080:8080`
- Verify application is listening on all interfaces (0.0.0.0, not just localhost)
- Check firewall rules

**Problem**: "Environment variables not working"
**Solutions**:
- Double-check `-e` flag syntax
- Verify application is reading the right variable names
- Check for typos in variable names

**Problem**: "Kubernetes pods keep restarting"
**Solutions**:
- Check pod logs: `kubectl logs <pod-name>`
- Check health check endpoints are working
- Increase `initialDelaySeconds` if app takes time to start

## Best Practices

1. **Use specific version tags**, not `latest`:
   ```bash
   podman build -t myapp:v1.2.3 .
   ```

2. **Scan containers for vulnerabilities**:
   ```bash
   trivy image myapp:latest
   ```

3. **Run containers as non-root user** (more secure)

4. **Keep containers small** (faster to build and deploy)

5. **Use multi-stage builds** to reduce final image size

## Learn More

- [Podman Basics](https://docs.podman.io/en/latest/Introduction.html)
- [Kubernetes Tutorial](https://kubernetes.io/docs/tutorials/)
- [12-Factor App](https://12factor.net/) - Best practices for cloud applications
- [Container Security](https://owasp.org/www-project-docker-top-10/)

---

**Next**: Check out [Development](development-terry.md) to learn the local development workflow.
