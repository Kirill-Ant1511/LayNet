//
//  LayNet.swift
//  LayNet
//
//  Created by Кирилл Антоненко on 26.05.2025.
//

import Foundation


class LayNet {
    enum TypeRequest: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    var url: String
    init(url: String) {
        self.url = url
    }
    
    // Метод отправки запроса
    public func sendRequest(typeRequest reqType: TypeRequest, withBody body: [String: Any]? = nil, withParams param: [String: String]? = nil, httpHeader header: [String: String]? = nil, completion: @escaping (Result<Data, Error>) -> Any) {
        var url = self.url
        if let param = param {
            url += "?"
            for (key, value) in param {
                url += "\(key)=\(value)&"
            }
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = reqType.rawValue
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        if let header = header {
            for (key, value) in header {
                request.setValue(key, forHTTPHeaderField: value)
            }
        }
        print("URL for request: \(url), method: \(request.httpMethod!), data: \(String(describing: request.httpBody ?? nil)), params: \(String(describing: param ?? nil)), header: \(String(describing: header ?? nil))")
        URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                completion(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse {
                print("Status code: \(response.statusCode)")
            }

        
            if let data = data {
                completion(.success(data))
            } else {
                print("[ERROR] No data")
            }
        
        }.resume()
    }
}

let header: [String: String] = [
    "application/json" : "Content-Type"
]

var laynet = LayNet(url: "https://jsonplaceholder.typicode.com/posts/1")
laynet.sendRequest(typeRequest: .get, httpHeader: header) { res in
    switch res {
    case .failure(let error):
        print(error.localizedDescription)
    case .success(var data):
        guard let data = try? JSONSerialization.jsonObject(with: data) else { return }
        print(data)
    }
    return "empty"
}

