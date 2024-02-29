//
//  ContentView.swift
//  ThatMoviesApp
//
//  Created by Anđela Šćepović on 6.4.23..
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

struct MoviesAppView: View{
    @State private var search = ""
    @ObservedObject var viewModel: ViewModel
    let backgroundColor = Color(red: 0.141, green: 0.165, blue: 0.196)
    
    init(dependencies: MoviesAppViewModelDependencies){
        viewModel = ViewModel(dependencies: dependencies)
    }
    
    var body: some View {
        ZStack{
            backgroundColor
                .edgesIgnoringSafeArea(.all)
                .fullScreenCover(isPresented: .constant(false)) {}
            
            Group{
                switch viewModel.viewState{
                case .initial:
                    progressView
                        .onAppear{viewModel.loadMoviesData()}
                case .loading:
                    progressView
                case .error:
                    Text("Error")
                case .finished:
                    presentationView
                    
                }
            }
            
        }
        
    }
    
    
    var presentationView: some View{
        VStack{
            
            Text("What do you want to watch?")
                .font(.system(size: 21, weight: .heavy))
                .foregroundColor(Color.white)
                .padding(.trailing, 55)
            
            TextField("Search", text: $search)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(15)
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .overlay(
                    Color.gray
                        .opacity(0.7)
                        .padding(.vertical, 12)
                        .cornerRadius(60))
            
            
            HStack {
                ForEach(viewModel.moviesData) { movie in
                    NavigationLink(destination: MovieDetailsView(dependencies: AppDependenciesContainer()),
                                   label: {
                        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w500" + "\(movie.poster)"))
                    }
                    )}
            }
        }
        .padding(.horizontal, 24)
    }
    
    var progressView: some View{
        Image("popcorn")
            .resizable()
            .frame(width: 189, height: 189)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        MoviesAppView(dependencies: AppDependenciesContainer())
    }
}

protocol MoviesAppViewModelDependencies{
    var moviesAppUseCase: MoviesAppUseCase{ get }
}

extension MoviesAppView{
    final class ViewModel: ObservableObject{
        let dependencies: MoviesAppViewModelDependencies
        
        @Published  var viewState: ViewState = .initial
    
        @Published var moviesData = [MoviesAppResponse]()

        
        private var loadMoviesDataSubscription: AnyCancellable? = nil
        
        init(dependencies: MoviesAppViewModelDependencies){
            self.dependencies = dependencies
        }
        
        enum ViewState{
            
            case initial
            case loading
            case error
            case finished
        }
        
        func loadMoviesData(){
            viewState = .loading
            
            loadMoviesDataSubscription =
            dependencies.moviesAppUseCase.fetchMoviesApp()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        self.viewState = .error
                    case .finished:
                        self.viewState = .finished
                    }
                }, receiveValue: { moviesData in
                    self.moviesData = moviesData
                    self.viewState = .finished
                })
        }
    }
}


