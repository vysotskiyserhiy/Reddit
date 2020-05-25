//
//  Models.swift
//  Reddit
//
//  Created by Serge Vysotsky on 25.05.2020.
//  Copyright © 2020 Serge Vysotsky. All rights reserved.
//

import SwiftUI

struct RedditResponse<Model: Codable>: Codable {
    let data: Model
}

struct RedditHotPost: Codable, Identifiable {
    let id: String
    let title: String
    let selftext: String
    let preview: Preview?
    
    struct Preview: Codable {
        let enabled: Bool
        let images: [Image]
        
        struct Image: Codable {
            let id: String
            let resolutions: [Resolution]
            
            struct Resolution: Codable {
                let height: CGFloat
                let width: CGFloat
                let url: String
            }
        }
    }
}

struct RedditList: Codable {
    let after: String?
    let before: String?
    let children: [RedditResponse<RedditHotPost>]
}

typealias RootResponse = RedditResponse<RedditList>
