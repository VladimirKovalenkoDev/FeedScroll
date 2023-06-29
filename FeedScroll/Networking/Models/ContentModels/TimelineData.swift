//
//  TimelineData.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 28.06.2023.
//

import Foundation

struct TimelineData: Codable {
    let author: Author
    let title: String
    let blocks: [Block]
}

struct Author: Codable {
    let name: String
}

struct Block: Codable {
    let type: String
    let data: BlockData
}
