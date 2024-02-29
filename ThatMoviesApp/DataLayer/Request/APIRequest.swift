//
//  APIRequest.swift
//  ThatMoviesApp
//
//  Created by Anđela Šćepović on 7.4.23..
//

import Foundation

//ENDPOINT: GET https://api.themoviedb.org/3/movie/now_playing?api_key=505afaf4721419c8190a768911f187f4&language=en-US&page=1
//Endpoint: GET https://api.themoviedb.org/3/search/movie?api_key=505afaf4721419c8190a768911f187f4&query=<<SEARCH_QUERY>>&page=1
//Endpoint: GET https://api.themoviedb.org/3/movie/<<MOVIE_ID>>?api_key=505afaf4721419c8190a768911f187f4&language=en-US

struct APIRequest{
    let baseURL: String = "https://api.themoviedb.org/3/"
    let API_KEY: String = "505afaf4721419c8190a768911f187f4"
    let endpoint: Endpoint
  
    
    func getURLRequest() throws -> URLRequest{
        let url = baseURL + endpoint.path + "api_key=\(API_KEY)" + endpoint.parametars
        
        guard let url = URL (string: url) else {
            throw URLError.urlMalformed
        }
        return URLRequest(url: url)
    }
}

enum Endpoint{
    
    case latestMovies
    case searchingForMovies
    case movieDetails(Int)
    
    var path: String{
        switch self{
        case .latestMovies:
            return "movie/now_playing?"
        case .searchingForMovies:
            return ""
        case .movieDetails(let id):
            return "movie/\(id)?"
        }
    }
    var parametars: String{
        switch self{
        case .latestMovies:
            return "&language=en-US&page=1"
        case .searchingForMovies:
            return ""
        case .movieDetails:
            return "&language=en-US"
        }
    }
}

enum URLError: Error{
  
    case urlMalformed
    
}
