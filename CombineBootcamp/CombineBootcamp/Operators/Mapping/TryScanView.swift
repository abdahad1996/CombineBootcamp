//
//  ScanView.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//

import SwiftUI
//The tryScan operator works just like the scan operator, it allows you to examine the last item that the scan operator’s closure returned. In addition to that, it allows
//you to throw an error. Once this happens the pipeline will finish.


struct InvalidValueFoundError: Error {
    let message = "Invalid value was found: "
}
class TryScanVM: ObservableObject {
    @Published var dataToView: [String] = []
    
    func fetch() {
        let dataIn:[String] = ["1","2","3","4","5","6","Error"]
        
       _ = dataIn.publisher
            .tryScan("0") { (previousReturnedValue, currentValue) in
                if currentValue.contains("Error"){
                    throw InvalidValueFoundError()
                }
                return previousReturnedValue + " " + currentValue
            }
            .sink { [unowned self] (completion) in
                if case .failure(let error) = completion {
                    if let err = error as? InvalidValueFoundError {
                        dataToView.append(err.message + "invalidValue")
                    }
                }
            } receiveValue: { [unowned self] (item) in
                dataToView.append(item)
            }
    }
    
    
}
struct TryScanView: View {
    @StateObject var tryScanVM = TryScanVM()
    var body: some View {
        List(tryScanVM.dataToView, id: \.self) { datum in
            Text(datum)
        }.task {
            tryScanVM.fetch()
        }
    }
}

#Preview {
    TryScanView()
}
