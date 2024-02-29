//
//  MoviesProvider.swift
//  ThatMoviesApp
//
//  Created by Anđela Šćepović on 8.4.23..
//

import Foundation
import Combine

final class MoviesProvider: MoviesAppUseCase {
    let webService: WebService
    
    init (webService: WebService){
        self.webService = webService
    }
    
    func fetchMoviesApp() -> AnyPublisher<[MoviesAppResponse], Error> {
        let request = APIRequest(endpoint: .latestMovies)
        
        guard let urlRequest = try? request.getURLRequest() else {
            return Fail(error: URLError.urlMalformed)
            
                .eraseToAnyPublisher()
        }
        
        return Just(urlRequest)
            .flatMap {request -> AnyPublisher<latestMoviesDTO, Error> in
                self.webService.execute(request)
            }
            .map{dto in
                dto.moviesAppResponse
            }
            .eraseToAnyPublisher()
    }

}                             
                                 
struct latestMoviesDTO: Decodable{
    
    let results: [ResultsDTO]
   
    var moviesAppResponse: [MoviesAppResponse]{
        
        results.map{
            dto in MoviesAppResponse(
                id: dto.id,
                poster: dto.poster
            )
        }
    }
    
    struct ResultsDTO: Decodable{
        
        let id: Int
        let poster: String
        
        
        enum CodingKeys: String, CodingKey{
            case id
            case poster = "poster_path"
        }
    }
    
}
