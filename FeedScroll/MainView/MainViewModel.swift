//
//  MainViewModel.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 28.06.2023.
//

import Foundation
import Combine

class MainViewModel {
    private var cancellable: Cancellable?
    private let networkService = NetworkService()
    private var authors: [Item] = []
    private var index = 0
    
    var numberOfAuthors: Int {
        items.count
    }
    @Published private(set) var items: [Item] = []
    
    
    init() {
        getFeed()
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    private func getFeed() {
        cancellable = networkService.getTimelineFeed()
            .receive(on: DispatchQueue.global())
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("[TIMELINE]: SUCCESS")
                    case .failure(let error):
                        print("[TIMELINE]: ERROR - \(error)")
                    }
                },
                receiveValue: { [weak self] feed in
                    guard let self = self else { return }
                    self.authors = feed.result.items
                    self.items.append(authors[index])
                })
    }
    
    func addAuthor() {
        if self.items.count <= self.authors.count {
            index += 1
            self.items.append(self.authors[index])
        }
    }
}
