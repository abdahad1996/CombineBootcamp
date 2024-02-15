//
//  CompactMap.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 14/02/2024.
//

import SwiftUI
import Combine

//Just like the compactMap except you are also allowed to throw an error inside the closure provided. This operator lets the pipeline know that a failure is possible. So
//when you add a sink subscriber, the pipeline will only allow you to add a sink(receiveCompletion:receiveValue:) as it expects you to handle possible failures

struct InvalidValueError: Error, Identifiable {
    let id = UUID()
    let description = "One of the values you entered is invalid and will have to be updated."
}

class TryCompactMapVM:ObservableObject {
    @Published var data: [String] = []
    @Published var invalidValueError:InvalidValueError?

    func fetch() {
    let dataIn = ["Value 1", nil, "Value 3", nil, "Value 5", "Invalid"]
        
    _ = dataIn.publisher
            .tryCompactMap{ item in
                if item == "Invalid" {
                    throw InvalidValueError()
                }
                return item
            }
            .sink(receiveCompletion: { [unowned self] (completion) in
                if case .failure(let error) = completion {
                self.invalidValueError = error as? InvalidValueError
                }
            }, receiveValue: { [unowned self] (item) in
                self.data.append(item)
            })
            
        }
    }

struct TryCompactMap: View {
    @StateObject var vm = TryCompactMapVM()
    var body: some View {

        List(vm.data, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }.alert(item: $vm.invalidValueError) { error in
            Alert(title: Text("Error"), message: Text(error.description))
            }
        
    }
}

#Preview {
    TryCompactMap()
}
