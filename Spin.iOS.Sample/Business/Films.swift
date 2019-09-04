//
//  Films.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

enum Films {
}

extension Films {
    enum Business {
        static func all(baseUrl: String, networkService: NetworkService) -> Single<[Film]> {
            let route = Route<ListEndpoint<Film>>(baseUrl: baseUrl, endpoint: ListEndpoint<Film>(path: FilmsPath.films))
            return networkService.fetch(route: route).map { $0.results }
        }
        
        static func search(baseUrl: String, networkService: NetworkService, query: String) -> Single<[Film]> {
            let route = Route<ListEndpoint<Film>>(baseUrl: baseUrl, endpoint: ListEndpoint<Film>(path: FilmsPath.filmSearch(query: query)))
            return networkService.fetch(route: route).map { $0.results }
        }
        
        static func load(baseUrl: String, networkService: NetworkService, id: String) -> Single<Film> {
            let route = Route<EntityEndpoint<Film>>(baseUrl: baseUrl, endpoint: EntityEndpoint<Film>(path: FilmsPath.film(id: id)))
            return networkService.fetch(route: route)
        }
    }
}
