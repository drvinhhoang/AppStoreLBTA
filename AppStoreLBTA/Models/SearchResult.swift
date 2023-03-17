//
//  SearchResult.swift
//  AppStoreLBTA
//
//  Created by VinhHoang on 15/03/2023.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [AppResult]
}

struct AppResult: Decodable {
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Float?
    let screenshotUrls: [String]
    let artworkUrl100: String // app icon
}
