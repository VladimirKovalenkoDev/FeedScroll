//
//  APIEndpoint.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 28.06.2023.
//

import Foundation

enum APIEndpoint: String {
    
    case timeline
    case base
    
    private var baseURL: String {
        "https://api.vc.ru/v2.1/"
    }
    
    var url: URL {
        URL(string: "\(baseURL)\(self.rawValue)?allSite=false")!
    }
    
    func loadImage(with uuid: String) -> String {
        "https://leonardo.osnova.io/\(uuid)"
    }
}
