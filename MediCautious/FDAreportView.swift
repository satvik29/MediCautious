//
//  FDAreportView.swift
//  MediCautious
//
//  Created by Satvik Anand on 2/15/21.
//

import Foundation
import SwiftUI

struct FDAreportView: View {
//    var list: [ReactionData]
    var list: ReactionList
    
    var body: some View {
        ScrollView {
            ForEach(list.results) { reaction in
                HStack {
                    Text("\(reaction.count) reports of \(reaction.term)")
                        .fontWeight(.semibold)
                        .font(.body)
                        .padding()
                }
                Divider()
            }
        }
        .navigationBarTitle(Text("FDA Reports"), displayMode: .inline)
        .background(Color.purple.opacity(0.3))
    }
}

struct FDAreportView_Previews: PreviewProvider {
    static var list = ReactionList(results: [ReactionData(term: "Null", count: 0)])
    static var previews: some View {
        FDAreportView(list: list)
    }
}
