//
//  TimelineResponse.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 28.06.2023.
//

import Foundation

struct TimelineResponse: Codable {
    let result: Items
}

struct Items: Codable {
    let items: [Item]
}

struct Item: Codable {
    let type: String
    let data: TimelineData
}
