# LayNet(Network Layout)
Сейчас это простой сетевой, пока что он просто выводить информацию которую возвращает сервер
## Что есть в классе LayNet
- Поле **url**, в котором хранится ссылка по которой производится запрос к серверу
- Конструктор, в котором для создания экземпляра требуется передать **url**-адрес сервера
- Перечисление **TypeRequest**, используется для указания, какого типа будет запрос(GET, POST, PUT, DELETE)
- Метод **sendRequest**, используется для осуществления запроса к серверу
# Как это работает
## Конструктор класса
```Swift
init(url: String) {
    self.url = url
}
```
## Типы запросов
```Swift
enum TypeRequest: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
}
```
## Метод запроса
```Swift
public func sendRequest(
    typeRequest reqType: TypeRequest, 
    withBody body: [String: Any]? = nil, 
    withParametrs parametrs: [String: String]? = nil, 
    httpHeader header: [String: String]? = nil) -> [String: Any]
```
## Создание экземпляра класса
Ссылки для запросов используются с сайта [JSONPlaceholder](https://jsonplaceholder.typicode.com/guide/) 
```Swift
var laynet = LayNet(url: "https://jsonplaceholder.typicode.com/posts")
```
При создании мы просто передаём ссылку запроса и всё, экземпляр класса **готов**
## Как сделать запрос к серверу
### Get-запрос
Для выполнения запроса к серверу используется метод [[#Метод запроса|sendRequest]]
```Swift
var laynet = LayNet(url: "https://jsonplaceholder.typicode.com/posts")
laynet.sendRequest(typeRequest: LayNet.TypeRequest.get)
```
После выполнения этого кода в терминале вы увидите собранную **url**, метод, переданные body и параметры, статус код выполнения запроса
### Работа с body и parametrs
Для некоторых запросов, таких как POST, требуется указать какие-то данные в тело запроса(body) или в его параметры(params), или вообще и туда и туда. Если не передавать данные параметры в функцию они принимают значение по умолчанию **nil**. Так же иногда требуется настроить header запроса, эти данные тоже принимает функция
- body принимает значения типа: **[String: Any]**
- params принимает значения типа: **[String: String]**
- header принимает значение типа: **[String: String]**
### Пример использования params, body, header
- body, header
```Swift
let data: [String: Any] = [
    "id": 104,
    "title": "foofddasfda",
    "body": "baasdfasdfr",
    "userId": 12
]

let header: [String: String] = [
    "application/json" : "Content-Type"
]

var laynet = LayNet(url: "https://jsonplaceholder.typicode.com/posts")
laynet.sendRequest(typeRequest: LayNet.TypeRequest.post, withBody: data, httpHeader: header)
```
Результат выполнения кода:
```Console
URL for request: https://jsonplaceholder.typicode.com/posts, method: POST, data: Optional(65 bytes), params: nil, header: Optional(["application/json": "Content-Type"])
Status code: 201
Result -> {
    body = baasdfasdfr;
    id = 101;
    title = foofddasfda;
    userId = 12;
}
```
- params
```Swift
let header: [String: String] = [
    "application/json" : "Content-Type"
]
  
let param: [String: String] = [
    "id" : "1"
]

var laynet = LayNet(url: "https://jsonplaceholder.typicode.com/posts")
laynet.sendRequest(typeRequest: LayNet.TypeRequest.get, withParams: param, httpHeader: header)
```
Результат выполнения кода:
```Console
URL for request: https://jsonplaceholder.typicode.com/posts?id=1&, method: GET, data: nil, params: Optional(["id": "1"]), header: Optional(["application/json": "Content-Type"])
Status code: 200
Result -> (
        {
        body = "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto";
        id = 1;
        title = "sunt aut facere repellat provident occaecati excepturi optio reprehenderit";
        userId = 1;
    }
)
```
# Будущие доработки
Требуется немного переделать передачу параметров, так как некоторые запросы, такие как put и delete могут по разному принимать параметры пути, и для этого требуется немного другой url. Так же до сих пор метод sendRequest никаких значений не возвращает а просто выводит их в терминал. 
