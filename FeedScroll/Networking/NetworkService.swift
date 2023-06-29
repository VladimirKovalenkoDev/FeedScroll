//
//  NetworkService.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 28.06.2023.
//

import Foundation
import Combine

struct NetworkService: NetworkServiceProtocol {
    
    private var networkRequest: Requestable = BaseRequest()
    
    func getTimelineFeed() -> AnyPublisher<TimelineResponse, NetworkError> {
        let url = APIEndpoint.timeline.url
        return networkRequest.getRequest(url: url)
    }
}
