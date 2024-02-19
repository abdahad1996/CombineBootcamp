//
//  RecieveOn.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//

import SwiftUI
import Combine


//MARK: Recieve(on)
//sometimes publishers will be doing work in the background. If you then try to display the data on the view it may or may not be displayed. Xcode will also show you
//the “purple warning” which is your hint that you need to move data from the background to the foreground (or main thread) so it can be displayed.

//RunLoop
//Run loops manage events and
//work. It allows multiple things to
//happen simultaneously.

private struct ErrorForAlert: Error, Identifiable {
    let id = UUID()
    let title = "Error"
    var message = "Please try again later."
}

class RecieveOnVM:ObservableObject{
    @Published var imageView = Image("blank.image")
    @Published private var errorForAlert: ErrorForAlert?
    
    var cancellables: Set<AnyCancellable> = []
    
    func fetch() {
        let url = URL(string: "https://http.cat/401")!
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { data in
                guard let uiImage = UIImage(data: data) else {
                    throw ErrorForAlert(message: "Did not receive a valid image.")
                }
                return Image(uiImage: uiImage)
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [unowned self] completion in
                if case .failure(let error) = completion {
                    if error is ErrorForAlert {
                        errorForAlert = (error as! ErrorForAlert)
                    } else {
                        errorForAlert = ErrorForAlert(message: "Details: \(error.localizedDescription)")
                    }
                }
            }, receiveValue: { [unowned self] image in
                imageView = image
            })
            .store(in: &cancellables)
    }
}
struct RecieveOn: View {
    @StateObject var vm = RecieveOnVM()
    var body: some View {
        VStack {
            Button(action: {
                vm.fetch()
            }) {
                Text("get image")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Capsule().fill(Color.blue))
            }
            vm.imageView.resizable().scaledToFill()
        }
    }
}

#Preview {
    RecieveOn()
}
