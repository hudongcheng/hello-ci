## 制作 Docker 镜像

### 下载镜像

```sh
$ docker pull i386/ubuntu:16.04   # 32 位 Ubuntu：
$ docker pull ubuntu:16.04        # 64 位 Ubuntu：
```

### 运行 docker

以 64 位 Ubuntu 为例，交互模式 [`-i`] 运行 `/bin/bash` 命令：
```sh
$ docker run -i -t ubuntu:16.04 /bin/bash
```

### 安装依赖

```sh
$ apt-get update
$ apt-get install -y -qq libcups2-dev libcupsimage2-dev libsane-dev
```
系统同时会自动安装上 `gcc`、`make` 和 `libjpeg`。

### 制作 Docker 镜像

```sh
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
4fe44228cac3        ubuntu:16.04        "/bin/bash"         13 minutes ago      Up 13 minutes                           serene_leakey

$ docker commit 4fe44228cac3 pantum-ubuntu
sha256:c7ee36ad67513f19233c67bd44da3162122e0d92473cc2ce1b39ff3f3fb2d474
```

### 配置 Gitlab CI

在项目根目录创建 `.gitlab-ci.yml`，添加如下内容：
```sh
image: pantum-ubuntu

stages:
  - build
  - test

build:
  stage: build
  script:
    - make
  artifacts:
    paths:
    - hello-ci


test:app:
  script:
  - echo "test app"
```

## gitlab-runner

### /etc/gitlab-runner/config.toml

```
concurrent = 1
check_interval = 0

[[runners]]
  name = "test gitlab ci"
  url = "http://git.pantum.com/ci"
  token = "e7f8f158fb83ecb3c8b664fdbb3335"
  executor = "docker"
  [runners.docker]
    extra_hosts = ["git.pantum.com:10.10.140.200"]
    tls_verify = false
    image = "centos"
    privileged = false
    disable_cache = false
    volumes = ["/cache"]
    [runners.cache]
      Insecure = false
```

因为 `git.pamtum.com` 没有在 `DNS` 记录，所以需要增加 `extra_hosts = ["git.pantum.com:10.10.140.200"]`。
