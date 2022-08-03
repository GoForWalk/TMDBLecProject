//
//  TrendDB.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/03.
//

import Foundation

class GenreDB {
    
    static let shared = GenreDB()
    
    private init () {}
    
    private var tvGenre: [Int:String] = [:]
    
    func appendGenre(key: Int, value: String) {
        tvGenre[key] = value
    }
        
    func searchGenreFromData(key: Int) -> String? {
        return tvGenre[key]
    }
    
    
}
