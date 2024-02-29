//
//  AppDependenciesContainer.swift
//  ThatMoviesApp
//
//  Created by Anđela Šćepović on 8.4.23..
//

import Foundation

final class AppDependenciesContainer: MoviesAppViewModelDependencies, MovieDetailsViewDependencies{
    
    
    let webService = NetworkService(networkSession: DataNetworkSession())
        
    lazy var moviesAppUseCase: MoviesAppUseCase = MoviesProvider(webService: webService)
    lazy var movieDetailsUseCase: MovieDetailsUseCase = MovieDetailsProvider(webService: webService)
}

