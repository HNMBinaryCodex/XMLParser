//
//  Joke.swift
//  XMLParser
//
//  Created by Waveline Media on 12/3/19.
//  Copyright © 2019 DevFest. All rights reserved.
//

import Foundation

class JokeModel: NSObject {

    public var id: Int!
    public var category: String!
    public var type: String!
    public var setup: String!
    public var delivery: String!
    
    public init(details: [String: Any]) {
        super.init()
        
        if let jokeId = details["id"] as? Int {
            id = jokeId
        } else {
            let jokeId = details["id"] as? String ?? ""
            id = Int(jokeId) ?? 0
        }
        
        category = details["category"] as? String
        type = details["type"] as? String
        setup = details["setup"] as? String ?? ""
        delivery = details["delivery"] as? String ?? ""
    }
}
