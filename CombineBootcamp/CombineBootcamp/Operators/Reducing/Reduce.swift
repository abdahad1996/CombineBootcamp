//
//  Reduce.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//

import SwiftUI

//The reduce operator gives you a closure to examine not only the current item coming down the pipeline but also the previous item that was returned from the
//reduce closure. After the pipeline finishes, the reduce function will publish the last item remaining.
//If you’re familiar with the scan operator you will notice the functions look nearly identical. The main difference is that reduce will only publish one item at the end.


class ReduceVM: ObservableObject {
    @Published var total = 0
    
    func fetch() {
        let dataIn = [1,4,2,6,2,1]
       
        dataIn.publisher
            .reduce(0) { (longestNameSoFar, nextName) in
                
                return longestNameSoFar + nextName
            }
            .assign(to: &$total)
    }
}

struct Reduce: View {
    @StateObject var reduceVM = ReduceVM()
    var body: some View {
        Text("Total \(reduceVM.total)")
            .task {
                reduceVM.fetch()
            }
    }
}

#Preview {
    Reduce()
}
