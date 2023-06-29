//
//  CollectionView+ReuseId.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 27.06.2023.
//

import UIKit

protocol ReusableCell: AnyObject {
    static var reuseId: String { get }
}

extension ReusableCell {
    static var reuseId: String {
        return "\(Self.self)"
    }
}

