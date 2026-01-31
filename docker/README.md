# Ansible学習用Docker環境

## コンテナ構成

| コンテナ | IP | ポート | 用途 |
|---------|-----|-------|------|
| bastion | 172.20.0.10 | 2222→22 | 踏み台サーバー |
| webserver | 172.20.0.20 | 2223→22, 8080→8080 | Webサーバー |

両コンテナともUbuntu 22.04ベースで、SSH接続可能。

## start-containers.sh の処理内容

1. SSH鍵ペア（ed25519）を `ssh_keys/` に生成
2. `docker compose up -d --build` でコンテナを起動
3. 公開鍵を各コンテナの `/home/ansible/.ssh/authorized_keys` にコピー

## SSH接続手順

### ローカル → 踏み台

```bash
ssh -i ssh_keys/ansible_key -p 2222 ansible@localhost
```

### 踏み台 → Webサーバー

踏み台にログイン後：

```bash
ssh ansible@172.20.0.20
# パスワード: ansible
```

### ローカル → 踏み台 → Webサーバー（ProxyJump）

```bash
ssh -i ssh_keys/ansible_key \
    -o ProxyCommand="ssh -i ssh_keys/ansible_key -p 2222 -W %h:%p ansible@localhost" \
    ansible@172.20.0.20
```

## 停止

```bash
docker compose down
```
