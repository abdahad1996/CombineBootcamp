//
//  FlatMap.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 22/02/2024.
//

import SwiftUI
import Combine



//you get elements from upstream and you transform them to a publisher and publish the results

//You are used to seeing a value of some sort sent down a pipeline. But what if you wanted to use that value coming down the pipeline to retrieve more data from
//another data source. You would essentially need a publisher within a publisher. The flatMap operator allows you to do this.

//in this case order is not guaranteed
//All of the publishers can run
//all at the same time.
//You CAN control how many publishers can run at the same
//time though with the maxPublishers parameter.


fileprivate struct NameResult: Decodable {
    var name = ""
    var gender = ""
    var probability = 0.0
}
class FlatMapVM: ObservableObject {
    @Published var names = ["Kelly", "Madison", "Pat", "Alexus", "Taylor", "Tracy"]
    @Published fileprivate var nameResults: [NameResult] = []
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchNameResults() {
        names.publisher
            .map { name -> (String, URL) in
                (name, URL(string: "https://api.genderize.io/?name=\(name)")!)
            }
            .flatMap { (name, url) -> AnyPublisher<NameResult, Never> in
                URLSession.shared.dataTaskPublisher(for: url)
                    .map { (data: Data, response: URLResponse) in
                        data
                    }
                    .decode(type: NameResult.self, decoder: JSONDecoder())
                    .replaceError(with: NameResult(name: name, gender: "Undetermined"))
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink { [unowned self] nameResult in
                nameResults.append(nameResult)
            }
            .store(in: &cancellables)
    }
}
struct FlatMap: View {
    @StateObject var vm = FlatMapVM()
    var body: some View {
        VStack(spacing: 20) {
            Text("Names")
            HStack(spacing: 20) {
              
                List(vm.names, id: \.self) { datum in
                    Text(datum)
                }
                
              
                
               
                
            }
            Text("Genders")
            List(vm.nameResults, id: \.name) { datum in
                
                Text("\(datum.name) \(datum.gender)")
            }
        }
       
            .task {
                vm.fetchNameResults()
            }
    }
}

#Preview {
    FlatMap()
}
