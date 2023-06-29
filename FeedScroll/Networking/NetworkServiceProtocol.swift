//
//  NetworkServiceProtocol.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 28.06.2023.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func getTimelineFeed() -> AnyPublisher<TimelineResponse, NetworkError>
}
