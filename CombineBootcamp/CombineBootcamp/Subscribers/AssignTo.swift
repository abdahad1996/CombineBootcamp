//
//  AssignTo.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 19/02/2024.
//

import SwiftUI

//MARK: assign(to:)
//The assign(to:) subscriber receives values and directly assigns the value to a @Published property. This is a special subscriber that works with published
//properties. In a SwiftUI app, this is a very common subscriber.

// you don’t have to keep a reference to an AnyCancellable type.
//This is because Combine will automatically handle this for you.
//This feature is exclusive to just this subscriber.
//When this view model is de-initialized and then the @Published
//properties de-initialize, the pipeline will automatically be canceled.
class AssignToVM: ObservableObject {
    @Published var name = ""
    @Published var greeting = ""
    init() {
        $name
            .map { [unowned self] name in
                formatGreeting(name)
            }
            .assign(to: &$greeting)
    }
    func fetch() {
        name = "abdul"
    }
    
    func formatGreeting(_ name:String) -> String{
        return  "Hello " + name
    }
}
struct AssignTo: View {
    @StateObject var vm = AssignToVM()
    var body: some View {
        Button(action: {
            vm.fetch()
        }) {
            Text("fetch greeting")
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal)
                .background(Capsule().fill(Color.blue))
        }
        Text(vm.greeting)
    }
}

#Preview {
    AssignTo()
}
