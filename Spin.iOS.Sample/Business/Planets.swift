//
//  Planets.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

enum Planets {
}

extension Planets {
    static func all(baseUrl: String, networkService: NetworkService) -> Single<[Planet]> {
        let route = Route<ListEndpoint<Planet>>(baseUrl: baseUrl, endpoint: ListEndpoint<Planet>(path: PlanetsPath.planets))
        return networkService.fetch(route: route).map { $0.results }
    }
    
    static func search(baseUrl: String, networkService: NetworkService, query: String) -> Single<[Planet]> {
        let route = Route<ListEndpoint<Planet>>(baseUrl: baseUrl, endpoint: ListEndpoint<Planet>(path: PlanetsPath.planetSearch(query: query)))
        return networkService.fetch(route: route).map { $0.results }
    }
    
    static func load(baseUrl: String, networkService: NetworkService, id: String) -> Single<Planet> {
        let route = Route<EntityEndpoint<Planet>>(baseUrl: baseUrl, endpoint: EntityEndpoint<Planet>(path: PlanetsPath.planet(id: id)))
        return networkService.fetch(route: route)
    }
}
