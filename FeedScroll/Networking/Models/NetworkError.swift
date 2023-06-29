//
//  NetworkError.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 28.06.2023.
//

import Foundation

enum NetworkErrorType {
    case server
    case decoding
    case other(String)
}

struct NetworkError: Error {
    let type: NetworkErrorType
    let status: Int?
    let code: Int?
    let message: String?
}

extension NetworkError {
    init(
        _ type: NetworkErrorType,
        code: Int? = nil,
        status: Int? = nil
    ) {
        self.type = type
        self.code = code
        self.status = status
        
        switch type {
        case .server:
            message = "Server side trouble: \(code ?? 0)"
        case .decoding:
            message = "Decoding trouble"
        case .other(let text):
            message = "\(text)"
        }
    }
}
