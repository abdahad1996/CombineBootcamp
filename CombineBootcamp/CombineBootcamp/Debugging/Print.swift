//
//  BreakPoint.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 24/02/2024.
//

//The print operator is one of the quickest and easiest ways to get information on what your pipeline is doing. Any publishing event that occurs will be logged by the
//print operator on your pipeline.

import SwiftUI

fileprivate struct InvalidError : Error {
    
}
class PrintVM: ObservableObject {
    @Published var dataToView: [String] = []
    
    func fetch() {
        let dataIn = ["abdul", "Sami", "12", "bilal"]
        _
         = dataIn.publisher
            .tryMap { item in
                if item == "blabla" {
                    throw InvalidError()
                }
                return item
            }
            .print()
            .sink(receiveCompletion: { completion in
                print("Pipeline completed")
            }, receiveValue: { [unowned self] item in
                dataToView.append(item)
            })
    }
}

struct Print: View {
    @StateObject private var vm = PrintVM()
    var body: some View {
        
        List(vm.dataToView, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
    }
}

#Preview {
    Print()
}
