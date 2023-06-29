//
//  BaseRequest.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 28.06.2023.
//

import Foundation
import Combine

protocol Requestable {
    func getRequest<T: Decodable>(url: URL) -> AnyPublisher<T, NetworkError>
}

final class BaseRequest: Requestable {
    
    func getRequest<T: Decodable>(url: URL) -> AnyPublisher<T, NetworkError>
    where T : Decodable {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw NetworkError(.server)
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                            return error as? NetworkError ?? NetworkError(.other("Somthing is wrong"))
                        }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
