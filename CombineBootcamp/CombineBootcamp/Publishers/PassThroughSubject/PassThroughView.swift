//
//  ContentView.swift
//  PassThroughSubject
//
//  Created by Abdul Ahad on 01.01.24.
//

import SwiftUI
import Combine

//“The PassthroughSubject is much like the CurrentValueSubject except this publisher does NOT hold on to a value.
//It simply allows you to create a pipeline that you can send values through.
//This makes it ideal to send “events” from the view to the view model. You can pass values through the PassthroughSubject and right into a pipeline.

//“This Passthrough publisher will not retain a value. It simply expects a String.  If there is a subscriber attached to it then it will send any received values through the pipeline to the subscriber”


class PassThroughViewModel:ObservableObject{
    enum CCStatus{
        case notChecked
        case okay
        case invalid
    }
    @Published var cc:String = ""
    @Published var status:CCStatus = .notChecked
    let creditCardValidator = PassthroughSubject<String,Never>()
    
    init() {
        let learnType = _cc
        creditCardValidator.map{ cardVal in
            if cardVal.isEmpty{
                return CCStatus.notChecked
            }
            if cardVal.count == 16 {
                return CCStatus.okay
            }else{
                return CCStatus.invalid
            }
            
        }.print()
            .assign(to: &$status)
    }
}

struct PassThroughView: View {
    @StateObject var vm = PassThroughViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Spacer()
            HStack{
                TextField("please enter valid cards ", text: $vm.cc)
                Group{
                    switch vm.status {
                    case .okay:
                        Image(systemName: "checkmark.circle.fill")    .foregroundColor(.green)
                    case .invalid:                       
                        Image(systemName: "x.circle.fill")                            .foregroundColor(.red)
                    default:  EmptyView()

                    }
                }
                
            }
            Button("check validation"){
                vm.creditCardValidator.send(vm.cc)
            }
         }
        .padding()
    }
}

#Preview {
    PassThroughView()
}
