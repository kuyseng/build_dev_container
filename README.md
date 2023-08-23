### Build with multiple arch
```bash
docker buildx build --push --platform linux/arm64,linux/amd64 --tag kuyseng/ubuntu:18.04 .
# build for local use
docker build -t kuyseng/ubuntu .
```
