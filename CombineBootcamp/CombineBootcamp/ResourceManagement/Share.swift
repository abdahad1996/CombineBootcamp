//
//  Share.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 25/02/2024.
//

import SwiftUI
import Combine

//Combine is designed around structs — which are value types — ensuring that a copy is made by the system whenever a resource is stored in a property (or passed around in functions) so it can deliver values without side-effects.

//MARK: Share() operator
//The purpose of this operator is to let you obtain a publisher by reference rather than by value. Publishers are usually structs: When you pass a publisher to a function or store it in several properties, Swift copies it several times. When you subscribe to each of the copies, the publisher can only do one thing: Start the work it’s designed to do and deliver the values.
//The share() operator returns an instance of the Publishers.Share class. Often, publishers are implemented as structs, but in share()s case, as mentioned before, the operator obtains a reference to the Share publisher instead of using value semantics, which allows it to share the underlying publisher.
//This new publisher “shares” the upstream publisher. It will subscribe to the upstream publisher once, with the first incoming subscriber. It will then relay the values it receives from the upstream publisher to this subscriber and to all those that subscribe after it.

//Note: New subscribers will only receive values the upstream publisher emits after they subscribe. There’s no buffering or replay involved. If a subscriber subscribes to a shared publisher after the upstream publisher has completed, that new subscriber only receives the completion event

//To put this concept into practice, imagine you’re performing a network request. You want multiple subscribers to receive the result without requesting multiple times.

class ShareVM:ObservableObject{
    var cancellables = Set<AnyCancellable>()
    @Published var publisher1 = [Int]()
    @Published var publisher2 = [Int]()

    //When creating multiple subscribers, a copy of the publisher will be created and the values will start flowing for each one of them.
//    this process is  resource-intensive operations — e.g network requests — that may lead to poor performance since outcomes will be duplicated rather than shared.
    
    
    func fetchWithOutShare(){
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            .publisher
            .print()
        
        numbers
            .sink(receiveCompletion: { completion in
                print("subscription1 completion:\(completion)")

            }, receiveValue: { value in
                self.publisher1.append(value)
                print("subscription1 received:\(value)")

            })
            .store(in: &cancellables)
        
        
        numbers
            .sink(receiveCompletion: { completion in
                print("subscription2 completion:\(completion)")

            }, receiveValue: { value in
                self.publisher2.append(value)
                print("subscription2 received:\(value)")

            })
            .store(in: &cancellables)
    }
    
    //rather than duplicate your efforts, you sometimes want to share resources like network requests, image processing and file decoding. Anything resource-intensive that you can avoid repeating multiple times
    func fetchWithShare(){
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            .publisher
            .share()
            .print()
        
        //triggers the subscription
        numbers
            .sink(receiveCompletion: { completion in
                print("subscription1 completion:\(completion)")

            }, receiveValue: { value in
                self.publisher1.append(value)
                print("subscription1 received:\(value)")

            })
            .store(in: &cancellables)
        
//        If a subscriber subscribes to a shared publisher after the upstream publisher has completed, that new subscriber only receives the completion event.
        numbers
            .sink(receiveCompletion: { completion in
                print("subscription2 completion:\(completion)")

            }, receiveValue: { value in
                self.publisher2.append(value)
                print("subscription2 received:\(value)")

            })
            .store(in: &cancellables)
    }
    
    
    func fetchWithShareWithDelay(){
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            .publisher
            .delay(for: 3, scheduler: RunLoop.main)
            .share()
            .print()
        
        //triggers the subscription
        numbers
            .sink(receiveCompletion: { completion in
                print("subscription1 completion:\(completion)")

            }, receiveValue: { value in
                self.publisher1.append(value)
                print("subscription1 received:\(value)")

            })
            .store(in: &cancellables)
        
//        this subscriber subscibes before the shared subscription is finished so this will get all the values
        numbers
            .sink(receiveCompletion: { completion in
                print("subscription2 completion:\(completion)")

            }, receiveValue: { value in
                self.publisher2.append(value)
                print("subscription2 received:\(value)")

            })
            .store(in: &cancellables)
    }
}

//change the fetch method to understand share operator
struct Share: View {
    @StateObject var vm = ShareVM()
    
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
            vm.fetchWithShareWithDelay()
        }
        
    }
}

#Preview {
    Share()
}
