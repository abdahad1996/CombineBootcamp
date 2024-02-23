//
//  Merge.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 22/02/2024.
//

import SwiftUI
import Combine

//You use switchToLatest when you have a pipeline that has publishers being sent downstream. If you looked at the flatMap operator you will understand this
//concept of a publisher of publishers. Instead of values going through your pipeline, it’s publishers. And those publishers are also publishing values on their own. With
//the flatMap operator, you can collect ALL of the values these publishers are emitting and send them all downstream.
//But maybe you don’t want ALL of the values that ALL of these publishers emit. Instead of having these publishers run at the same time, maybe you want just the
//latest publisher that came through to run and cancel out all the other ones that are still running that came before it.
//And that is what the switchToLatest operator is for. It’s kind of similar to combineLatest, where only the last value that came through is used. This is using the
//last publisher that came through.


fileprivate struct NameResult: Decodable {
    var name = ""
    var gender = ""
    var probability = 0.0
}
class SwitchToLatestVM: ObservableObject {
    @Published var names = ["Kelly", "Madison", "Pat", "Alexus", "Taylor", "Tracy"]
    @Published fileprivate var nameResults: [NameResult] = []
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchNameResults() {
        names.publisher
            .map { name -> (String, URL) in
                (name, URL(string: "https://api.genderize.io/?name=\(name)")!)
            }
            .map { (name, url) -> AnyPublisher<NameResult, Never> in
                URLSession.shared.dataTaskPublisher(for: url)
                    .map { (data: Data, response: URLResponse) in
                        data
                    }
                    .decode(type: NameResult.self, decoder: JSONDecoder())
                    .replaceError(with: NameResult(name: name, gender: "Undetermined"))
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .receive(on: RunLoop.main)
            .sink { [unowned self] nameResult in
                nameResults.append(nameResult)
            }
            .store(in: &cancellables)
    }
}
struct SwitchToLatest: View {
    @StateObject var vm = SwitchToLatestVM()
    var body: some View {
        VStack(spacing: 20) {
            Text("Names")
            HStack(spacing: 20) {
              
                List(vm.names, id: \.self) { datum in
                    Text(datum)
                }
                
              
                
               
                
            }
            Text("Genders")
            List(vm.nameResults, id: \.name) { datum in
                
                Text("\(datum.name) \(datum.gender)")
            }
        }
       
            .task {
                vm.fetchNameResults()
            }
    }
}

#Preview {
    Group {
        SwitchToLatest()
                  .previewLayout(PreviewLayout.sizeThatFits)
                  .padding()
                  .previewDisplayName("View1 Preview")

        Divider()
            .background(Color.red)
            .frame(height: 20)
        SwitchToLatest_()
                  .previewLayout(PreviewLayout.sizeThatFits)
                  .padding()
                  .previewDisplayName("View2 Preview")
          }
 
    

}


class SwitchToLatestVM_ :ObservableObject{
    
    var CoursesPublishers = PassthroughSubject<PassthroughSubject<String, Never>, Never>()
    
    @Published var SwiftUiCourses = [String]()
    var SwiftUICourses = PassthroughSubject<String, Never>()
    
    @Published var AICourses = [String]()
    var MLCourses = PassthroughSubject<String, Never>()
    private var cancellables: Set<AnyCancellable> = []

    func fetch(){
      let _ =  CoursesPublishers
            .switchToLatest()
            .print()
            .sink { val in
                print("value received is \(val)")
            }.store(in: &cancellables)
        

    }
    
    func tapsend(){
        CoursesPublishers.send(SwiftUICourses)
        SwiftUICourses.send("Mastering WidgetKist in iOS  16")
        SwiftUICourses.send("Mastering SwiftUI  4")
        
        CoursesPublishers.send(MLCourses)
        MLCourses.send("Mastering AI in Swift")
        SwiftUICourses.send("DisneyPlus Clone in SwiftUI")
        MLCourses.send("Mastering NLP in Swift")
        
        CoursesPublishers.send(SwiftUICourses)
        SwiftUICourses.send("DisneyPlus Clone in SwiftUI")

        SwiftUICourses.send(completion: .finished)
        MLCourses.send(completion: .finished)
        CoursesPublishers.send(completion: .finished)
    }
    
    
}
struct SwitchToLatest_: View {
    @StateObject var vm = SwitchToLatestVM_()
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                vm.tapsend()
            }) {
                Text("Placeholder")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Capsule().fill(Color.blue))
            }
         
        }
       
            .task {
                vm.fetch()
            }
    }
}

