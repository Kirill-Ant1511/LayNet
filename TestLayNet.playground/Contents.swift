//
//  LayNet.swift
//  LayNet
//
//  Created by Кирилл Антоненко on 26.05.2025.
//

import Foundation


class LayNet {
    
    // Типы запросов
    enum RequestType: String {
        case get = "GET"
        case post = "POST"
    }
    
    var url: String
    var typeRequest: RequestType
    open var request: URLRequest
    
    init(url: String) {
        self.url = url
        self.typeRequest = .get
        request = URLRequest(url: URL(string: url)!)
    }
    
    init(url: String, typeRequest: RequestType) {
        self.url = url
        self.typeRequest = typeRequest
        self.request = URLRequest(url: URL(string: url)!)
    }
    
    // Метод отправки запроса
    public func sendRequest(withBody body: [String: Any]? = nil) {
        self.request.httpMethod = self.typeRequest.rawValue
        switch self.typeRequest {
            // Обработка GET запроса
        case .get:
            URLSession.shared.dataTask(with: self.request) { data, response, error in
                // Проверка на ошибку
                if let error = error {
                    print("[ERROR] \(error.localizedDescription)")
                    return
                }
    
                // Вывод статус кода запроса
                if let response = response as? HTTPURLResponse {
                    print("Status code: \(response.statusCode)")
                }
                
                // Проверка наличия данных
                guard let data = data else {
                    print("[ERROR] No data")
                    return
                }
            
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print(json)
                } else {
                    print("[ERROR] Not can't decode JSON")
                }
            }.resume()
        case .post:
            
            self.request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let data = body else { return }
            self.request.httpBody = try? JSONSerialization.data(withJSONObject: data)
            URLSession.shared.dataTask(with: self.request) { data, response, error in
                if let error = error {
                    print("[ERROR] \(error.localizedDescription)")
                    return
                }
                if let response = response as? HTTPURLResponse {
                    print("Status code: \(response.statusCode)")
                }
                print(data)
            }.resume()
        }
    }
    
    
}

var data: [String: Any] = [
    "id": 104,
    "title": "foo",
    "body": "bar",
    "userId": 1
]




var laynet = LayNet(url: "https://jsonplaceholder.typicode.com/posts")
laynet.sendRequest()

laynet.typeRequest = .post
laynet.sendRequest(withBody: data)

