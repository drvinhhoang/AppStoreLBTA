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
    
    func fetchApps(searchTerm: String, completion: @escaping (Result<SearchResult?, Error>) -> ()) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchTopPaid(completion: @escaping ((Result<AppGroup?, Error>) -> Void)) {
        let urlstring = "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/50/apps.json"
        fetchAppGroup(urlString: urlstring, completion: completion)
    }
    
    func fetchTopMostPlayedMusic(completion: @escaping ((Result<AppGroup?, Error>) -> Void)) {
        let urlstring = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/25/albums.json"
        fetchAppGroup(urlString: urlstring, completion: completion)
    }
    
    func fetchTopAudioBooks(completion: @escaping ((Result<AppGroup?, Error>) -> Void)) {
        let urlstring = "https://rss.applemarketingtools.com/api/v2/us/audio-books/1461817928/25/audio-books.json"
        fetchAppGroup(urlString: urlstring, completion: completion)
    }
    
    private func fetchAppGroup(urlString: String, completion: @escaping ((Result<AppGroup?, Error>) -> Void)) {
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchSocialApps(completion: @escaping ((Result<[SocialApp]?, Error>) -> Void)) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
       fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping ((Result<T?, Error>) -> Void)) {
        guard let url = URL(string:urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, resp, err in
            guard let data = data else {
                return
            }
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                completion(.success(objects))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
}
