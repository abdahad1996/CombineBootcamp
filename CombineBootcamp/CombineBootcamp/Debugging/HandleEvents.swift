//
//  HandleEvents.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 24/02/2024.
//

import SwiftUI

//There are some events you have access to with the sink subscriber such as when it receives a value or when it cancels or completes. But what if you’re not using a
//sink subscriber or if you need access to other events such as when a subscription is received or a request is received?
//This is where the handleEvents operator can become useful. It is one operator that can expose 5 different events and give you closures for each one so you can write
//debugging code or other code
//as you will see in the following examples.


//The receiveCompletion in this
//example will not execute because there is an
//error is being thrown
fileprivate struct InvalidError : Error {
    
}
class HandleEventsVM: ObservableObject {
    @Published var dataToView: [String] = []
    
    func fetch() {
        let dataIn = ["abdul", "Sami", "12", "bilals"]
        _
        = dataIn.publisher
            .handleEvents(
                receiveSubscription: { subscription in
                    print("Event: Received subscription")
                }, receiveOutput: { item in
                    print("Event: Received output: \(item)")
                }, receiveCompletion: { completion in
                    print("Event: Pipeline completed")
                }, receiveCancel: {
                    print("Event: Pipeline cancelled")
                }, receiveRequest: { demand in
                    print("Event: Received request")
                })
            .tryMap { item in
                if item == "blabla" {
                    throw InvalidError()
                }
                return item
            }
        
            .sink(receiveCompletion: { completion in
                print("Pipeline completed")
            }, receiveValue: { [unowned self] item in
                dataToView.append(item)
            })
    }
}
struct HandleEvents: View {
    @StateObject private var vm = HandleEventsVM()
    var body: some View {
        
        List(vm.dataToView, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
    }
}

#Preview {
    HandleEvents()
}
