//
//  SubscribeOn.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//

import SwiftUI

//Use the subscribe(on:) operator when you want to suggest that work be done in the background for upstream publishers and operators. I say “suggest” because
//subscribe(on:) does NOT guarantee that the work in operators will actually be performed in the background. Instead, it affects the thread where publishers get
//their subscriptions (from the subscriber/sink), where they receive the request for how much data is wanted, where they receive the data, where they get cancel
//requests from, and the thread where the completion event happens. (Apple calls these 5 events “operations”.)
//I will show you in more detail how you can see this happening in the following pages.

//When I say “operations”, I specifically mean these 5 events for publishers:
//1. Receive Subscription - This is when a subscriber, like sink or assign,
//says, “Hey, I would like some data now.”
//2. Receive Output - This is when an item is coming through the pipeline
//and this publisher/operator receives it.
//3. Receive Completion - When the pipeline completes, this event occurs.
//4. Receive Cancel - Early in this book, you learned to create a cancellable
//pipeline. This happens when a pipeline is cancelled.
//5. Receive Request - This is where the subscriber says how much data it
//requests (also called “demand”). It is usually either “unlimited” or
//“none”.

//
//Even though subscribe(on:) is added to the pipeline, the
//map operator still performs on the main thread. So you can
//see that this operator does NOT guarantee that work in
//operators will be performed in the background.
//But the 5 operations all perform in the background.
class SubscribeONVM: ObservableObject {
    @Published var dataToView: [String] = []
    func fetch() {
        let dataIn = ["Which", "thread", "is", "used?"]
        _
        = dataIn.publisher
            .map { item in
                print("map: Main thread? \(Thread.isMainThread)")
                return item
            }
            .handleEvents(receiveSubscription: { subscription in
                print("receiveSubscription: Main thread? \(Thread.isMainThread)")
            }, receiveOutput: { item in
                print("\(item) - receiveOutput: Main thread? \(Thread.isMainThread)")
            }, receiveCompletion: { completion in
                print("receiveCompletion: Main thread? \(Thread.isMainThread)")
            }, receiveCancel: {
                print("receiveCancel: Main thread? \(Thread.isMainThread)")
            }, receiveRequest: { demand in
                print("receiveRequest: Main thread? \(Thread.isMainThread)")
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] item in
                print("sink: Main thread? \(Thread.isMainThread)")
                dataToView.append(item)
            }
    }
}
struct SubscribeOn: View {
    @StateObject private var vm = SubscribeONVM()
    var body: some View {
        List(vm.dataToView, id: \.self) { item in
        Text(item)
        }.onAppear {
            vm.fetch()
            }
    }
}

#Preview {
    SubscribeOn()
}
