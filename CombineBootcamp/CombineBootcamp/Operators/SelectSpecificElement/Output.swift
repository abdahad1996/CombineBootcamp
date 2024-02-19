//
//  Output.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//

import SwiftUI
import Combine

//MARK: output(at:)
//With the output(at:) operator, you can specify an index and when an item at that index comes through the pipeline it will be republished and the pipeline will finish. If
//you specify a number higher than the number of items that come through the pipeline before it finishes, then nothing is published. (You won’t get any index out-of-
//bounds errors.)

//MARK: output(in:)
//You can also use the output operator to select a range of values that come through the pipeline. This operator says, “I will only republish items that match the index
//between this beginning number and this ending number.”
class OutputVM: ObservableObject {
    
    @Published var selection = ""
    @Published var animals = ["Chimpanzee", "Elephant", "Parrot", "Dolphin", "Pig", "Octopus"]
    
    private var cancellable: AnyCancellable?
    
    func getAnimal(at index: Int = 0) {
        animals.publisher
            .output(at: index)
            .assign(to: &$selection)
    }
}

struct Output: View {
    @StateObject var vm = OutputVM()
    
    var body: some View {
        VStack {
            List(vm.animals, id: \.self) { datum in
                Text(datum)
            }
            Button(action: {
                vm.getAnimal(at: 2)
            }) {
                Text("select index 2")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Capsule().fill(Color.blue))
            }
        }.task {
            vm.getAnimal()
    }
        
    }
}

#Preview {
    Output()
}
