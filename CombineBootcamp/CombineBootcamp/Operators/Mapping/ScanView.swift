//
//  ScanView.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//

import SwiftUI
//he scan operator gives you the ability to see the item that was previously returned from the scan closure along with the current one. That is all the operator does.
//From here it is up to you with how you want to use this. In the image above, the current value is appended to the last value and sent down the pipeline.
class ScanVM: ObservableObject {
    @Published var dataToView: [String] = []
    
    func fetch() {
        let dataIn:[String] = ["1","2","3","4","5","6"]
        
       _ = dataIn.publisher
            .scan("0") { (previousReturnedValue, currentValue) in
                previousReturnedValue + " " + currentValue
            }
            .sink { [unowned self] (item) in
                dataToView.append(item)
            }
    }
    
    
}
struct ScanView: View {
    @StateObject var vm = ScanVM()
    var body: some View {
        List(vm.dataToView, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
    }
}

#Preview {
    ScanView()
}
