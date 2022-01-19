//
//  Models.swift
//  Google News
//
//  Created by Ergün Yunus Cengiz on 10.01.2022.
//

import Foundation

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String?
    let description: String?
    let url : String?
    let urlToImage: String?
}

struct NewsModel: Codable {
    let title: String
    let subtitle: String
    let imageUrl: URL?
    var imageData: Data? = nil
    let url: URL?
    
    init(title: String, subtitle: String, imageUrl: URL?, url: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.url = url
    }
}
