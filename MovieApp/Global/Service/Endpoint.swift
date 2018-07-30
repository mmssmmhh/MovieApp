//
//  Endpoint.swift
//  ProtocolBasedNetworkingTutorialFinal
//
//  Created by James Rochabrun on 11/27/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

protocol Endpoint {
    
    var base: String { get }
    var path: String { get }
}

extension Endpoint {
 
    var apiKey: String {
        return "api_key=ceb888b71023afda704f84975d2642b5"
    }
 
//   var urlComponents: URLComponents {
//        var components = URLComponents(string: base)!
//        components.path = path
//        components.query = apiKey
//        return components
//    }
    
    func urlComponentsWithPathParameters(parameters: [String]?)-> URLComponents{
        print(path)
        var components = URLComponents(string: base)!
       // components.path = path
        //components.query = apiKey
        
        var pathWithParameters:String = ""
        if let parameters = parameters{
            for parameter in parameters {
                pathWithParameters = path + "\(parameter)"
                
            }
        }
        print(pathWithParameters)
        components.path = pathWithParameters
        components.query = apiKey
        
        return components
    }
 
    
    func urlComponentsWithQueryParameters(parameters:[String: Any]?) -> URLComponents {
        print(path)
        var components = URLComponents(string: base)!
        components.path = path
        
        var query:String = ""
        if let parameters = parameters{
            for (key,value) in parameters {
                query = query + "&\(key)=\(value)"
                
            }
        }
        components.query = apiKey + query
        
        
        return components
        
    }
    
    func requestWithQueryParameters(_ parameters:[String: Any]?) -> URLRequest {
        
        let url = urlComponentsWithQueryParameters(parameters: parameters).url!
        return URLRequest(url: url)
    }
    
    func requestWithPathParameters(_ parameters:[String]) -> URLRequest {
        let url = urlComponentsWithPathParameters(parameters: parameters).url!
        return URLRequest(url: url)
    }
    
//   var request: URLRequest {
//        let url = urlComponents.url!
//        return URLRequest(url: url)
//    }
 
}










