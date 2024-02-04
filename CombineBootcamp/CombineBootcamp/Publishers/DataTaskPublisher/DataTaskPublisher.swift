//
//  DataTaskPublisher.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 04/02/2024.
//

import SwiftUI
import Combine

struct CatFact: Decodable {
    let _id: String
    let text: String
}
enum ApiError:Error{
    case invalidResponse
}

class DataTaskPublisherViewModel:ObservableObject{
    
    @Published var models = [CatFact]()
    @Published var error: String?
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.fetch()
    }
    func fetch(){
        let url = URL(string: "https://cat-fact.herokuapp.com/factss")!
         URLSession.shared.dataTaskPublisher(for: url)
            .print()
            .tryMap { (data: Data, response: URLResponse) in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200
            else {
                throw ApiError.invalidResponse
            }
            return data
        }
        
        .decode(type: [CatFact].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
           
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] catFacts in
                self?.models = catFacts
            }
            .store(in: &cancellables)

        
    }
}
struct DataTaskPublisher: View {
    @StateObject var vm = DataTaskPublisherViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        if let error = vm.error {
            Text(error)
        }
        List(vm.models,id: \._id) { item in
            Text(item.text)
        }
    }
}

#Preview {
    DataTaskPublisher()
}
