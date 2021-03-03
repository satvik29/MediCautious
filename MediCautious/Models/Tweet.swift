//
//  Tweets.swift
//  MediCautious
//
//  Created by Satvik Anand on 2/26/21.
//

import Foundation

struct Tweet: Decodable, Identifiable {
    let id = UUID()
    let text: String
    let sentiment: String
}
