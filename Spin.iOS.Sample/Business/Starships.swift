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
    enum Business {
        static func all(baseUrl: String, networkService: NetworkService) -> Single<([Starship], Int?, Int?)> {
            let route = Route<ListEndpoint<Starship>>(baseUrl: baseUrl, endpoint: ListEndpoint<Starship>(path: StarshipsPath.starships))
            return networkService.fetch(route: route).map { listResponse -> ([Starship], Int?, Int?) in
                let previousPage = listResponse.previous?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let nextPage = listResponse.next?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                return (listResponse.results, previousPage, nextPage)
            }
        }

        static func page(baseUrl: String, networkService: NetworkService, page: Int) -> Single<([Starship], Int?, Int?)> {
            let route = Route<ListEndpoint<Starship>>(baseUrl: baseUrl, endpoint: ListEndpoint<Starship>(path: StarshipsPath.starships))
            route.set(parameter: ListRequest(page: page))
            return networkService.fetch(route: route).map { listResponse -> ([Starship], Int?, Int?) in
                let previousPage = listResponse.previous?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let nextPage = listResponse.next?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                return (listResponse.results, previousPage, nextPage)
            }
        }
        
        static func search(baseUrl: String, networkService: NetworkService, query: String) -> Single<[Starship]> {
            let route = Route<ListEndpoint<Starship>>(baseUrl: baseUrl, endpoint: ListEndpoint<Starship>(path: StarshipsPath.starshipSearch(query: query)))
            return networkService.fetch(route: route).map { $0.results }
        }
        
        static func load(baseUrl: String, networkService: NetworkService, id: String) -> Single<Starship> {
            let route = Route<EntityEndpoint<Starship>>(baseUrl: baseUrl, endpoint: EntityEndpoint<Starship>(path: StarshipsPath.starship(id: id)))
            return networkService.fetch(route: route)
        }
    }
}
