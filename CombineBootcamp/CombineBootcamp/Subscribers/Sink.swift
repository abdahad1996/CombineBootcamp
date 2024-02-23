//
//  Sink.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 19/02/2024.
//

import SwiftUI
import Combine

//MARK: SINK
//The sink subscriber will allow you to just receive values and do anything you want with them. There is also an option to run code when the pipeline completes,
//whether it completed from an error or just naturally.

//MARK: sink(receiveValue:)
//You can ONLY use
//sink(receiveValue:) on non-error-
//throwing pipelines.


//MARK: Sink Completion
// you get a completion which contains
//finished
//failure



struct NumberFiveError: Error {
    
}
class SinkVM: ObservableObject {
    @Published var data = ""
    @Published var isProcessing = false
    @Published var guestList = [String]()
    @Published var errorMessage = "cannot have numbers greater than 5."
    @Published var showErrorAlert = false
    
    var cancellables: Set<AnyCancellable> = []
    
    func fetchCompletion() {
        isProcessing = true
        [1,2,3,4,5].publisher
            .delay(for: 1, scheduler: RunLoop.main)
            .sink { [unowned self] (completion) in
                isProcessing = false
            } receiveValue: { [unowned self] (value) in
                data = data.appending(String(value))
            }
            .store(in: &cancellables)
    }
    
    func fetchCompletionWithError() {
        isProcessing = true
        [1,2,3,4,5,6].publisher
            .tryMap { (value:Int) in
                if value > 5 {
                    throw NumberFiveError()
                }
                return String(value)
            }
            .delay(for: 1, scheduler: RunLoop.main)
            .sink { [unowned self] (completion) in
                isProcessing = false
                switch completion {
                case .failure(_):
                    showErrorAlert.toggle()
                case .finished:
                    print(completion)
                }
            } receiveValue: { [unowned self] (value) in
                data = data.appending(String(value))
            }
            .store(in: &cancellables)
    }
    
    func fetchRecieveValue() {
        let dataIn = ["Jordan", "Chase", "Kaya", "Shai", "Novall", "Sarun"]
        _
        = dataIn.publisher
            .sink { [unowned self] (item) in
                guestList.append(item)
            }
    }
}

struct Sink: View {
    @StateObject var vm = SinkVM()
    var body: some View {
        VStack
        {
            Button(action: {
                vm.fetchRecieveValue()
            }) {
                Text("fetchRecieveValue")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Capsule().fill(Color.blue))
            }
            
            
            List(vm.guestList, id: \.self) { datum in
                Text(datum)
            }
            
            
            Button(action: {
                vm.fetchCompletion()
            }) {
                Text("fetchRecieveCompletion")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Capsule().fill(Color.blue))
            }
            Divider()
            Text(vm.data)
            
            
        }.alert(isPresented: $vm.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(vm.errorMessage))
        }
    }
}

#Preview {
    Sink()
}
