//
//  Catch.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 23/02/2024.
//

import SwiftUI
import Combine

//If you want the ability of the catch operator but also want to be able to throw an error, then tryCatch is what you need.
//Can I use tryMap on a non-error throwing pipeline?
//No. Upstream from the tryCatch has to be some operator or publisher
//that is capable of throwing errors. That is why you see tryMap upstream
//from tryCatch. Otherwise, Xcode will give you an error

//Can I use tryMap on a non-error throwing pipeline?
//No. Upstream from the tryCatch has to be some operator or publisher
//that is capable of throwing errors. That is why you see tryMap upstream
//from tryCatch. Otherwise, Xcode will give you an error.

struct DetectedError: Error, Identifiable {
    let id = UUID()
}

class TryCatchVM: ObservableObject {
    @Published var dataToView: [String] = []
    @Published var error: DetectedError?
    
    func fetch() {
        let dataIn = ["1", "2","🧨", "3"]
        _
        = dataIn.publisher
            .tryMap { item in
                // There should never be a 🧨 in the data
                if item == "🧨" {
                    throw InvalidValueError()
                }
                return item
            }
        //returns another publoisher
            .tryCatch{ [unowned self] error in
                fetchAlternateData()
//                Just("error in pipeline hence stop here")
            }
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { val in
                
            })
    }
    
    func fetchAlternateData() -> AnyPublisher<String, Error> {
        ["1", "2",
         "🧨"
         , "3"]
            .publisher
            .tryMap{ item -> String in
                if item == "🧨" { throw DetectedError() }
                return item
            }
            .eraseToAnyPublisher()
    }
}

struct TryCatch: View {
    @StateObject var vm = TryCatchVM()
    var body: some View {

        List(vm.dataToView, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
    }
}

#Preview {
    TryCatch()
}
