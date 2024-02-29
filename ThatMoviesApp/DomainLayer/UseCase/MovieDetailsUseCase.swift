//
//  MovieDetailsUseCase.swift
//  ThatMoviesApp
//
//  Created by Anđela Šćepović on 20.4.23..
//

import Foundation
import Combine

protocol MovieDetailsUseCase{
    func getMovieDetails() -> AnyPublisher<[MovieDetailsResponse
    ],Error>
}


struct MovieDetailsResponse: Decodable, Identifiable{
    
    let id: Int
    let backdrop: String
    let poster: String
    let title: String
    let rating: Double
    let releaseYear: String
    let description: String
}
