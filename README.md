# flutter_hw_kototinder
Приложение на flutter сделанное в рамках дз по курсу Flutter в МФТИ. \
Автор: Белов Тимофей Николаевич, Б13-303 \
## Описание
В рамках стандартного дз реализовано получение и отображение картинок котов с api thecatapi и использование их в окружении подобном тиндеру. \
Дополнительно была попытка подключить другие api, уже не с котами (с кашачьими характеристиками, насколько хватило терпения искать соответствующий api) а с людьми/антропоморфами. \
Используемые api разграничены и позволяют переключаться между ними. \
Ссылка на build apk (от 08.03.2025) [apk](https://drive.google.com/file/d/1CiQPob3EaEZAezi0zdeDhoT1w6aX8Fbd/view?usp=drive_link)
## Интерфейс
Описание возможностей приложения. \
![Главная страница](/App_navigation_1.png)
1. Логотип
2. Кнопка дизлайков и счетчик дизлайков
3. Кнопка лайков и счетчик лайков
4. Картинка с api (при клике открывается страница детального описания, может быть свайпнута в любую сторону, вправо - лайк, влево - дизлайк, иначе - просто замена, можно вернуть на изначальную позицию и отменить свайп, тип свайпа не может быть изменен после начала)
5. Кнопка изменения светлой и темной темы
6. Кнопки выбора api (не рекомендуется быстро менять)
7. Базовой описание полученное с api

![Страница описания](/App_navigation_2.png)
1. Полное изображение, которое было кликнуто
2. При клике во вне модалка закрывается
3. Полное описание с api (не все поля с thecatapi отображаются, для других api вообще нет поддержки всех полей)
