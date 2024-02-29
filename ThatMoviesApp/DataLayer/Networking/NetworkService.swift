//
//  NetworkService.swift
//  ThatMoviesApp
//
//  Created by Anđela Šćepović on 7.4.23..
//
import Foundation
import Combine


protocol WebService {
    func execute<D>(_ request: URLRequest) -> AnyPublisher<D, Error> where D : Decodable
}

class NetworkService: WebService {
    let networkSession: NetworkSession
    let decoder = JSONDecoder()
    
    init(networkSession: NetworkSession) {
        self.networkSession = networkSession
    }
    
    func execute<D>(_ request: URLRequest) -> AnyPublisher<D, Error> where D : Decodable {
        return networkSession.perform(with: request)
            .decode(type: D.self, decoder: decoder)
            .mapError { error in
                if let error = error as? DecodingError {
                    var errorToReport = error.localizedDescription
                    switch error {
                    case .dataCorrupted(let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) - (\(details))"
                    case .keyNotFound(let key, let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
                    case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
                    @unknown default:
                        break
                    }
                    return APIError.unknown(reason: errorToReport)
                }  else {
                    return error
                }
            }
            .eraseToAnyPublisher()
    }
}
