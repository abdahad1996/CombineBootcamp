//
//  FutureRunsOnce.swift
//  Future
//
//  Created by Abdul Ahad on 31.12.23.
//

import SwiftUI
import Combine

// future only runs once so the second time it will not executre but be reused

class RunsOnceViewModel:ObservableObject{
    @Published var firstTime = ""
    @Published var secondTime = ""

    let futurePublisher = Future<String,Never>{promise in
        promise(.success("publisher ran "))
       print("future ran once ")
    }
    
    func fetch(){
        futurePublisher.assign(to: &$firstTime)
    }
    func runFetchAgain(){
        futurePublisher.assign(to: &$secondTime)
    }
}

//future runs once only
struct FutureRunsOnce: View {
    @StateObject var vm = RunsOnceViewModel()
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
    FutureRunsOnce()
}
