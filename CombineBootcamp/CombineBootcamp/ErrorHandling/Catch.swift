//
//  Catch.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 23/02/2024.
//

import SwiftUI
import Combine

//The catch operator has a very specific behavior. It will intercept errors thrown by upstream publishers/operators but you must then specify a new publisher that will
//publish a new value to go downstream. The new publisher can be to send one value, many values, or do a network call to get values. It’s up to you.
//The one thing to remember is that the publisher you specify within the catch’s closure must return the same type as the upstream publisher.

//Catch will intercept and replace the upstream publisher.
//“Replace” is the important word here.
//This means that the original publisher will not publish any
//other values after the error was thrown because it was
//replaced with a new one.


class CatchVM: ObservableObject {
    @Published var dataToView: [String] = []
    
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
            .catch{ err in
                Just("error in pipeline hence stop here")
            }
            .sink { [unowned self] (item) in
                dataToView.append(item)
            }
    }
}

struct Catch: View {
    @StateObject var vm = CatchVM()
    var body: some View {

        List(vm.dataToView, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
    }
}

#Preview {
    Catch()
}
