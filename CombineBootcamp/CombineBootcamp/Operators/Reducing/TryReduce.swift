//
//  Reduce.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//

import SwiftUI

//The tryReduce will only publish one item, just like reduce will, but you also have the option to throw an error. Once an error is thrown, the pipeline will then finish.
//Any try operator marks the downstream pipeline as being able to fail which means that you will have to handle potential errors in some way.


struct ZeroError: Error, Identifiable {
    let id = UUID()
    let message = "We found an item that was not nil."
}

class TryReduceVM: ObservableObject {
    @Published var total = 0
    @Published var error: ZeroError?
    
    func fetch() {
        let dataIn = [1,4,2,6,2,1,0]
        
      _ = dataIn.publisher
            .tryReduce(0) { (longestNameSoFar, nextName) in
                if nextName == 0 {
                    throw ZeroError()
                }
                return longestNameSoFar + nextName
            }
            .sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    self.error = error as? ZeroError
                }
            } receiveValue: { [unowned self] totalVal in
                total = totalVal
            }
    }
}

struct TryReduce: View {
    @StateObject var tryReduceVM = TryReduceVM()
    var body: some View {
        Text("Total \(tryReduceVM.total)")
            .task {
                tryReduceVM.fetch()
            }
            .alert(item: $tryReduceVM.error) { error in
            Alert(title: Text("Error"), message: Text(error.message))
            }
    }
}

#Preview {
    Reduce()
}
