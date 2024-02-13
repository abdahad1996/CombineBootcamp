//
//  DropUntil.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 13/02/2024.
//

import SwiftUI
import Combine

//The idea here is that you have a
//publisher that may or may not be
//sending out data. But it won’t reach
//the subscriber (or ultimately, the UI)
//unless a second publisher sends out
//data too.
//The second publisher is what opens
//the flow of data on the first publisher.
private class DropUntilOutputFromViewModel: ObservableObject {
    @Published var data: [String] = []
    var startPipeline = PassthroughSubject<Bool, Never>()
    var cancellables: [AnyCancellable] = []
    let timeFormatter = DateFormatter()
    init() {
        timeFormatter.timeStyle = .medium
        Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .drop(untilOutputFrom: startPipeline)
            .map { datum in
                return self.timeFormatter.string(from: datum)
            }
            .sink{ [unowned self] (datum) in
                data.append(datum)
            }
            .store(in: &cancellables)
    }
}

struct DropUntil: View {
    @StateObject private var vm = DropUntilOutputFromViewModel()
    var body: some View {
        
        
        VStack {
            Button(action: {
                vm.cancellables.removeAll()
            }) {
                Text("close pipeline")
                    .padding()
                    .background(Capsule().stroke(Color.blue, lineWidth: 2))
            }
            List(vm.data, id: \.self) { datum in
                Text(datum)
            }
            Button(action: {
                vm.startPipeline.send(true)
            }) {
                Text("start pipeline")
                    .padding()
                    .background(Capsule().stroke(Color.blue, lineWidth: 2))
            }
        }
    }
}

#Preview {
    DropUntil()
}
