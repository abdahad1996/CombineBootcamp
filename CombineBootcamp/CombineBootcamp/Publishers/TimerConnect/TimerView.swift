//
//  ContentView.swift
//  TimerConnect
//
//  Created by Abdul Ahad on 02.01.24.
//

import SwiftUI
import Combine

//“The autoconnect operator seen here allows the Timer to automatically start publishing items”


class timerAutoConnectVM:ObservableObject {
    @Published var timerValue = ""
    @Published var interval = 1.0
    var cancellable = Set<AnyCancellable>()
    var dateFormatter = DateFormatter()
    func beginTimer(){
        dateFormatter.dateFormat = "HH:mm:ss"

        Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] timer in
                self?.timerValue = self?.dateFormatter.string(from: timer) ?? "not valid"
            }.store(in: &cancellable)
        
        
    }
    
    func cancelTimer(){
        cancellable.removeAll()
    }
    
}
//“When the connect function is called, the Timer will start to publish. Note: The connect function ONLY works on the publisher itself. So you will have to separate your subscriber from your publisher as you see here.”


class timerConnectVM:ObservableObject {
    @Published var timerValue = ""
     var cancellable = Set<AnyCancellable>()
    var timerCancellable : Cancellable?
    var dateFormatter = DateFormatter()
    var timer = Timer.publish(every: 1, on: .main, in: .common)
    func instatiateTimer(){
        dateFormatter.dateFormat = "HH:mm:ss"

        timer
            .print()
            .sink { [weak self] timer in
                self?.timerValue = self?.dateFormatter.string(from: timer) ?? "not valid"
            }
            .store(in: &cancellable)
        
    }
    func startTimer(){
        instatiateTimer()
        timerCancellable = timer.connect()
    }
    func cancelTimer(){
        timerCancellable?.cancel()
    }
    
}
struct TimerView: View {
    @StateObject var vm = timerConnectVM()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button("START TIMER"){
                vm.startTimer()
            }
            Text("timer \(vm.timerValue)")
            
            Button("stop TIMER"){
                vm.cancelTimer()
            }
        }
        .padding()
    }
}

#Preview {
    TimerView()
}
