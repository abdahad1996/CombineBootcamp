//
//  Debounce.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 14/02/2024.
//

import SwiftUI
import Combine

//You can add a delay on a pipeline to pause items from flowing through. The delay only works once though. What I mean is that if you have five items coming through
//the pipeline, the delay will only pause all five and then allow them through. It will not delay every single item that comes through.
class DelayVM:ObservableObject{
    @Published var data = ""
        var delaySeconds = 1
        @Published var isFetching = false
        var cancellable: AnyCancellable?
        func fetch() {
        isFetching = true
        let dataIn = ["Value 1", "Value 2", "Value 3"]
        cancellable = dataIn.publisher
        .delay(for: .seconds(delaySeconds), scheduler: RunLoop.main)
        .first()
        .sink { [unowned self] completion in
        isFetching = false
        } receiveValue: { [unowned self] firstValue in
        data = firstValue
        }
    }
}
struct Delay: View {
   @StateObject var vm = DelayVM()

    var body: some View {
        VStack {
            Button("Fetch Data") {
            vm.fetch()
            }
            if vm.isFetching {
            ProgressView()
            } else {
            Text(vm.data)
            }
        }
        
    }
    
    
}

#Preview {
    Delay()
}
