//
//  Route.swift
//  ClearID
//
//  Created by Thibault Wittemberg on 18-08-31.
//  Copyright © 2018 Genetec. All rights reserved.
//

import protocol Foundation.NSObject.NSCopying
import struct Foundation.NSObject.NSZone

/// The scheme attached to a base URL
public enum HTTPScheme: String {
    case http
    case https
}

/// A Route represents the way to fetch an Endpoint (Scheme + Endpoint + Base URL + Headers + Parameters)
public final class Route<EndpointType: Endpoint>: NSCopying {
    let scheme: HTTPScheme
    let endpoint: EndpointType
    let baseUrl: String
    private(set) var parameter: EndpointType.RequestModel?
    private(set) var headers = [String: String]()

    public var policy: Policy {
        return self.endpoint.policy
    }

    /// Inits a Route according to a Base URL, an Enpoint and a Scheme (if available)
    ///
    /// - Parameters:
    ///   - baseUrl: the base URL of the endpoint to fetch
    ///   - endpoint: the endpoint to fetch (relative path + HTTP Method + parameter encoding)
    ///   - scheme: the scheme (http / https) if provided apart from the base URL
    public init(baseUrl: String, endpoint: EndpointType, scheme: HTTPScheme = .https) {
        self.baseUrl = baseUrl
        self.endpoint = endpoint
        self.scheme = scheme
    }

    /// NSCopying implementation
    /// Returns a new instance that’s a copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Route(baseUrl: baseUrl, endpoint: endpoint, scheme: scheme)
        copy.parameter = parameter
        copy.headers = headers
        return copy
    }

    /// Sets the parameter given in parameter to this route
    ///
    /// - Parameter parameter: the parameter to set
    /// - Returns: this Route
    @discardableResult
    public func set (parameter: EndpointType.RequestModel) -> Self {
        self.parameter = parameter
        return self
    }

    /// Adds headers in this route
    ///
    /// - Parameters:
    ///   - header: the header to add
    ///   - key: the key to add the header
    /// - Returns: this Route
    @discardableResult
    public func add (header: String, forKey key: String) -> Self {
        self.headers[key] = header
        return self
    }
}
