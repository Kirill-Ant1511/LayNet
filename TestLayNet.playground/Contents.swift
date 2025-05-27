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
    public func sendRequest(typeRequest reqType: TypeRequest, withBody body: [String: Any]? = nil, withParams param: [String: String]? = nil, httpHeader header: [String: String]? = nil) -> [String: Any] {
        
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
        print("URL for request: \(url), method: \(request.httpMethod!), data: \(request.httpBody ?? nil), params: \(param ?? nil), header: \(header ?? nil)")
        URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print("[ERROR] \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Status code: \(response.statusCode)")
            }

            do {
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        print("Result -> \(json)")
                    } else {
                        print("No response data as JSON")
                    }
                } else {
                    print("[ERROR] No data")
                }
            }  catch {
                print("[ERROR] Json parsing error: \(error.localizedDescription)")
            }
        }.resume()
        return [:]
    }
}

let data: [String: Any] = [
    "title": "foofddasfda",
    "body": "baasdfasdfr",
]

let header: [String: String] = [
    "application/json" : "Content-Type"
]

let param: [String: String] = [
    "id" : "1"
]



var laynet = LayNet(url: "https://jsonplaceholder.typicode.com/posts")
laynet.sendRequest(typeRequest: LayNet.TypeRequest.get, withParams: param, httpHeader: header)

