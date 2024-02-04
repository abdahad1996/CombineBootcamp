//
//  ContentView.swift
//  CurrentValueSubject
//
//  Created by Abdul Ahad on 29.12.23.
//

import SwiftUI
import Combine
//“This publisher is used mainly in non-SwiftUI apps but you might have a need for it at some point. In many ways, this publisher works like @Published properties (or rather, @Published properties work like the CurrentValueSubject publisher).

// It’s a publisher that holds on to a value (current value) and when the value changes, it is published and sent down a pipeline when there are subscribers attached to the pipeline.

// If you are going to use this with SwiftUI then there is an extra step you will have to take so the SwiftUI view is notified of changes objectWillChange.send()”

//    var subject = CurrentValueSubject<Bool,Never>(false)

// “The newValue will ALWAYS equal the current value. Unlike @Published properties, this pipeline runs AFTER the current value has been set”

// this doesn't work CurrentValueSubject value gets updated and then our pipeline is run so the value from pipeline and the CurrentValueSubject are same
class CurrentValueSubjectViewModel1:ObservableObject{
    var selection = CurrentValueSubject<String,Never>("no Name Selected")
    var selectionSame = CurrentValueSubject<Bool,Never>(false)
    var cancellable : 
    [AnyCancellable] = []
    init() {
        _ =  selection.map{ [weak self] newVal in
          print("selection value = \(self?.selection.value)")
          print("new value = \(newVal)")
            return newVal == self?.selection.value
        }.sink { [weak self] isAlreadySelected in
            print("isAlreadySelected value = \(isAlreadySelected)")
            print("selectionSame value = \(self?.selectionSame.value)")
            self?.selectionSame.value = isAlreadySelected
            self?.objectWillChange.send()
        }.store(in: &cancellable)
    }
}
class CurrentValueSubjectViewModel2:ObservableObject{
   @Published var selection = "no Name Selected"
    var selectionSame = CurrentValueSubject<Bool,Never>(false)
    var cancellable :
    [AnyCancellable] = []
    init() {
      let cancel =  $selection.map{ [weak self] newVal in
          print("selection value = \(self?.selection)")
          print("new value = \(newVal)")
            return newVal == self?.selection
        }.sink { [weak self] isAlreadySelected in
            print("isAlreadySelected value = \(isAlreadySelected)")
            print("selectionSame value = \(self?.selectionSame.value)")
            self?.selectionSame.value = isAlreadySelected
            self?.objectWillChange.send()
        }.store(in: &cancellable)
    }
}

//in piblisher the pipeline is run first and then the value is set hence we can compare
struct CurrentValueSubjectView: View {
    @StateObject var vm = CurrentValueSubjectViewModel2()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, \(vm.selection)!").foregroundStyle(vm.selectionSame.value ? .red : .green)
            Button("select abdul"){
                vm.selection = "abdul"
            }
            
            Button("select usman"){
                vm.selection = "usman"
            }
        }
        .padding()
    }
}

#Preview {
    CurrentValueSubjectView()
}
