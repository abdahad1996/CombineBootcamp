//
//  ContentView.swift
//  Future
//
//  Created by Abdul Ahad on 31.12.23.
//

import SwiftUI
import Combine

//“The Future publisher will publish only one value and then the pipeline will close.

//WHEN the value is published is up to you. It can publish immediately, be delayed, wait for a user response, etc. But one thing to know about Future is that it ONLY runs one time. You can use the same Future with multiple subscribers. But it still only executes its closure one time and stores the one value it is responsible for publishing.”

//
//let futurePublisher = Future<String, Never> { promise in*/
//  promise(Result.success("👋"))
//  }”

// takes in a result type
// “promise(Result<String, Never>) -> Void”



class futureViewModel:ObservableObject{
    @Published var hello = ""
    @Published var gooodbye = ""
    
    var cancellable = [AnyCancellable]()
    
    func sayHello(){
        Future<String,Never>{
            promise in
            promise(.success("hello world"))
        }.print("hello future : ")
            .assign(to: &$hello)
    }
    
    func sayGoodbye(){
        Future<String,Never>{
            promise in
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                promise(.success("good bye "))

            })
         }.print("good bye future : ")
            .sink { [weak self] message in
                self?.gooodbye = message
            }.store(in: &cancellable)
    }
}




struct futureView: View {
    @StateObject var vm = futureViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            
            Button("tap hello world"){
                vm.sayHello()
            }
            Text(vm.hello)
            
            Button("tap goodbye "){
                vm.sayGoodbye()
            }
            Text(vm.gooodbye)
        }
        .padding()
    }
}

#Preview {
    futureView()
}
