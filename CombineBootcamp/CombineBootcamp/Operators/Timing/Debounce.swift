//
//  Debounce.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 14/02/2024.
//

import SwiftUI
//When a user is typing and backspacing and typing more it could seem like the letters are bouncing back and forth into the pipeline.
//The prefix “de-” means “to remove or lessen”. And so, “debounce” means to “lessen bouncing”. It is used to pause input before being sent down the pipeline.
class DebounceVM:ObservableObject{
    @Published var name = ""
    @Published var nameEntered = ""
    
    init(){
        $name.debounce(for: 2, scheduler: RunLoop.main)
            .print()
            .assign(to: &$nameEntered)
    }
}
struct Debounce: View {
   @StateObject var vm = DebounceVM()

    var body: some View {
        VStack {
            TextField("enter name", text: $vm.name)
                .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
            
            Text(vm.nameEntered)
        }
        
    }
    
    
}

#Preview {
    Debounce()
}
