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
    @ObservedObject var networkManager = NetworkManager()
    
    func numReactions() -> Int {
        var num = 0
        
        for reaction in reactions {
            num += reaction.count
        }
        
        return num
    }

    var body: some View {
        NavigationView {
            ScrollView {
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
                    })
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Spacer()
                            
                            Button(action: {
                                searchText = ""
                                networkManager.resetReactions()
                                reactions = []
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

                VStack {
                    NavigationLink(destination: EmptyView()) {
                        Text("Confidence Score")
                    }
                    
                    NavigationLink(destination: FDAreportView(list: ReactionList(results: reactions))) {
                        Text("Number of FDA reports: \(numReactions())")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Number of social media reports: 0")
                    }
                }
            }
            .navigationTitle("MediCautious")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            SearchView()
        }
}
