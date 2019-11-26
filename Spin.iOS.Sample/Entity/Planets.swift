//
//  Planets.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import ReactiveSwift

enum Planets {
}

extension Planets {
    enum Business {
        static func page(baseUrl: String, networkService: NetworkService, page: Int?) -> SignalProducer<([Planet], Int?, Int?), NetworkError> {
            let route = Route<ListEndpoint<Planet>>(baseUrl: baseUrl, endpoint: ListEndpoint<Planet>(path: PlanetsPath.planets))
            if let page = page {
                route.set(parameter: ListRequest(page: page))
            }
            return networkService.fetchReactive(route: route).map { listResponse -> ([Planet], Int?, Int?) in
                let previousPage = listResponse.previous?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let nextPage = listResponse.next?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                return (listResponse.results, previousPage, nextPage)
            }
        }

        static func search(baseUrl: String, networkService: NetworkService, query: String) -> SignalProducer<[Planet], NetworkError> {
            let route = Route<ListEndpoint<Planet>>(baseUrl: baseUrl, endpoint: ListEndpoint<Planet>(path: PlanetsPath.planetSearch(query: query)))
            return networkService.fetchReactive(route: route).map { $0.results }
        }

        static func load(baseUrl: String, networkService: NetworkService, id: String) -> SignalProducer<Planet, NetworkError> {
            let route = Route<EntityEndpoint<Planet>>(baseUrl: baseUrl, endpoint: EntityEndpoint<Planet>(path: PlanetsPath.planet(id: id)))
            return networkService.fetchReactive(route: route)
        }
    }
}
