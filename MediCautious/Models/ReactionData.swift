//
//  ReactionData.swift
//  MediCautious
//
//  Created by Satvik Anand on 2/16/21.
//

import Combine
import SwiftUI

struct ReactionData: Decodable, Identifiable {
    let id = UUID()
    let term: String
    let count: Int
}
