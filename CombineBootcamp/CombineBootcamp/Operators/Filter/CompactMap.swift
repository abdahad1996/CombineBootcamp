//
//  CompactMap.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 14/02/2024.
//

import SwiftUI
import Combine

//The compactMap operator gives you a convenient way to drop all nils that come through the pipeline. You are even given a closure to evaluate items coming through
//the pipeline and if you want, you can return a nil. That way, the item will also get dropped.

class CompactMapVM:ObservableObject {
    @Published var dataWithoutNils: [String] = []
    
    func fetch() {
    let dataIn = ["Value 1", nil, "Value 3", nil, "Value 5", "Invalid"]
        
    _ = dataIn.publisher
            .compactMap{ item in
                if item == "Invalid" {
                    return nil // Will not get republished
                }
                return item
            }
            .sink { [unowned self] (item) in
                self.dataWithoutNils.append(item)
            }
        }
    }

struct CompactMap: View {
    @StateObject var vm = CompactMapVM()
    var body: some View {

        List(vm.dataWithoutNils, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
        
    }
}

#Preview {
    CompactMap()
}
