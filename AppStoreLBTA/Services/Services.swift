//
//  Services.swift
//  AppStoreLBTA
//
//  Created by VinhHoang on 16/03/2023.
//

import Foundation

enum AppStoreError: CustomStringConvertible, Error {
    case dataError
    case responseError
    var description: String {
        switch self {
        case .dataError:
            return "data error"
        case .responseError:
            return "responseError"
        }
    }
}

class Service {
    static let shared = Service()
    private init() { }
    
    func fetchApps(searchTerm: String, completion: @escaping (Result<[AppResult], Error>) -> ()) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch apps:", error)
                completion(.failure(AppStoreError.responseError))
                return
            }
            guard let data = data else {
                completion(.failure(AppStoreError.dataError))
                return
            }
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(.success(searchResult.results))
            } catch let error {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    func fetchGames(completion: @escaping ((Result<AppGroup?, Error>) -> Void)) {
        guard let url = URL(string: "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/50/apps.json") else { return }
        URLSession.shared.dataTask(with: url) { data, resp, err in
            if let err = err {
                return
            }
            guard let data = data else {
                return
            }
            
            do {
                let appGroup = try JSONDecoder().decode(AppGroup.self, from: data)
                completion(.success(appGroup))
            } catch {
                completion(.failure(error))
            }
            
        }
        .resume()
    }
}
