//
//  LoadableImageView.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 29.06.2023.
//

import UIKit

final class LoadableImageView: UIImageView {
    var imageUrlString: String?

    private let imageCache = NSCache<NSString, UIImage>()
    var task: URLSessionDataTask!

    func downloadedFrom(urlString: String) {
        imageUrlString = urlString
        guard let url = URL(string: urlString) else { return }
        image = nil
        if let task = task {
            task.cancel()
        }
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard
                let data = data,error == nil,
                let image = UIImage(data: data)
            else {
                print("Error load image from: \(url)")
                return
            }
            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async() { [weak self] in
                guard let self = self else { return }
                let imageToCache = image
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
            }
        }
        task.resume()
    }
}
