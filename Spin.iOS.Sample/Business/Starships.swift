//
//  Starships.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

enum Starships {
}

extension Starships {
    static func all(baseUrl: String, networkService: NetworkService) -> Single<[Starship]> {
        let route = Route<ListEndpoint<Starship>>(baseUrl: baseUrl, endpoint: ListEndpoint<Starship>(path: StartshipsPath.starships))
        return networkService.fetch(route: route).map { $0.results }
    }
    
    static func search(baseUrl: String, networkService: NetworkService, query: String) -> Single<[Starship]> {
        let route = Route<ListEndpoint<Starship>>(baseUrl: baseUrl, endpoint: ListEndpoint<Starship>(path: StartshipsPath.starshipSearch(query: query)))
        return networkService.fetch(route: route).map { $0.results }
    }
    
    static func load(baseUrl: String, networkService: NetworkService, id: String) -> Single<Starship> {
        let route = Route<EntityEndpoint<Starship>>(baseUrl: baseUrl, endpoint: EntityEndpoint<Starship>(path: StartshipsPath.starship(id: id)))
        return networkService.fetch(route: route)
    }
}
