//
//  ImageCollectionCellViewModel.swift
//  Image Gallery
//
//  Created by Sandeep Kumar on 5/10/24.
//

import UIKit
import Foundation

class ImageCollectionCellViewModel {
    var url: URL?
    var task: URLSessionDownloadTask?
    var image: UIImage?
    var local: URL?
    var blockImageUpdate: ((UIImage?) -> ())?
    
    init(_ feed: Feed) {
        self.url = feed.thumbnail?.imageURL
        
        guard let path = feed.thumbnail?.path else { return }
        local = FileManager.default.temporaryDirectory.appendingPathComponent(path, isDirectory: false)
    }
    
    func cancelRequest() {
        task?.cancel()
    }
    
    func fetchImage() {
        if self.image != nil {
            return
        }
        
        if let local = local, FileManager.default.fileExists(atPath: local.path) {
            DispatchQueue.global(qos: .background).async {
                [weak self] in
                if let img = UIImage(contentsOfFile: local.path) {
                    self?.image = img
                    DispatchQueue.main.async {
                        self?.blockImageUpdate?(img)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.fetchImage()
                    }
                }
            }
            return
        }
        task = ApiHelper.downloadImage(from: url, to: local) {
            [weak self] isDone in
            if isDone {
                self?.fetchImage()
            } else {
                self?.blockImageUpdate?(nil)
            }
        }
        task?.resume()
    }
}
