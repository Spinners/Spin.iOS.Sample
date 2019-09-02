//
//  AlamofireNetworkService.swift
//  ClearID
//
//  Created by Thibault Wittemberg on 18-09-11.
//  Copyright © 2018 Genetec. All rights reserved.
//

import Foundation
import RxSwift

/// Errors that can be thrown by the NetworkService
///
/// - unauthorized: the authentication is not valid. A new authentication is required.
/// - badRequest: the request could not be fulfilled 
/// - forbidden: although the authentication succeeded, the request is not allowed to access the resource.
/// - responseNotDecodable: the received response could not be parsed into the expected Model
/// - failure: all the other kinds of possible network errors
public enum NetworkError: LocalizedError {
    case unauthorized
    case badRequest
    case forbidden
    case responseDecodingFailure(error: Error)
    case failure(error: Error)

    public var errorDescription: String? {
        switch self {
        case .unauthorized: return "unauthorized"
        case .badRequest: return "badRequest"
        case .forbidden: return "forbidden"
        case .responseDecodingFailure(error: let error):
            return "responseDecodingFailure \(error.localizedDescription)"
        case .failure(error: let innerError):
            return "failure \(innerError.localizedDescription)"
        }
    }
}

public protocol NetworkService {
    func fetch<EndpointType: Endpoint> (route: Route<EndpointType>) -> Single<EndpointType.ResponseModel>
}
