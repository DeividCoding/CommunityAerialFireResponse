//
//  API.swift
//  simulationdead
//
//  Created by Lisette HG on 08/10/23.
//

import Foundation
import Alamofire
import Network

typealias LSResponseCompletionNoBase<T: Codable> = (AFResult<T>) -> Void

enum API {
    
    private static let APISession: Alamofire.Session = Alamofire.Session()

    case sendDeadSensor(dead: DeadRequest)
    
    var url: String {
        switch self {
        case .sendDeadSensor:
            return "https://system-api-hackthon.onrender.com/api/v1/deadth-sensor/"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .sendDeadSensor:
            return .patch
        }
    }

    var parameters: Parameters? {
        switch self {
        case .sendDeadSensor(let dead):
            return ["latitude": dead.latitude,
                    "longitude": dead.longitude,
                    "is_dead": dead.is_dead]
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .sendDeadSensor:
            return [:]
        }
    }
}


extension API {
    
    func resumeJSON<T: Codable>(completion: @escaping (AFResult<T>) -> Void) {
        
        print("------------------------ Start of the call  ")

        var request = URLRequest(url: URL(string: self.url.replacingOccurrences(of: " ", with: "%20"))!)
        request.httpMethod = self.method.rawValue.uppercased()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(request.url ?? URL(fileURLWithPath: ""))

        if let parametes = self.parameters {
            guard let data = try? JSONSerialization.data(withJSONObject:parametes, options: .sortedKeys) else {
                return
            }
            request.httpBody = data
            
            if let httpBody = request.httpBody {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: httpBody, options: .allowFragments)
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    print(jsonString ?? "")
                } catch {
                    print(error)
                }
            }

        }
        for h in self.headers {
            request.addValue(h.value, forHTTPHeaderField: h.name)
        }
        
        print(request.headers)

        Alamofire.AF.request(request).responseData { (response) in
            switch response.result {
            case .success(let dataResponse):
                do {
                    let object = try JSONDecoder().decode(T.self, from: dataResponse)
                    let jsonData = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                    let jsonPrettyPrintedData = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                    if let jsonString = String(data: jsonPrettyPrintedData, encoding: .utf8) {
                        print(jsonString)
                    }
                    completion(.success(object))
                } catch {
                    completion(.failure(AFError.createURLRequestFailed(error: error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    // MARK: - API - Call
    func resume<T: Codable>(completion: @escaping (AFResult<T>) -> Void) {
        
        print("------------------------ Start of the call  ")
        
        var request = URLRequest(url: URL(string: self.url.replacingOccurrences(of: " ", with: "%20"))!)
        request.httpMethod = self.method.rawValue.uppercased()
       // request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        print(request.url ?? URL(fileURLWithPath: ""))
        
        if let parameters = self.parameters {
            var urlComponents = URLComponents()
            urlComponents.queryItems = parameters.compactMap { (key, value) -> URLQueryItem? in
                return URLQueryItem(name: key, value: "\(value)")
            }

            if let urlEncodedParams = urlComponents.percentEncodedQuery {
                request.httpBody = Data(urlEncodedParams.utf8)
                print(urlEncodedParams)
            }
        }
        
        for h in  self.headers {
            request.addValue(h.value, forHTTPHeaderField: h.name)
        }
        print(request.headers)
        Alamofire.AF.request(request).responseData { (response) in
            switch response.result {
            case .success(let dataResponse):
                do {
                    let object = try JSONDecoder().decode(T.self, from: dataResponse)
                    let jsonData = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                    let jsonPrettyPrintedData = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                    if let jsonString = String(data: jsonPrettyPrintedData, encoding: .utf8) {
                        print(jsonString)
                    }
                    completion(.success(object))
                } catch {
                    completion(.failure(AFError.createURLRequestFailed(error: error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}



