//
//  APICall.swift
//  Google News
//
//  Created by Ergün Yunus Cengiz on 8.01.2022.
//

import Foundation

final class APICall {
    
    static let apiCall = APICall()
    
    struct Constants {
        static let newsURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=a2d266e9c0a74157bf29053d984f5a43")
    }
    
    public func getNews(endOfGet: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.newsURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {endOfGet(.failure(error))}
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    endOfGet(.success(result.articles))
                } catch {
                    endOfGet(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}


