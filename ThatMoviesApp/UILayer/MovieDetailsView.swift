//
//  MovieDetails.swift
//  ThatMoviesApp
//
//  Created by Anđela Šćepović on 12.4.23..
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

struct MovieDetailsView: View {
    @ObservedObject var viewModel: ViewModel
   
    
    let backgroundColor = Color(red: 0.141, green: 0.165, blue: 0.196)
    let movieId: Int
    
    init(dependencies: MovieDetailsViewDependencies, movieId: Int){
        viewModel = ViewModel(dependencies: dependencies)
        self.movieId = movieId
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
                        .onAppear{viewModel.loadMovieDetails()}
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
    
    var presentationView: some View {
        VStack{
            ZStack{
                WebImage(url: URL(string: "https://image.tmdb.org/t/p/w500" + "\(viewModel.movieData.first?.backdrop ?? "")"))
                    .ignoresSafeArea(edges: .top)
                
                ZStack{
                    
                    ZStack{
                        Color(red: 0.145, green: 0.157, blue: 0.212)
                            .frame(width: 70, height: 32)
                            .cornerRadius(11)
                            .opacity(0.85)
                        
                        HStack{
                            Image(systemName: "star")
                                .foregroundColor(.orange)
                                .font(.system(size: 18, weight: .semibold))
                            
                            let rating: Double = viewModel.movieData.first?.rating ?? 0.0
                            let roundRating = String (format: "%.1f", rating)
                            Text("\(roundRating)")
                                .foregroundColor(.orange)
                                .font(.system(size: 17, weight: .bold))
                        }
                    }
                    .padding(.top, 230)
                    .padding(.leading, 320)
                }
            }
            HStack{
                WebImage(url: URL(string: "https://image.tmdb.org/t/p/w500" + "\(viewModel.movieData.first?.poster ?? "")"))
                    .resizable()
                    .frame(width: 95, height: 120)
                    .cornerRadius(16)
                    .offset(y: -60)
                    .padding(.leading, 29)
                
                
                Text("\(viewModel.movieData.first?.title ?? "")")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(Color.white)
                    .padding(.trailing, 55)
                    .offset(y: -60)
                    .padding(.leading, 12)
                    .offset(y: 30)
            }
            
            HStack{
                
                Text("\(viewModel.movieData.first?.releaseYear ?? "")")
            }
            
            
            
        }
    }
    
    var progressView: some View{
        Image("popcorn")
            .resizable()
            .frame(width: 189, height: 189)
        
    }
    
}

struct MovieDetails_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(dependencies: AppDependenciesContainer())
    }
}

protocol MovieDetailsViewDependencies{
    var movieDetailsUseCase: MovieDetailsUseCase { get }
}

extension MovieDetailsView{
    final class ViewModel: ObservableObject{
        let dependencies: MovieDetailsViewDependencies
        
        @Published var viewState: ViewState = .initial
        
        @Published var movieData = [MovieDetailsResponse]()
        
        private var loadMovieDetailsSubscription: AnyCancellable? = nil
        
        
        init(dependencies: MovieDetailsViewDependencies){
            self.dependencies = dependencies
        }
        
        enum ViewState {
            case initial
            case loading
            case error
            case finished
        }
        
        func loadMovieDetails(){
            viewState = .loading
            
            loadMovieDetailsSubscription =
            dependencies.movieDetailsUseCase.getMovieDetails()
                .sink(receiveCompletion: {completion in
                    switch completion{
                    case .failure:
                        self.viewState = .error
                    case .finished:
                        self.viewState = .finished
                    }
                }, receiveValue: { movieData in
                    self.movieData = movieData
                    self.viewState = .finished
                })
        }
    }
}


