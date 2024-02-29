//
//  MoviesAppUseCase.swift
//  ThatMoviesApp
//
//  Created by Anđela Šćepović on 8.4.23..
//

import Foundation
import Combine

protocol MoviesAppUseCase{
    func fetchMoviesApp() -> AnyPublisher<[MoviesAppResponse], Error>
}


struct MoviesAppResponse: Decodable, Identifiable{
    
    let id: Int
    let poster: String
    
}


