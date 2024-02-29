//
//  MovieDetailsProvider.swift
//  ThatMoviesApp
//
//  Created by Anđela Šćepović on 20.4.23..
//

import Foundation
import Combine

final class MovieDetailsProvider: MovieDetailsUseCase{
    let webService: WebService
    
    init(webService: WebService){
        self.webService = webService
    }
    
    func getMovieDetails(id: Int) -> AnyPublisher<[MovieDetailsResponse], Error> {
        let request = APIRequest(endpoint: .movieDetails(id))
    
        guard let urlRequest = try? request.getURLRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
    }
}


struct movieDetailsDTO: Decodable{

    let results: [ResultsDTO]
    
    var movieDetailsResponse: [MovieDetailsResponse]{
        results.map{
            dto in MovieDetailsResponse(
                
                id: results.first?.id ?? 0,
                backdrop: results.first?.backdrop ?? "",
                poster: results.first?.poster ?? "",
                title: results.first?.title ?? "",
                rating: results.first?.rating ?? 0.0,
                releaseYear: results.first?.releaseYear ?? "",
                description: results.first?.description ?? ""
            )
        }
    }
        
    struct ResultsDTO: Decodable{
        
        let id: Int
        let backdrop: String
        let poster: String
        let title: String
        let rating: Double
        let releaseYear: String
        let description: String
        
        enum CodingKeys: String, CodingKey{
            case id
            case poster = "poster_path"
            case backdrop = "backdrop_path"
            case title
            case rating = "vote_average"
            case releaseYear = "release_date"
            case description = "overview"
        }
    }
}
