#!/bin/bash

# Загрузка переменных из файла .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "Файл .env не найден"
  exit 1
fi

# Имя контейнера с MongoDB (замените на ваше)
MONGO_CONTAINER_NAME="parser-mongodb-1"

echo "Подключение к MongoDB в контейнере $MONGO_CONTAINER_NAME"
echo "База данных: $MONGO_DB"
echo "Коллекция: mail_quotes"

# Сначала выведем записи, которые будут удалены
echo "Записи, которые будут удалены (condition: AR, GR, AS, UN):"
sudo docker exec -it $MONGO_CONTAINER_NAME mongosh $MONGODB_URL --eval 'db.mail_quotes.find({condition: {$in: ["AR", "GR", "AS", "UN"]}}).forEach(printjson)'

# Запрос пользователю на подтверждение удаления
read -p "Вы уверены, что хотите удалить эти записи? (y/n): " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
  # Выполнение запроса на удаление записей с condition равным AR, GR, AS или UN
  sudo docker exec -it $MONGO_CONTAINER_NAME mongosh $MONGODB_URL --eval 'db.mail_quotes.deleteMany({condition: {$in: ["AR", "GR", "AS", "UN"]}})'
  echo "Удаление записей выполнено."
else
  echo "Операция удаления отменена."
fi
