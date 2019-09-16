//
//  Peoples.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

enum Peoples {
}

extension Peoples {
    enum Business {
        static func all(baseUrl: String, networkService: NetworkService) -> Single<([People], Int?, Int?)> {
            let route = Route<ListEndpoint<People>>(baseUrl: baseUrl, endpoint: ListEndpoint<People>(path: PeoplePath.peoples))
            return networkService.fetch(route: route).map { listResponse -> ([People], Int?, Int?) in
                let previousPage = listResponse.previous?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let nextPage = listResponse.next?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                return (listResponse.results, previousPage, nextPage)
            }
        }
        
        static func page(baseUrl: String, networkService: NetworkService, page: Int) -> Single<([People], Int?, Int?)> {
            let route = Route<ListEndpoint<People>>(baseUrl: baseUrl, endpoint: ListEndpoint<People>(path: PeoplePath.peoples))
            route.set(parameter: ListRequest(page: page))
            return networkService.fetch(route: route).map { listResponse -> ([People], Int?, Int?) in
                let previousPage = listResponse.previous?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let nextPage = listResponse.next?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                return (listResponse.results, previousPage, nextPage)
            }
        }
        
        static func search(baseUrl: String, networkService: NetworkService, query: String) -> Single<[People]> {
            let route = Route<ListEndpoint<People>>(baseUrl: baseUrl, endpoint: ListEndpoint<People>(path: PeoplePath.peopleSearch(query: query)))
            return networkService.fetch(route: route).map { $0.results }
        }
        
        static func load(baseUrl: String, networkService: NetworkService, id: String) -> Single<People> {
            let route = Route<EntityEndpoint<People>>(baseUrl: baseUrl, endpoint: EntityEndpoint<People>(path: PeoplePath.people(id: id)))
            return networkService.fetch(route: route)
        }
    }
}
