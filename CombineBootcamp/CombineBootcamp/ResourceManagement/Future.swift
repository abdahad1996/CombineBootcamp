//
//  Share.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 25/02/2024.
//

import SwiftUI
import Combine


//Combine comes with one more way to let you share the result of a computation: Future

//What’s interesting from a resource perspective is that:
//• Future is a class, not a struct.
//• Upon creation, it immediately invokes your closure to start computing the result and fulfill the promise as soon as possible.
//• It stores the result of the fulfilled Promise and delivers it to current and future subscribers.


//it means that Future is a convenient way to immediately start performing some work (without waiting for subscriptions) while performing work only once and delivering the result to any amount of subscribers. But it performs work and returns a single result, not a stream of results, so the use cases are narrower than full-blown publishers.
fileprivate class FutureVM:ObservableObject{
    var cancellables = Set<AnyCancellable>()
    @Published var publisher1 = [Int]()
    @Published var publisher2 = [Int]()

    
    func fetchWithFuture(){
        
        let future = Future<[Int], Never> { completion in
            let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            completion(.success(numbers))
        }
        
        
        future
            .flatMap({ nums in
                nums.publisher
            })
            .sink(receiveCompletion: { completion in
                print("subscription1 completion:\(completion)")

            }, receiveValue: { value in
                self.publisher1.append(value)
                print("subscription1 received:\(value)")

            })
            .store(in: &cancellables)
        
        future
            .flatMap({ nums in
                nums.publisher
            })
            .sink(receiveCompletion: { completion in
                print("subscription2 completion:\(completion)")

            }, receiveValue: { value in
                self.publisher2.append(value)
                print("subscription2 received:\(value)")

            })
            .store(in: &cancellables)
        
       
    }
    
}

 struct FutureView: View {
    
     @StateObject fileprivate var vm = FutureVM()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("publisher 1 ")
           
            List(vm.publisher1, id: \.self) { datum in
                Text("\(datum)")
            }
            
            Divider()
            
            Text("publisher 2")
           
            List(vm.publisher2, id: \.self) { datum in
                Text("\(datum)")
            }
            
        }.task {
            vm.fetchWithFuture()
        }
        
    }
}

#Preview {
    FutureView()
}
