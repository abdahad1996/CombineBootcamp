//
//  KeyValueObserving.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 25/02/2024.
//

import SwiftUI
import Combine

//Combine provides a publisher for any property of an object that is KVO (Key-Value Observing)-compliant.

//KVO has always been an essential component of Objective-C. A large number of properties from Foundation, UIKit and AppKit classes are KVO-compliant. Therefore, you can observe their changes using the KVO machinery.

//There are many other framework classes exposing KVO-compliant properties. Just use publisher(for:) with a key path to a KVO-compliant property, and voilà! You get a publisher capable of emitting value changes

//You can also use Key-Value Observing in your own code, provided that:
//• Your objects are classes (not structs) and conform to NSObject,
//• You mark the properties to make observable with the @objc dynamic attributes.


class KVOObject: NSObject {
    // 2
    @objc dynamic var integerProperty: Int = 0
}

class VM:ObservableObject{
     @Published var count = 0
    let obj = KVOObject()
    var cancellable:AnyCancellable?
    
    func fetch(){
        cancellable = obj.publisher(for: \.integerProperty)
            .sink { [weak self] in
                print("integerProperty changes to \($0)")
                self?.count = $0
            }
    }
    
    func increaseCount(){
        obj.integerProperty += 1
    }
    func decreaseCount(){
        obj.integerProperty -= 1
    }
}
struct KeyValueObserving: View {
@StateObject var vm = VM()
    
    var body: some View {
        VStack {
            Text("\(vm.count)")
                .task {
                    vm.fetch()
            }
            Button(action: {
                vm.increaseCount()
            }) {
                Text("increase")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Capsule().fill(Color.blue))
            }
            
            Button(action: {
                vm.decreaseCount()
            }) {
                Text("decrease")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Capsule().fill(Color.blue))
            }
        }
    }
}

#Preview {
    KeyValueObserving()
}

#Preview {
    VC()
}

import UIKit

class VC:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
}
