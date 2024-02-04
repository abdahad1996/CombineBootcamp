//
//  Defer.swift
//  Future
//
//  Created by Abdul Ahad on 31.12.23.
//

import SwiftUI
import Combine

//“The Deferred publisher is pretty simple to implement. You just put another publisher within it like this. The Future publisher will not execute immediately now when it is created because it is inside the Deferred publisher. Even more, it will execute every time a subscriber is attached”

class DeferViewModel:ObservableObject{
    @Published var firstTime = ""
    @Published var secondTime = ""

    let futurePublisher = Deferred{
        Future<String,Never>{promise in
            promise(.success("publisher ran "))
            print("future ran once  ")
        }
    }
    
    func fetch(){
        futurePublisher.assign(to: &$firstTime)
    }
    func runFetchAgain(){
        futurePublisher.assign(to: &$secondTime)
    }
}
 
struct Defer: View {
    @StateObject var vm = DeferViewModel()
    var body: some View {
        VStack{
            Text("first time  \(vm.firstTime)")

            Button("run fetch again "){
                vm.runFetchAgain()
            }
            Text("second time \(vm.secondTime)")
        }.onAppear{
            vm.fetch()
        }
       
    }
}


#Preview {
    Defer()
}
