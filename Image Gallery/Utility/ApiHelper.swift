//
//  Feed.swift
//  Image Gallery
//
//  Created by Sandeep Kumar on 5/10/24.
//

import Foundation

class ApiHelper {
    
    static var shared = ApiHelper(baseURL: URL(string: "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100")!)
    
    //MARK:- ====== Variables ======
    let baseURL: URL
    
    //MARK:- ====== Life Cycle ======
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    //MARK:- ====== Functions ======
    func fetchList(completionHandler: @escaping (Result<[Feed], Error>) -> Void)  {
        let request = URLRequest(url: baseURL)
        
        URLSession.shared.dataTask(with: request) {
            data, responceURL, error in
            
            guard let data = data else {
                //ERROR
                guard let error = error else { return }
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
                return
            }
            let list: [Feed]? = try? JSONDecoder().decode([Feed].self, from: data)
            DispatchQueue.main.async {
                completionHandler(.success(list ?? []))
            }
        }.resume()
    }
    
    static func downloadImage(from urlImage: URL?, to: URL?, blockDone: ((Bool) -> ())?) -> URLSessionDownloadTask? {
        guard let urlImage = urlImage, let to = to else {
            blockDone?(false)
            return nil
        }
        let task = URLSession.shared.downloadTask(with: URLRequest(url: urlImage)) {
            url, responceURL, error in
            DispatchQueue.main.async {
                guard let url = url else {
                    blockDone?(false)
                    return
                }
                try? FileManager.default.copyItem(
                    at: url,
                    to: to
                )
                blockDone?(false)
            }
        }
        return task
    }
}
