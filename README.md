# Использование

./execute.sh backup.sh "Email subject if fail" email.recepient@example.com

## в чем фишка
ставим это в крон. Если backup вываливается с ошибкой получаем email.
Если 2 бэкап запускается до того как первый успел выполниться,то 2 бэкап ждет завершения первого WAIT_TIMEOUT секунд.
Если запускается 3 и далее бэкап до завершения предидущих, он отваливается и посылается уведомление по почте.
Остается только реализовать функцию doBackup под конкретный случай.