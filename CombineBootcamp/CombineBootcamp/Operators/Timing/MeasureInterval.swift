//
//  Debounce.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 14/02/2024.
//

import SwiftUI
import Combine

///The measureInterval operator will tell you how much time elapsed between one item and another coming through a pipeline. It publishes the timed interval. It will
//not republish the item values coming through the pipeline though.
class MeasureIntervalVM:ObservableObject{
        @Published var speed: TimeInterval = 0.0
        var timeEvent = PassthroughSubject<Void, Never>()
        private var cancellable: AnyCancellable?
    
        init() {
        cancellable = timeEvent
        .measureInterval(using: RunLoop.main)
        .sink { [unowned self] (stride) in
        speed = stride.timeInterval
        }
    }
}
struct MeasureInterval: View {
   @StateObject var vm = MeasureIntervalVM()

    var body: some View {
        VStack {
            Button("Fetch Data") {
                vm.timeEvent.send()
            }
            
            Text("\(vm.speed)")
            
        }
        
    }
    
    
}

#Preview {
    MeasureInterval()
}
