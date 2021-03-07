//
//  ContentView.swift
//  MediCautious
//
//  Created by Satvik Anand on 2/5/21.
//

import SwiftUI
import Combine

struct SearchView: View {
    @State var searchText = ""
    @State var isSearching = false
    @State var reactions = [ReactionData]()
    @State var tweets = [Tweet]()
    @ObservedObject var networkManager = NetworkManager()
    
    func numReactions() -> Int {
        var num = 0
        
        for reaction in reactions {
            num += reaction.count
        }
        
        return num
    }
    
    func numTweets() -> Int {
        return tweets.count
    }
    
    func numPositiveTweets() -> Int {
        var pos_count = 0
        for tweet in tweets {
            if (tweet.sentiment == "positive") {
                pos_count += 1
            }
        }
        
        return pos_count
    }
    func numNegativeTweets() -> Int {
        var neg_count = 0
        for tweet in tweets {
            if (tweet.sentiment == "negative") {
                neg_count += 1
            }
        }
        
        return neg_count
    }
    func numNeutralTweets() -> Int {
        var neu_count = 0
        for tweet in tweets {
            if (tweet.sentiment == "neutral") {
                neu_count += 1
            }
        }
        
        return neu_count
    }
    

    var body: some View {
        NavigationView {
            ScrollView {
                Spacer()
                HStack {
                    HStack {
                        TextField("Enter drug", text: $networkManager.searchText)
                            .padding(.leading, 24)
                    }
                    .padding()
                    .background(Color(.systemGray4))
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .onTapGesture(perform: {
                        isSearching = true
                        reactions = []
                        tweets = []
                    })
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Spacer()
                            
                            Button(action: {
                                searchText = ""
                                networkManager.resetReactions()
                                reactions = []
                                tweets = []
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .padding(.vertical)
                            })

                        }
                        .padding(.horizontal, 32)
                        .foregroundColor(.gray)
                    )

                    if isSearching {
                        Button(action: {
                            reactions = networkManager.getReactions().results
                            tweets = networkManager.getTweets().results
                            isSearching = false
                            searchText = ""
                        }, label: {
                            Text("Search")
                                .padding(.trailing)
                                .padding(.leading, -12)
                        })
                        .transition(.move(edge: .trailing))
                        .animation(.spring())
                    }
                }
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                VStack {
                    NavigationLink(destination: ConfidenceScoreView(pos_count: numPositiveTweets(), neg_count: numNegativeTweets(), neu_count: numNeutralTweets(), tot_count: numTweets(), num_reactions: numReactions())) {
                        Text("Confidence Report")
                            .font(.system(size: 25))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: 250, minHeight: 50)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    
                    Spacer()
                    
                    NavigationLink(destination: FDAreportView(list: ReactionList(results: reactions))) {
                        Text("Number of FDA reports: \(numReactions())")
                            .font(.system(size: 25))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: 250, minHeight: 40)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    
                    Spacer()
                    
                    NavigationLink(destination: SocialMediaReportView(list: Tweets(results: tweets))) {
                        Text("Number of social media reports: \(numTweets())")
                            .font(.system(size: 25))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: 250)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 20)
                }
            }
//            .navigationTitle("MediCautious")
            .navigationBarTitle(Text("MediCautious"), displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button( action: {
                                        print("Hello")
                                    }) {
                                        Image("Logo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 34, height: 34)
                                    }
            )
            .background(Color.purple.opacity(0.3))
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
            SearchView()
        }
}
