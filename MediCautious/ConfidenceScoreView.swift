//
//  ConfidenceScoreView.swift
//  MediCautious
//
//  Created by Satvik Anand on 2/27/21.
//

import Foundation
import SwiftUI
import Combine

struct ConfidenceScoreView: View {
//    var list: Tweets
    var pos_count: Int
    var neg_count: Int
    var neu_count: Int
    var tot_count: Int
    var num_reactions: Int
    
    func calculateConfidenceScore() -> Double {
        let pos_rat = Double(pos_count) / Double(tot_count)
        let neg_rat = Double(neg_count) / Double(tot_count)
        
//        let confidence_score = (-1 * neg_rat * Double(num_reactions)) + (pos_rat * Double(num_reactions))
        let confidence_score = ((-1 * neg_rat * Double(num_reactions) + (pos_rat * Double(num_reactions)))/Double(num_reactions))
        
        return confidence_score
    }
    
    var body: some View {
        VStack {
            Text("Percentage of positive tweets: \(Double(100 * (Double(pos_count) / Double(tot_count))))")
            Text("Percentage of negative tweets: \(Double(100 * (Double(neg_count) / Double(tot_count))))")
            Text("Percentage of neutral tweets: \(Double(100 * (Double(neu_count) / Double(tot_count))))")
            Text("Number of adverse reaction reports: \(num_reactions)")
            Text("Confidence score: \(calculateConfidenceScore())")
        }
    }
}

struct ConfidenceScoreView_Previews: PreviewProvider {
//    static var list = Tweets(results: [Tweet(text: "Null", sentiment: "Null")])
    static var poscount = 0
    static var negcount = 0
    static var neucount = 0
    static var totcount = 0
    static var numreactions = 0
    static var previews: some View {
//        ConfidenceScoreView(list: list)
        ConfidenceScoreView(pos_count: poscount, neg_count: negcount, neu_count: neucount, tot_count: totcount, num_reactions: numreactions)
    }
}
