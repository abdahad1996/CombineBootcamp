//
//  Share.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 25/02/2024.
//

import SwiftUI
import Combine


//MARK: MultiCast() operator
//This operator builds on share() and uses a Subject of your choice to publish values to subscribers. The unique characteristic of multicast(_:) is that the publisher it returns is a ConnectablePublisher. What this means is it won’t subscribe to the upstream publisher until you call its connect() method. This leaves you ample time to set up all the subscribers you need before letting it connect to the upstream publisher and start the work.

//A multicast publisher, like all ConnectablePublishers, also provides an autoconnect() method, which makes it work like share(): The first time you subscribe to it, it connects to the upstream publisher and starts the work immediately. This is useful in scenarios where the upstream publisher emits a single value and you can use a CurrentValueSubject to share it with subscribers.

class MultiCastVM:ObservableObject{
    var cancellables = Set<AnyCancellable>()
    @Published var publisher1 = [Int]()
    @Published var publisher2 = [Int]()

    
    //no delay needeed like share operator
    func fetchWithMulticast(){
        
        let subject = PassthroughSubject<Int, Never>()
        let multicasted = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            .publisher
            .print()
            .multicast(subject: subject)
        
        
         multicasted
            .sink(receiveCompletion: { completion in
                print("subscription1 completion:\(completion)")

            }, receiveValue: { value in
                self.publisher1.append(value)
                print("subscription1 received:\(value)")

            })
            .store(in: &cancellables)
        
      multicasted
            .sink(receiveCompletion: { completion in
                print("subscription2 completion:\(completion)")

            }, receiveValue: { value in
                self.publisher2.append(value)
                print("subscription2 received:\(value)")

            })
            .store(in: &cancellables)
        
        //this triggers the subscription so all subscribers will get the values downstream
        multicasted.connect().store(in: &cancellables)
    }
    
}

struct MultiCast: View {
    @StateObject var vm = MultiCastVM()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("publisher 1")
           
            List(vm.publisher1, id: \.self) { datum in
                Text("\(datum)")
            }
            
            Divider()
            
            Text("publisher 2")
           
            List(vm.publisher2, id: \.self) { datum in
                Text("\(datum)")
            }
            
        }.task {
            vm.fetchWithMulticast()
        }
        
    }
}

#Preview {
    MultiCast()
}
