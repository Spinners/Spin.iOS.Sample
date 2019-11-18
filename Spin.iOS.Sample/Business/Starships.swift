//
//  Starships.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import Combine

enum Starships {
}

extension Starships {
    enum Business {
        static func page(baseUrl: String, networkService: NetworkService, page: Int?) -> AnyPublisher<([Starship], Int?, Int?), NetworkError> {
            let route = Route<ListEndpoint<Starship>>(baseUrl: baseUrl, endpoint: ListEndpoint<Starship>(path: StarshipsPath.starships))
            if let page = page {
                route.set(parameter: ListRequest(page: page))
            }
            return networkService.fetchCombine(route: route).map { listResponse -> ([Starship], Int?, Int?) in
                let previousPage = listResponse.previous?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let nextPage = listResponse.next?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                return (listResponse.results, previousPage, nextPage)
            }.eraseToAnyPublisher()
        }
        
        static func search(baseUrl: String, networkService: NetworkService, query: String) -> AnyPublisher<[Starship], NetworkError> {
            let route = Route<ListEndpoint<Starship>>(baseUrl: baseUrl, endpoint: ListEndpoint<Starship>(path: StarshipsPath.starshipSearch(query: query)))
            return networkService.fetchCombine(route: route).map { $0.results }.eraseToAnyPublisher()
        }
        
        static func load(baseUrl: String, networkService: NetworkService, id: String) -> AnyPublisher<Starship, NetworkError> {
            let route = Route<EntityEndpoint<Starship>>(baseUrl: baseUrl, endpoint: EntityEndpoint<Starship>(path: StarshipsPath.starship(id: id)))
            return networkService.fetchCombine(route: route).eraseToAnyPublisher()
        }
    }
}
