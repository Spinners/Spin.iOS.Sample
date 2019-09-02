//
//  AlamofireNetworkService.swift
//  ClearID
//
//  Created by Thibault Wittemberg on 18-09-04.
//  Copyright © 2018 Genetec. All rights reserved.
//

import RxSwift
import Alamofire

/// The only aim of the AlamofireNetworkService is to execute requests
/// and return parsed responses
public final class AlamofireNetworkService {

    public init () {}

    private lazy var defaultSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let sessionManager = SessionManager(configuration: configuration)
        return sessionManager
    }()

    private var sessionManagerPerPolicy = [String: SessionManager]()

    /// registers a sessionManager dedicated to a Policy
    ///
    /// - Parameters:
    ///   - sessionManager: the sessionManager that will be used to execute the Route having that Policy
    ///   - policy: the sessionManager's dedicated policy 
    func register (sessionManager: SessionManager, forPolicy policy: Policy) {
        self.sessionManagerPerPolicy[policy.description] = sessionManager
    }

    /// Pick a SessionManager according to a Route Policy.
    /// If none has been defined, a default one will be picked
    ///
    /// - Parameter route: The Route from which a SessionManager will be chosen
    /// - Returns: The SessionManager that will execute the Route
    func sessionManager<EndpointType: Endpoint>(fromRoute route: Route<EndpointType>) -> SessionManager {
        return self.sessionManagerPerPolicy[route.policy.description] ?? self.defaultSessionManager
    }

    /// Fetches a Route with the appropriate SessionManager
    ///
    /// - Parameters:
    ///   - route: the Route to fetch
    ///   - sessionManager: the SessionManager that will execute the Route
    /// - Returns: the Model parsed from the response
    private func fetch<EndpointType: Endpoint> (route: Route<EndpointType>,
                                                withSessionManager sessionManager: SessionManager) -> Single<EndpointType.ResponseModel> {
        return Single<EndpointType.ResponseModel>.create { observer -> Disposable in
            let request = sessionManager
                .request(route)
                .validate(statusCode: 200..<300)
                .responseData(completionHandler: { (responseData) in
                    print(responseData.metrics ?? "")

                    switch responseData.result {
                    case .success(let data):
                        do {
                            let model = try JSONDecoder().decode(EndpointType.ResponseModel.self, from: data)
                            observer(.success(model))
                        } catch {
                            observer(.error(NetworkError.responseDecodingFailure(error: error)))
                        }
                    case .failure(let error as AFError) where error.responseCode == 400:
                        observer(.error(NetworkError.badRequest))
                    case .failure(let error as AFError) where error.responseCode == 401:
                        observer(.error(NetworkError.unauthorized))
                    case .failure(let error as AFError) where error.responseCode == 403:
                        observer(.error(NetworkError.forbidden))
                    case .failure(let error):
                        observer(.error(NetworkError.failure(error: error)))
                    }
                })

            return Disposables.create {
                request.cancel()
            }
        }
    }
}

extension AlamofireNetworkService: NetworkService {

    /// Fetches a Route. A Route is associated with a Decodable Model that will be parsed and returned
    /// as a result of this function.
    ///
    /// - Parameter route: the Route to fetch
    /// - Returns: the Model parsed from the response
    func fetch<EndpointType: Endpoint> (route: Route<EndpointType>) -> Single<EndpointType.ResponseModel> {

        // Pick the suitable SessionManager according to the Route Policy
        let sessionManager = self.sessionManager(fromRoute: route)

        // fetch the Route with this SessionManager
        return self.fetch(route: route, withSessionManager: sessionManager)
    }
}
