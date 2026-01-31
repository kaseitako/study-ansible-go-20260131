# Ansible学習用Docker環境

## コンテナ構成

| コンテナ | IP | ポート | 用途 |
|---------|-----|-------|------|
| bastion | 172.20.0.10 | 2222→22 | 踏み台サーバー |
| webserver | 172.20.0.20 | 2223→22, 8080→8080 | Webサーバー |

両コンテナともUbuntu 22.04ベースで、SSH接続可能。

`./docker/start-containers.sh` を実行することで、これらのコンテナを起動できる。

## start-containers.sh の処理内容

1. SSH鍵ペア（ed25519）を `ssh_keys/` に生成
2. `docker compose up -d --build` でコンテナを起動
3. 公開鍵を各コンテナの `/home/ansible/.ssh/authorized_keys` にコピー

## SSH接続手順

### 事前準備（Agent Forwarding用）

踏み台経由でWebサーバーに接続する場合、事前にssh-agentに秘密鍵を登録しておく：

```bash
ssh-add ssh_keys/ansible_key
```

### ローカル → 踏み台

```bash
ssh -A -i ssh_keys/ansible_key -p 2222 ansible@localhost
```

`-A` オプションでAgent Forwardingを有効化。

### 踏み台 → Webサーバー

踏み台にログイン後：

```bash
ssh ansible@172.20.0.20
```

Agent Forwardingにより、ローカルの鍵が使われるためパスワード不要。

**注意**: パスワードを聞かれる場合は、`ssh-add` で鍵を登録しているか確認すること。

### ローカル → 踏み台 → Webサーバー（直接）

```bash
ssh -i ssh_keys/ansible_key -J ansible@localhost:2222 ansible@172.20.0.20
```

`-J` オプション（ProxyJump）で踏み台を経由して直接接続。

## 停止

```bash
docker compose down
```
