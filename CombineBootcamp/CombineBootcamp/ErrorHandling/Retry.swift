//
//  Retry.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 23/02/2024.
//

import SwiftUI
import Combine

//As your pipeline is trying to publish items an error could be encountered. Normally the subscriber receives that error. With the retry operator though, the failure
//will not reach the subscriber. Instead, it will have the publisher try to publish again a certain number of times that you specify.
class RetryVM: ObservableObject {
    @Published var webPage = ""
    private var cancellable: AnyCancellable?
    
    func fetch() {
        let url = URL(string: "https://oidutsniatnuomgib.com/")!
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .retry(2)
            .map { (data: Data, response: URLResponse) -> String in
                String(decoding: data, as: UTF8.self)
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [unowned self] completion in
                if case .failure(
                    _) = completion {
                    webPage = "We made 3 attempts to retrieve the webpage and failed."
                }
            }, receiveValue: { [unowned self] html in
                webPage = html
            })
    }
}

struct Retry: View {
    @StateObject var vm = RetryVM()
    var body: some View {
        Text(vm.webPage)
        .padding()
        .task {
            vm.fetch()
        }
    }
}

#Preview {
    Retry()
}
