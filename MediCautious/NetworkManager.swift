//
//  NetworkManager.swift
//  MediCautious
//
//  Created by Satvik Anand on 2/16/21.
//

import Combine
import SwiftUI

class NetworkManager: ObservableObject {
    var didChange = PassthroughSubject<NetworkManager, Never>()
    
    @Published var searchText: String = "" {
        didSet {
            fetchData()
            fetchTweets()
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
    
    @Published var tweets = Tweets(results: [])
    
    func resetTweets() {
        tweets =  Tweets(results: [])
    }
    
    func fetchTweets() {
        guard let url = URL(string: "http://127.0.0.1:5000/tweets") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        guard let encoded = try? JSONEncoder().encode(searchText) else {
            print("Failed to encode search test")
            return
        }
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let tweets = try JSONDecoder().decode(Tweets.self, from: data)
                DispatchQueue.main.async {
                    self.tweets = tweets
                }
            } catch {
                print("Error fetching results")
            }
            
            print("Fetched tweets")
        }.resume()
    }
    
    func getTweets() -> Tweets {
        return self.tweets
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
        
        guard let url_tweets = URL(string: "http://127.0.0.1:5000/tweets") else {
            return
        }
        
        URLSession.shared.dataTask(with: url_tweets) { (data, _, _) in
            guard let data = data else { return }

            do {
                let tweets = try JSONDecoder().decode(Tweets.self, from: data)
                DispatchQueue.main.async {
                    self.tweets = tweets
                }
            } catch {
                print("Error fetching results")
            }

            print("Fetched JSON")
        }.resume()
    }
}
