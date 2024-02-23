//
//  AnyPublisher.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 20/02/2024.
//

import SwiftUI
import Combine

//The AnyPublisher object can represent, well, any publisher or operator. (Operators are a form of publishers.) When you create pipelines and want to store them in
//properties or return them from functions, their resulting types can bet pretty big because you will find they are nested. You can use AnyPublisher to turn these
//seemingly complex types into a simpler type.

//MARK: Before
//func publisher(url: URL) ->
//Publishers.ReplaceError<Publishers.Concatenate<Publishers.S
//equence<[String], Error>,
//Publishers.ReceiveOn<Publishers.Decode<Publishers.Map<URLSe
//ssion.DataTaskPublisher, JSONDecoder.Input>, String,
//JSONDecoder>, RunLoop>>> {
//    return URLSession.shared.dataTaskPublisher(for: url)
//        .map { (data: Data, response: URLResponse) in
//            data
//        }
//        .decode(type: String.self, decoder: JSONDecoder())
//        .receive(on: RunLoop.main)
//        .prepend("AWAY TEAM")
//        .replaceError(with: "No players found")
//}

//MARK: AFTER
//func publisher(url: URL) -> AnyPublisher<String, Never> {
//    return URLSession.shared.dataTaskPublisher(for: url)
//        .map { (data: Data, response: URLResponse) in
//            data
//        }
//        .decode(type: String.self, decoder: JSONDecoder())
//        .receive(on: RunLoop.main)
//        .prepend("AWAY TEAM")
//        .replaceError(with: "No players found")
//        .eraseToAnyPublisher()
//}

class AppPublishers {
    
    static func teamPublisher(homeTeam: Bool) -> AnyPublisher<String, Never> {
        if homeTeam {
            return ["amir", "alamgir", "juani"].publisher
                .prepend("HOME TEAM")
                .eraseToAnyPublisher()
        } else {
            let url = URL(string: "https://www.nba.com/api/getteam?id=21")!
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { (data: Data, response: URLResponse) in
                    data
                }
                .decode(type: String.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .prepend("AWAY TEAM")
                .replaceError(with: "No players found")
                .eraseToAnyPublisher()
        }
    }
}

class AnyPublisherVM: ObservableObject {
    @Published var team: [String] = []
    private var cancellables: Set<AnyCancellable> = []

    func fetch(homeTeam: Bool) {
        team.removeAll()
        AppPublishers.teamPublisher(homeTeam: true)
            .sink { [unowned self] item in
                team.append(item)
            }
            .store(in: &cancellables)
    }
}

struct AnyPublisherView: View {
    @StateObject var vm = AnyPublisherVM()
    var body: some View {
        
        List(vm.team, id: \.self) { datum in
            Text(datum)
        }
    }
}

#Preview {
    AnyPublisherView()
}
