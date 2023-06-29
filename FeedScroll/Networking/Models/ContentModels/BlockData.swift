//
//  BlockData.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 28.06.2023.
//

import Foundation

struct BlockData: Codable {
    let text: String?
    let items: [ItemUnion]?
}

enum ItemUnion: Codable {
    case image(BlockItem)
    case list(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .list(x)
            return
        }
        if let x = try? container.decode(BlockItem.self) {
            self = .image(x)
            return
        }
        throw DecodingError.typeMismatch(ItemUnion.self, DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "Wrong type for ItemUnion"
        )
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .image(let x):
            try container.encode(x)
        case .list(let x):
            try container.encode(x)
        }
    }
}

struct BlockItem: Codable {
    let title: String
    let image: ImageData
}

struct ImageData: Codable {
    let type: String
    let data: ImageInfo
}

struct ImageInfo: Codable {
    let uuid: String
    let width: Int
    let height: Int
    let size: Int
    let type: String
}
