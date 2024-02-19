//
//  IgnoreOutPut.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//

import SwiftUI

//This operator is pretty straightforward in its purpose. Anything that comes down the pipeline will be ignored and will never reach a subscriber. A sink subscriber will
//still detect when it is finished or if it has failed though.

class IgnoreOutputVM: ObservableObject {
    
    @Published var dataToView: [String] = []
    @Published var dataToView2: [String] = []
    
    func fetch() {
        
        let dataIn = ["Value 1", "Value 2", "Value 3"]
        
        _
        = dataIn.publisher
            .sink { [unowned self] (item) in
                dataToView.append(item)
            }
        
        _
        = dataIn.publisher
            .ignoreOutput()
            .sink(receiveCompletion: { [unowned self] completion in
                dataToView2.append("Pipeline Finished")
            }, receiveValue: { [unowned self]
                _
                in
                dataToView2.append("You should not see this.")
            })
    }
}
struct IgnoreOutPut: View {
    
    @StateObject var ignoreOutputVM = IgnoreOutputVM()
    var body: some View {
        VStack {
            Section(header: Text("list 1").bold().font(.title), footer: Text("end list").font(.footnote)) {
                ForEach(ignoreOutputVM.dataToView, id: \.self) { datum in
                    Text(datum)
                }
            }
            
            Section(header: Text("list 2").bold().font(.title), footer: Text("end list 2").font(.footnote)) {
                ForEach(ignoreOutputVM.dataToView2, id: \.self) { datum in
                    Text(datum)
                }
            }
        }.task {
            ignoreOutputVM.fetch()
        }
    }
}

#Preview {
    IgnoreOutPut()
}
