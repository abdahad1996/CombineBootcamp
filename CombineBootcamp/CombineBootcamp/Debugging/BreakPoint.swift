//
//  BreakPoint.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 24/02/2024.
//

//You can set conditions in your pipelines to have the app break during execution using the breakpoint operator. Note: This is not the same as setting a
//breakpoint in Xcode. Instead, what happens is Xcode will suspend the process of execution because this breakpoint operator is actually raising what’s called a
//SIGTRAP (signal trap) to halt the process. A “signal” is something that happens on the CPU level. Xcode is telling the processor, “Hey, let me know if you run this code
//and this condition is true and halt the process.” When the processor finds your code and the condition is true, it will “trap” the process and suspend it so you can take
//a look in Xcode.
import SwiftUI

class BreakpointVM: ObservableObject {
    @Published var dataToView: [String] = []
    
    func fetch() {
        let dataIn = ["abdul", "Sami", "12", "bilal"]
        _
        = dataIn.publisher
            .breakpoint(
                receiveSubscription: { subscription in
                    print("Subscriber has connected")
                    return false
                },
                receiveOutput: { value in
                    print("Value (\(value)) came through pipeline")
                    return value.contains("12")
                },
                receiveCompletion: { completion in
                    print("Pipeline is about to complete")
                    return false
                }
            )
            .sink(receiveCompletion: { completion in
                print("Pipeline completed")
            }, receiveValue: { [unowned self] item in
                dataToView.append(item)
            })
    }
}

struct BreakPoint: View {
    @StateObject private var vm = BreakpointVM()
    var body: some View {
        List(vm.dataToView, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
    }
}

#Preview {
    BreakPoint()
}
