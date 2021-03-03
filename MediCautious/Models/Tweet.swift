//
//  Tweets.swift
//  MediCautious
//
//  Created by Satvik Anand on 2/26/21.
//

import Foundation

struct Tweets: Decodable {
    let positive: [String]
    let negative: [String]
    let neutral: [String]
}
