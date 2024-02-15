//
//  CompactMap.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 14/02/2024.
//

import SwiftUI
import Combine

//Use the replaceEmpty operator when you want to show or set some value in the case that nothing came down your pipeline. This could be useful in situations
//where you want to set some default data or notify the user that there was no data.
class ReplaceErrorVM:ObservableObject {
    @Published var data: [String] = []
    
    func fetch() {
        let dataIn = [String]()
        
        _ = dataIn.publisher
            .replaceEmpty(with: "No resuslts")
            .print()
            .sink(receiveValue: { [weak self] value in
                self?.data.append(value)
            })
        
    }
}
struct ReplaceError: View {
    @StateObject var vm = ReplaceErrorVM()
    var body: some View {

        List(vm.data, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
        
    }
}

#Preview {
    ReplaceError()
}
