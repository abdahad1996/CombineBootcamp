//
//  MapError.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 23/02/2024.
//

import SwiftUI
import Combine

//You can have several parts of your pipeline throw errors. The mapError operator allows a central place to catch them before going to the subscriber and gives you a
//closure to throw a new error. For example, you might want to be able to receive 10 different types of errors and then throw one generic error instead.

//You can see that mapError receives an error and the
//closure is set to ALWAYS return a UrlResponseErrors
//type. (See the previous page for this object.)
//So mapError can receive many different types of errors
//and you control the type that gets sent downstream.
//If there is an error that enters the sink subscriber, you
//already know it will be of type UrlResponseErrors
//because that is what the mapError is returning:

//Note: In the mapError example I’m assuming if the error received is NOT a
//UrlResponseErrors type then an error came from the decode operator.
//But remember, the dataTaskPublisher could also throw an error.
//So if you do use mapError, be sure to check the type of the error received
//so you know where it’s coming from before changing it in some way.


struct ErrorForView: Error, Identifiable {
    let id = UUID()
    var message = ""
}
enum UrlResponseErrors: String, Error {
    case unknown = "Response wasn't recognized"
    case clientError = "Problem getting the information"
    case serverError = "Problem with the server"
    case decodeError = "Problem reading the returned data"
}

struct ToDo: Identifiable, Decodable {
    var id: Int
    var title: String
    var completed: Bool
}

class MapErrorVM: ObservableObject {
    @Published var todos: [ToDo] = []
    @Published var error: ErrorForView?
    private var cancellable: AnyCancellable?
    func fetch() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users/1/todos")!
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw UrlResponseErrors.unknown
                }
                if (400...499).contains(httpResponse.statusCode) {
                    throw UrlResponseErrors.clientError
                }
                if (500...599).contains(httpResponse.statusCode) {
                    throw UrlResponseErrors.serverError
                }
                return data
            }
            .decode(type: [ToDo].self, decoder: JSONDecoder())
            .mapError { error -> UrlResponseErrors in
            if let responseError = error as? UrlResponseErrors {
                return responseError
            } else {
                return UrlResponseErrors.decodeError
            }
        }
        .receive(on: RunLoop.main)
        .sink { [unowned self] completion in
            if case .failure(let error) = completion {
                self.error = ErrorForView(message: error.rawValue)
            }
        } receiveValue: { [unowned self] data in
            todos = data
        }
    }
}

struct MapError: View {
    @StateObject private var vm = MapErrorVM()
    var body: some View {
        List(vm.todos) { todo in
            Label(title: { Text(todo.title) },
                  icon: { Image(systemName: todo.completed ?
                                "checkmark.circle.fill" :
                                    "circle") })
        }
    }
    
}

#Preview {
    MapError()
}
