//
//  combineDependency.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 26/01/2024.
//

import Foundation
import SwiftUI
import Combine



class ChainedRequestsViewModel:ObservableObject{
    var cancellable = Set<AnyCancellable>()
    @Published var chainedViewState: State = .idle

   public enum State:Equatable {
        case idle
        case isLoading
        case success(String)
        case failure
    }
    
    func fetchPostDetails() -> AnyPublisher<PostDetail,Error> {
        fetchPosts().flatMap(fetchPostDetails)
        .eraseToAnyPublisher()
    }
    func fetchPosts() -> AnyPublisher<[Post],Error>{
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        return fetch(url: url)
    }
    
    
    func fetchPostDetails(posts:[Post]) -> AnyPublisher<PostDetail,Error>{
   
        let post = posts.first!
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(post.id)")!
        print(url)
        return fetch(url: url)
            
    }
    
    func fetch<T:Decodable>(url:URL) -> AnyPublisher<T,Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ result in
                guard let response = result.response as? HTTPURLResponse,
                        response.statusCode == 200
                else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    init() {
        chainedViewState = .isLoading
        self.fetchPostDetails()
            .sink { [weak self] completion in
                
            if case .failure(let error) = completion {
                self?.chainedViewState = .failure
                print("errro \(error.localizedDescription)")
            }
        } receiveValue: { [weak self] postDetail in
            self?.chainedViewState = .success(postDetail.title)
        }

        .store(in: &cancellable)

    }
    

}


struct ChainedRequestsView:View {
    @StateObject var vm = ChainedRequestsViewModel()
    var body: some View {
        VStack{
            switch vm.chainedViewState {
            case .isLoading:
                ProgressView()
            case .failure:
                Text("failure").foregroundStyle(.red)
            case .idle:
                Text("Nothing to do")
            case .success(let title):
                Text(title).foregroundStyle(.green)
            }
            
        }
    }
}


#Preview {
    ChainedRequestsView()
}
