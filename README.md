# study-ansible-go

Ansible学習用のGoアプリケーション + Docker環境

## Goアプリケーション

### 開発時の起動

```bash
go run main.go
```

サーバーが起動し、http://localhost:8080 でアクセス可能になります。

### バイナリのビルド

```bash
# 現在の環境向け
go build -o app main.go

# Linux向け（Dockerコンテナ用）
GOOS=linux GOARCH=amd64 go build -o app main.go
```

### 動作確認

```bash
curl http://localhost:8080
# => Hello, World!
```

## Docker環境

踏み台サーバー（bastion）経由でWebサーバー（webserver）に接続する構成です。

詳細は [docker/README.md](docker/README.md) を参照してください。

### 起動

```bash
./docker/start-containers.sh
```

### 停止

```bash
docker compose down
```

## Ansible

`ansible/` ディレクトリにサンプルplaybookがあります。

### バイナリのデプロイ

```bash
# 1. Linux向けバイナリをビルド
GOOS=linux GOARCH=amd64 go build -o app main.go

# 2. Ansibleでデプロイ
cd ansible
ansible-playbook -i inventory.ini deploy.yml
```
