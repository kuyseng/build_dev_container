### Build with multiple arch
```bash
docker buildx build --push --platform linux/arm64,linux/amd64 --tag kuyseng/ruby:v2.3.1 .
```
