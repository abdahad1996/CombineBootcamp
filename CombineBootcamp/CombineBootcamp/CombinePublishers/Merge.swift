//
//  Merge.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 22/02/2024.
//

import SwiftUI
import Combine

//Pipelines that send out the same type can be merged together so items that come from them will all come together and be sent down the same pipeline to the
//subscriber. Using the merge operator you can connect up to eight publishers total.

class MergeVM: ObservableObject {
    
    @Published var data: [String] = []
    func fetch() {
        let shirt = ["num 7", "num 8"]
        let names = ["abdul", "kamal", "kampnar", "bear"]
        let numbers = ["1", "2", "3"]
        _
        = shirt.publisher
            .merge(with: names.publisher, numbers.publisher)
            .sink { [unowned self] item in
                data.append(item)
            }
    }
}
struct Merge: View {
    @StateObject var vm = MergeVM()
    var body: some View {
         
        List(vm.data, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
    }
}

#Preview {
    Merge()
}
