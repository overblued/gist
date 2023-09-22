# mongodb
#########

USERNAME=admin
PASSWORD=admin
CODENAME=$(sed -rn 's/VERSION_CODENAME=(.+)/\1/p' /etc/os-release)
MONGO_VER=7
DB_PATH=/var/lib/mongodb
MONGO_CONF_PATH='/etc/mongod.conf'
MONGO_CONF_TEMPLATE="\
storage:
  dbPath: ${DB_PATH}

net:
  port: 27017
  bindIp: 0.0.0.0

processManagement:
  timeZoneInfo: /usr/share/zoneinfo

security:
  authorization: enabled"

  
check_package() {
  PACKAGE=$1
  if ! dpkg -s $PACKAGE >/dev/null 2>&1; then
    techo "$PACKAGE 没有安装，安装中..."
    sudo apt install -y $PACKAGE
    if [ $? -eq 0 ]; then
      techo "$PACKAGE 安装成功"
    else
      techo "$PACKAGE 安装失败，退出安装程序。"
      exit 1
    fi
  fi
}

# 安装 mongod
if ! dpkg -s mongodb-org >/dev/null 2>&1; then
  echo "MongoDB 安装中..."

  check_package gnupg
  check_package gpg
  check_package curl

  gpg_path="/usr/share/keyrings/mongodb-server-$MONGO_VER.0.gpg"
  if [[ -f $gpg_path ]]; then
    rm "$gpg_path"
  fi

  curl -fsSL https://pgp.mongodb.com/server-$MONGO_VER.0.asc |
    sudo gpg -o "$gpg_path" \
      --dearmor
  echo "deb [ arch=amd64,arm64 signed-by=$gpg_path ] https://repo.mongodb.org/apt/ubuntu $CODENAME/mongodb-org/$MONGO_VER.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-$MONGO_VER.0.list

  apt-get update
  apt-get install -y mongodb-org

  systemctl start mongod

fi

MONGO_SERVICE="mongod"

if ! systemctl is-enabled $MONGO_SERVICE >/dev/null; then
  systemctl enable $MONGO_SERVICE
  if [ $? -eq 0 ]; then
    echo "MongoDB 启用enable成功"
  else
    echo "MongoDB 启用enable失败"
    exit 1
  fi
fi

if ! systemctl is-active --quiet $MONGO_SERVICE; then
  systemctl start $MONGO_SERVICE
  if [ $? -eq 0 ]; then
    echo "MongoDB 启动start成功"
  else
    echo "MongoDB 启动start失败"
    exit 1
  fi
fi


#检查是否启用认证
if cat $MONGO_CONF_PATH | grep "authorization: enabled" >/dev/null; then
  echo "MongoDB 正常"
else
  echo "MongoDB 初始化"
  echo "MongoDB 创建Admin用户..."
  echo "use admin
db.createUser({
  user: '$USERNAME',
  pwd: '$PASSWORD',
  roles: [ { role: 'readWriteAnyDatabase', db: 'admin' },
    { role: 'userAdminAnyDatabase', db: 'admin' } ]
})" | mongosh

  echo "修改mongodb配置文件"
  echo "$MONGO_CONF_TEMPLATE" >$MONGO_CONF_PATH

  echo "重启mongodb服务"
  systemctl restart mongod
  if [ $? -eq 0 ]; then
     echo "MongoDB 重启成功"
  else
     echo "MongoDB 重启失败"
     exit 1
  fi
fi
