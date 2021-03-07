//
//  SocialMediaReportView.swift
//  MediCautious
//
//  Created by Satvik Anand on 2/16/21.
//

import Foundation
import SwiftUI
import Combine

struct SocialMediaReportView: View {
    var list: Tweets
    
    var body: some View {
        ScrollView {
            ForEach(list.results) { tweet in
                HStack {
                    Text("\(tweet.text)")
                        .fontWeight(.semibold)
                        .font(.body)
                }
                .padding()
//                .border(Color.black)
                .frame(maxHeight: .infinity)
                
                Divider()
            }
        }
        .navigationBarTitle(Text("Recent Tweets"), displayMode: .inline)
        .background(Color.purple.opacity(0.3))
    }
}

struct SocialMediaReportView_Previews: PreviewProvider {
    static var list = Tweets(results: [Tweet(text: "Null", sentiment: "Null")])
    static var previews: some View {
        SocialMediaReportView(list: list)
    }
}
