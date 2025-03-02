//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Game: Identifiable, Codable {
    let id: Int
    let team: String
    let opponent: String
    let date: String
    let isHomeGame: Bool
    let score: Score

    struct Score: Codable {
        let unc: Int
        let opponent: Int
    }
}

class GamesViewModel: ObservableObject {
    @Published var games: [Game] = []
    
    func fetchGames() {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        self.games = try JSONDecoder().decode([Game].self, from: data)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
        }.resume()
    }
}

struct ContentView: View {
    @StateObject var viewModel = GamesViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.games) { game in
                GameRow(game: game)
            }
            .navigationTitle("UNC Basketball")
        }
        .onAppear {
            viewModel.fetchGames()
        }
    }
}

struct GameRow: View {
    let game: Game
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(game.team) vs. \(game.opponent)")
                    .font(.headline)
                Text(game.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack {
                Text("\(game.score.unc) - \(game.score.opponent)")
                    .font(.headline)
                Text(game.isHomeGame ? "Home" : "Away")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
