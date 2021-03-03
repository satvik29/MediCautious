//
//  ContentView.swift
//  MediCautious
//
//  Created by Satvik Anand on 2/5/21.
//

import SwiftUI
import Combine

struct ReactionData: Decodable, Identifiable {
    let id = UUID()
    let term: String
    let count: Int
}

struct ReactionList: Decodable {
    let results: [ReactionData]
}

class NetworkManager: ObservableObject {
    var didChange = PassthroughSubject<NetworkManager, Never>()
    
    @Published var searchText: String = "" {
        didSet {
            fetchData()
        }
    }
    
    @Published var reactions = ReactionList(results: [])
    
    func resetReactions() {
        searchText = ""
        reactions =  ReactionList(results: [])
    }
    
    func fetchData() {
        guard let url = URL(string: "https://api.fda.gov/drug/event.json?search=patient.drug.medicinalproduct:\(searchText)&count=patient.reaction.reactionmeddrapt.exact") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }

            do {
                let reactions = try JSONDecoder().decode(ReactionList.self, from: data)
                DispatchQueue.main.async {
                    self.reactions = reactions
                }
            } catch {
                print("Error fetching results")
            }

            print("Fetched JSON")
        }.resume()
    }

    func getReactions() -> ReactionList {
        return self.reactions
    }

    init() {
        guard let url = URL(string: "https://api.fda.gov/drug/event.json?search=patient.drug.medicinalproduct:\(searchText)&count=patient.reaction.reactionmeddrapt.exact") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                let reactions = try JSONDecoder().decode(ReactionList.self, from: data)
                DispatchQueue.main.async {
                    self.reactions = reactions
                }
            } catch {
                print("Error fetching results")
            }
            
            print("Fetched JSON")
        }.resume()
    }
}

struct ContentView: View {
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

                //reactions = networkManager.getReactions().results
//                ForEach(reactions) { reaction in
//                    HStack {
//                        Text("\(reaction.count) reports of \(reaction.term)")
//                    }
//                }
                
                VStack {
                    NavigationLink(destination: EmptyView()) {
                        Text("Confidence Score")
                    }
                    
                    NavigationLink(destination: FDAreportView(list: reactions)) {
                        Text("Number of FDA reports: \(numReactions())")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("SM reports number")
                    }
                }
            }
            .navigationTitle("MediCautious")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
        }
}
