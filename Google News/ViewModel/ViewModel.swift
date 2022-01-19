//
//  ViewModel.swift
//  Google News
//
//  Created by Ergün Yunus Cengiz on 10.01.2022.
//

import Foundation
import SQLite


class NewsViewModel {
    
    var dataFromAPI = [NewsModel]()
    var articleFromAPI = [Article]()
    
    var isDatabaseNotEmpty: Bool = false
    
    var db: Connection!
    //Properties of database - Columns of table
    let newsTable = Table("news")
    let id = Expression<Int>("id")
    let titleOfNews = Expression<String?>("title")
    let subtitleOfNews = Expression<String?>("subtitle")
    let imageUrlOfNews = Expression<String?>("imageUrl")
    let urlOfNews = Expression<String?>("url")
    
    func beginFunc(completion: @escaping (() -> ())) {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("news").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            self.db = db
            createTable()
            let result = try db.scalar("SELECT count(*) FROM news")
            if("\(String(describing: result))" == "Optional(0)"){
                apiCallSubFunc(){
                    completion()
                }
            }else{
                completion()
            }
            
        } catch {
            print(error)
        }
        
    }
    
    func apiCallSubFunc(completionOfSubFunc: @escaping (() -> ())){
        APICall.apiCall.getNews { [weak self] result in
        switch result {
        case .success(let response):
            self?.deleteNewsFromDB()
            self?.articleFromAPI = response
        case .failure(let error):
            print(error)
            }
            completionOfSubFunc()
        }
    }
    
    func deleteNewsFromDB(){
        do {
            if(try db.scalar(newsTable.exists)){
                _ = try db.scalar("DELETE FROM news")
            }
        } catch {
            print(error)
        }
        
    }
    
    func createTable() {
        print("CREATE WORKING")
        let createTable = self.newsTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.titleOfNews)
            table.column(self.subtitleOfNews)
            table.column(self.imageUrlOfNews)
            table.column(self.urlOfNews)
        }
        do {
            try self.db.run(createTable)
            print("Created table !")
        } catch {
            print(error)
        }
    }
    
    func insertNews(completionOfInsert: @escaping (() -> ())){
        print("INSERT WORKING")
        for newsItem in articleFromAPI {
            let insertUser = self.newsTable.insert(self.titleOfNews <- newsItem.title, self.subtitleOfNews <- newsItem.description ?? "No Description", self.imageUrlOfNews <- newsItem.urlToImage, self.urlOfNews <- newsItem.url)
            do {
                try self.db.run(insertUser)
            } catch {
                print(error)
            }
        }
        completionOfInsert()
    }
    
    func readFromDatabase(completionOfRead: @escaping (() -> ())) {
        print("READ WORKING")
        self.dataFromAPI = []
        do {
            let news = try self.db.prepare(self.newsTable)
            for element in news {
                self.dataFromAPI.append(NewsModel(title: element[self.titleOfNews] ?? "", subtitle: element[self.subtitleOfNews] ?? "No description", imageUrl: URL(string: element[self.imageUrlOfNews] ?? ""), url: URL(string: element[self.urlOfNews] ?? "")))
            }
            print(dataFromAPI.count)
        } catch {
            print(error)
        }
        completionOfRead()
    }
}
