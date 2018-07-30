//
//  MovieClient.swift
//  ProtocolBasedNetworkingTutorialFinal
//
//  Created by James Rochabrun on 11/28/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

class MovieClient: APIClient {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    //in the signature of the function in the success case we define the Class type thats is the generic one in the API
    func getFeedWithQueryParameters(from movieFeedType: MovieFeed,and parameters:[String:Any], completion: @escaping (Result<MovieFeedResult?, APIError>) -> Void) {
        
        let endpoint = movieFeedType
        let request = endpoint.requestWithQueryParameters(parameters)
        
        fetch(with: request, decode: { json -> MovieFeedResult? in
            guard let movieFeedResult = json as? MovieFeedResult else { return  nil }
            return movieFeedResult
        }, completion: completion)
    }
    
    func getFeedWithPathParameters(from movieFeedType: MovieFeed, pathParameters: [String], completion: @escaping (Result<MovieDetails?, APIError>) -> Void) {
        
        let endpoint = movieFeedType
        let request = endpoint.requestWithPathParameters(pathParameters)
        
        fetch(with: request, decode: { json -> MovieDetails? in
            guard let movieDetailsResult = json as? MovieDetails else { return  nil }
            return movieDetailsResult
        }, completion: completion)
    }
    
//    func getFeedWithPathParameters(from movieFeedType: MovieFeed, pathParameters: [String], completion: @escaping (Result<ProductionCompanies?, APIError>) -> Void) {
//        
//        let endpoint = movieFeedType
//        let request = endpoint.requestWithPathParameters(pathParameters)
//        
//        fetch(with: request, decode: { json -> ProductionCompanies? in
//            guard let movieDetailsResult = json as? ProductionCompanies else { return  nil }
//            return movieDetailsResult
//        }, completion: completion)
//    }
    
    
}





