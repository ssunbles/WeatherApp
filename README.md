

Привет, это мой небольшой проект - приложение с прогнозом погоды  

## Базовые требования:

- [X] Использовать **Core Data** для хранения моделей данных
- [X] Использовать **UICollectionView**
- [X] Запрос в сеть (реализация сетевого сервиса)
- [X] Количество экранов: **2-3**
- [X] Определение геолокации
- [X] Архитектура MVVM
- [X] Верстка UI в коде

---

## Концепт

![concept](https://github.com/ssunbles/WeatherApp/blob/develop/WeatherApp.png)

Выше показан общий макет приложения с картой экранов. Здесь можно увидеть главный экран с выбором нахождения города для получения погоды на выбор пользователя:
- [X] Через геолокацию
- [X] Внести вручную

Если ранее были выбраны города для просмотра погоды, они обязательно сохраняются в лист поиска городов вручную в коллекцию, это дает возможность выбрать ранее просматриваемый город, данные сохраняются в CoreData : Город, его координаты.

На экране с информацией о погоде в выбранном городе находится текущий прогноз : температура, описание, на сколько градусов ощущается погода, а также влажность и скорость ветра.Снизу показана погода на будущие 5 дней с разницей 3 часа, чтобы можно было определить как себя будет вести погода в течение дня.  

Весь UI был сверстан при помощи кода, без InterfceBuilder-а и Nib-ов   

---

#### Архитектура и шаблоны проектирования

В основу архитектуры приложения лег MVVM. В планах добавить графики и почасовую погоду в лист погоды, а также в Поисковике добавить реализацию автозаполнения городов при вводе букв в SearchTextField.

#### Использование сети

Для получения данных используется сервис [OpenWeather](https://openweathermap.org)  
Описание запросов, используемых в приложении есть в папке [WeatherService.swift](https://github.com/ssunbles/WeatherApp/blob/develop/WeatherApp/Networking/WeatherService.swift), определение текущего местоположения проработал через CoreLocation так, как было желание изучить данную библиотеку.

#### Хранение данных

Для хранения данных о сохраненных городах используется Core Data   

**Core Data** - Весь функционал Core Data вынесен в отдельный класс [CoreDataManager.swift](https://github.com/ssunbles/WeatherApp/blob/develop/WeatherApp/CoreData/CoreDataManager.swift)

---

#### Хочешь сделать вклад в этот проект?

Супер, я с удовольствием принимаю пул реквесты!

