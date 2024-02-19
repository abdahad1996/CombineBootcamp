//
//  SetFailureType.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//


// MARK: Error-Throwing Pipeline

//let errorPipeline: AnyPublisher<String, Error> =
//["Utah", "Nevada", "Colorado",
// "🧨"
// , "Idaho"].publisher
//    .tryMap { item -> String in
//        if item == "🧨" {
//            throw InvalidValueError()
//        }
//        return item
//    }
//    .eraseToAnyPublisher()


// MARK: Non Error-Throwing Pipeline

//let pipeline: AnyPublisher<String, Never> =
//["Utah", "Nevada", "Colorado",
// "🧨"
// , "Idaho"].publisher
//    .map { item -> String in
//        if item == "🧨" {
//            return "Montana"
//        }
//        return item
//    }
//    .eraseToAnyPublisher()


//Now imagine you want a function that can return either one of these pipelines. They are different types, right? You need a way to make it so their types match up.



//func getPipeline(westernStates: Bool) -> AnyPublisher<String, Error> {
//    if westernStates {
//        return
//        ["Utah", "Nevada", "Colorado",
//         "🧨"
//         , "Idaho"].publisher
//            .tryMap { item -> String in
//                if item == "🧨" {
//                    throw InvalidValueError()
//                }
//                return item
//            }
//            .eraseToAnyPublisher()
//    } else {
//        return
//        ["Vermont", "New Hampshire", "Maine",
//         "🧨"
//         , "Rhode Island"].publisher
//            .map { item -> String in
//                if item == "🧨" {
//                    return "New Hampshire"
//                }
//                return item
//            }
// SET FAILURE TYPE HERE            .setFailureType(to: Error.self)
//            .eraseToAnyPublisher()
//    }
//}


import SwiftUI
import Combine

//The error needs to conform to Identifiable because it is
//needed to work with the SwiftUI alert modifier:
private struct ErrorForAlert: Error, Identifiable {
    let id = UUID()
    let title = "Error"
    var message = "Please try again later."
}

class SetFailureTypeVM: ObservableObject {
    @Published var states: [String] = []
    @Published fileprivate var error: ErrorForAlert?
    
    func getPipeline(NuclearPower: Bool) -> AnyPublisher<String, Error> {
        if NuclearPower {
            return
            ["Pakistan", "USA", "UK",
             "🧨"].publisher
                .tryMap { item -> String in
                    if item == "🧨" {
                        throw ErrorForAlert()
                    }
                    return item
                }
                .eraseToAnyPublisher()
        } else {
            return
            ["Syria", "Iran", "Switzerland",
             "🧨"].publisher
                .map { item -> String in
                    if item == "🧨" {
                        return "Massachusetts"
                    }
                    return item
                }
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    func fetch(NuclearPower: Bool) {
        states.removeAll()
        _
        = getPipeline(NuclearPower: NuclearPower)
            .sink { [unowned self] (completion) in
                if case .failure(let error) = completion {
                    self.error = error as? ErrorForAlert
                }
            } receiveValue: { [unowned self] (state) in
                states.append(state)
            }
    }
}
    
struct SetFailureType: View {
    @StateObject var setFailureTypeVM = SetFailureTypeVM()
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Button(action: {
                    setFailureTypeVM.fetch(NuclearPower: true)
                }) {
                    Text("Nuclear power")
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(Capsule().fill(Color.blue))
                }
                
                Button(action: {
                    setFailureTypeVM.fetch(NuclearPower: false)
                }) {
                    Text("Non Nuclear Power")
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(Capsule().fill(Color.blue))
                }
                
            }
          
            List(setFailureTypeVM.states, id: \.self) { datum in
                Text(datum)
            }
            
        }.task {
            setFailureTypeVM.fetch(NuclearPower: true)
        }.alert(item: $setFailureTypeVM.error) { error in
            Alert(title: Text("Error"), message: Text(error.message))
            }
    }
}

#Preview {
    SetFailureType()
}
