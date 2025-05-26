# LAYNET
Пока всё хранится в playground проекте, так как пока что не разобрался как проверять работу этого в framework проекте.


## Что это такое(кратко)
Это простой сетевой слой
Класс LayNet:
- Содержит поле с URL, типом запроса(enum RequestType) и сам готовый request запрос
- Метод отправки запроса, в котором просматривается какой запрос(GET, POST. Другие ещё не добавлены)
- Два конструктора
	- Когда передаётся только ссылка, типу запроса присваивается значение get
	- Когда передаётся ссылка на запрос и тип запроса
	- Так же внутри конструкторов создаётся  URLRequest

Метод **sendRequest** принимает в себя body для POST запроса стандартное значение nil(сделано это для get запросов)

Данные в Body передаются в формате похожем на json
```Swift
var data: [String: Any] = [
    "id": 104,
    "title": "foo",
    "body": "bar",
    "userId": 1
]
```

Пока что данный метод не возвращает какие-то данные а просто выводит статус код запроса и данные которые возвращает сервер. 

Сейчас планируется добавить обработку **put** и **delete** запросов. Планируется реализовать поле класса которое будет указывать куда будет передаваться параметр для запроса(в тело запроса или параметр)

# Создание экземпляра класса
Ссылки для запросов используются с сайта [JSONPlaceholder](https://jsonplaceholder.typicode.com/guide/) 
## Конструкторы класса
```Swift

// Данный конструктор используется если требуется отправить get-запрос
init(url: String) {
	self.url = url
	self.typeRequest = .get
	request = URLRequest(url: URL(string: url)!)
}
// Этот конструктор используется для post-запроса
init(url: String, typeRequest: RequestType) {
	self.url = url
	self.typeRequest = typeRequest
	self.request = URLRequest(url: URL(string: url)!)
}
```
## Пример get-запроса
```Swift
var laynet = LayNet(url: "https://jsonplaceholder.typicode.com/posts")
laynet.sendReuest()
```
## Пример post-запроса
```Swift
var data: [String: Any] = [
    "id": 104,
    "title": "foo",
    "body": "bar",
    "userId": 1
]
var laynet = LayNet(url: "https://jsonplaceholder.typicode.com/posts", typeRequest: LayNet.RequestType.post)
laynet.sendReuest(data)
```

# Будущие исправления и доработки
Требуется добавить обработку put-запросов и delete-запросов. Для этого потребуется изменить поля класса что бы **URLRequest** создавался в методе **sendRequest** и там производилась проверка какой это запрос, что бы проверить как будут передаваться данные в put/delete-запросы, так как некоторые put запросы могут иметь могут получать информацию из тела запроса и его параметрам, а также только по параметрам или наоборот. С delete запросами та же история
