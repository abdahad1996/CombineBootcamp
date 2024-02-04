//
//  ContentView.swift
//  Empty&Fail
//
//  Created by Abdul Ahad on 30.12.23.
//

import Foundation
import SwiftUI
import Combine

//“ Fail is a publisher that publishes a failure (with an error). Why would you need this? Well, you can put publishers inside of properties and functions. And within the property getter or the function body, you can evaluate input. If the input is valid, return a publisher, else return a Fail publisher. The Fail publisher will let your subscriber know that something failed”
class Validation{
    static func validateAge(age:Int) -> AnyPublisher<Int,InvalidAgeError>{
        if age < 0 {
            return Fail(error: InvalidAgeError.lessThanZero)
                .eraseToAnyPublisher()
        }else if age > 100{
            return Fail(error: InvalidAgeError.moreThanHundred)
                .eraseToAnyPublisher()
        }else{
            //Because a Just instance emits a single element, it is guaranteed to not complete with an error. This means that its Failure type is Never. The problem is that the Failure type doesn't match that of the publisher the InvalidAgeError
            
//            As the name suggests, the setFailureType operator replaces the Failure type of the upstream publisher with a type you define. In this example, we use the setFailureType operator to replace the Failure type of the Just instance, Never, with InvalidAgeError
            
            //The only requirement is that the type you pass to the setFailureType(to:) method conforms to the Error protocol. The setFailureType operator should only be applied to a publisher that cannot fail, that is, a publisher with a Failure type of Never. If the upstream publisher can fail, then you need to map the errors of the upstream publisher using the mapError operator
            return Just(age)
                .setFailureType(to: InvalidAgeError.self)
                .eraseToAnyPublisher()
        }
        
    }
}
enum InvalidAgeError:String, Error,Identifiable {
    var id : UUID{
        return UUID()
    }
    
    case lessThanZero = "lessThanZero"
    case moreThanHundred = "moreThanHundred"
}
class FailVM:ObservableObject{
    @Published var age = 0
    @Published  var error : InvalidAgeError?
//    @Published  var showError : Bool = false

    var cancellable = [AnyCancellable]()
//    init(){
//        $error
//            .map { value in
//                guard let error = value else{
//                    return false
//                }
//                return true
//            }
//            .sink { [weak self ] showError in
//            self?.showError = showError
//        }.store(in: &cancellable)
//        
//    }
    func save(age:Int) {
        
        Validation.validateAge(age: age).sink {[weak self] completion in
            switch completion {
            case .failure(let err):
                self?.error = err
            case .finished:
                print("finished subscription")
            }
        } receiveValue: {[weak self] value in
            self?.age = value
        }.store(in: &cancellable)
    }
    
}

struct FailContentView: View {
    @StateObject var vm = FailVM()
    @State var age = ""
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, worldss!")
            TextField("Enter age", text: $age)
            //             List(vm.throwableData, id: \.self) { item in
            Text(age)
        Button("save"){
            vm.save(age: Int(age) ?? -1)
            
            
        }
        }.alert(item: $vm.error) { error in            Alert(title: Text("Invalid Age"), message: Text(error.rawValue))}
        
       
    }
}

#Preview {
    FailContentView()
}




