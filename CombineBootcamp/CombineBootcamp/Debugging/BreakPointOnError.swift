//
//  BreakPoint.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 24/02/2024.
//

//Use the breakpointOnError when you are interested in having Xcode pause execution when ANY error is thrown within your pipeline. While developing, you may
//have a pipeline that you suspect should never throw an error so you don’t add any error handling on it. Instead, you can add this operator to warn you if your

//pipeline did throw an error when you were not expecting it to.

//Your assumption is that this
//should never happen. If it does
//happen, Xcode will pause
//execution with the debugger.

import SwiftUI

fileprivate struct InvalidError : Error {
    
}
class BreakpointErrorVM: ObservableObject {
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
            .breakpointOnError()
            .sink(receiveCompletion: { completion in
                print("Pipeline completed")
            }, receiveValue: { [unowned self] item in
                dataToView.append(item)
            })
    }
}

struct BreakPointError: View {
    @StateObject private var vm = BreakpointErrorVM()
    var body: some View {
        
        List(vm.dataToView, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
    }
}

#Preview {
    BreakPointError()
}
