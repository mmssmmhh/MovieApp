//
//  MovieFeed.swift
//  MovieApp
//
//  Created by Mohamed Kelany on 7/27/18.
//  Copyright © 2018 Mohamed Kelany. All rights reserved.
//

import Foundation

enum MovieFeed {
    
        case discoverMovie
        case movieDetails
    
       // case pageNumber
}

extension MovieFeed: Endpoint {
  
    var base: String {
        return "https://api.themoviedb.org"
    }

    
        var path: String {
            switch self {
            case .discoverMovie: return "/3/discover/movie"
            case .movieDetails: return "/3/movie/"
           // case .pageNumber: return "1"
            }
        }
    
}
