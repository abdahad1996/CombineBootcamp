//
//  ContentView.swift
//  CancelAllPipeLines
//
//  Created by Abdul Ahad on 28.12.23.
//

import SwiftUI
import Combine

private class CancelAllPipeLinesViewModel:ObservableObject{
    @Published var firstName:String = ""
    @Published var firstNameValidation:String = ""
    @Published var lastName:String = ""
    @Published var lastNameValidation:String = ""
    private var validationCancellable: Set<AnyCancellable> = []
    
    init() {
        $firstName.map{$0.isEmpty ? "required" : ""}.sink { [unowned self] value in
            self.firstNameValidation = value
        }.store(in: &validationCancellable)
        
        $lastName.map{$0.isEmpty ? "required" : ""}.sink { [unowned self] value in
            self.lastNameValidation = value
        }.store(in: &validationCancellable)
    }
    func cancelAllPipelines(){
        validationCancellable.removeAll()
    }
}

private struct CancelAllPipeLinesView: View {
    @StateObject var vm = CancelAllPipeLinesViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Cancel all pipelines!")
            TextField("first name",text: $vm.firstName)
            Text(vm.firstNameValidation)
            TextField("last name",text: $vm.lastName)
            Text(vm.lastNameValidation)
            
            Button("cancell all pipeline") {
                vm.cancelAllPipelines()
            }
        }
        .padding()
    }
}

#Preview {
    CancelAllPipeLinesView()
}
