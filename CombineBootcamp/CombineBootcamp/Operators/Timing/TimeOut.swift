//
//  Debounce.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 14/02/2024.
//

import SwiftUI
import Combine

//You don’t want to make users wait too long while the app is retrieving or processing data. So you can use the timeout operator to set a time limit. If the pipeline takes
//too long you can automatically finish it once the time limit is hit. Optionally, you can define an error so you can look for this error when the pipeline finishes.
//This way when the pipeline finishes, you can know if it was specifically because of the timeout and not because of some other condition.

struct TimeoutError: Error, Identifiable {
    let id = UUID()
    let title = "Timeout"
    let message = "Please try again later."
}

class TimeoutVM: ObservableObject {
    
    @Published var dataToView: [String] = []
    @Published var isFetching = false
    @Published var timeoutError: TimeoutError?
    private var cancellable: AnyCancellable?
    
    func fetch() {
        isFetching = true
            let url = URL(string: "https://bigmountainstudio.com/nothing")!
            cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .timeout(.seconds(0.1), scheduler: RunLoop.main, customError: { URLError(.timedOut) })
            .map { $0.data }
            .decode(type: String.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [unowned self] completion in
                
            isFetching = false
            
            if case .failure(URLError.timedOut) = completion {
            timeoutError = TimeoutError()
                }
            }, receiveValue: { [unowned self] value in
            dataToView.append(value)
            })
    }
}

struct Timeout: View {
    @StateObject private var vm = TimeoutVM()

    var body: some View {
        VStack{
            Button("Fetch Data") {
            vm.fetch()
            }
            if vm.isFetching {
            ProgressView("Fetching...")
            }
        }.alert(item: $vm.timeoutError) { timeoutError in
            Alert(title: Text(timeoutError.title), message: Text(timeoutError.message))
            }
        
    }
}

#Preview {
    Timeout()
}
