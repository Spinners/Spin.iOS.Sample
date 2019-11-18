//
//  FilmsCommand.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-14.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift
import Spin
import Spin_RxSwift

extension Peoples {
    enum Commands {
        
        class Builder {
            
            private let baseUrl = "swapi.co"

            func buildAllCommand() -> AnyCommand<Observable<Peoples.Action>, Peoples.State> {
                let pagePeoplesBusinessFunction = curry3(function: Peoples.Business.page)(baseUrl)(ReactiveNetworkService())
                return Peoples.Commands.All(pagePeoplesBusinessFunction: pagePeoplesBusinessFunction).eraseToAnyCommand()
            }
            
            func buildPreviousCommand() -> AnyCommand<Observable<Peoples.Action>, Peoples.State> {
                let pagePeoplesBusinessFunction = curry3(function: Peoples.Business.page)(baseUrl)(ReactiveNetworkService())
                return Peoples.Commands.Previous(pagePeoplesBusiness: pagePeoplesBusinessFunction).eraseToAnyCommand()
            }
            
            func buildNextCommand() -> AnyCommand<Observable<Peoples.Action>, Peoples.State> {
                let pagePeoplesBusinessFunction = curry3(function: Peoples.Business.page)(baseUrl)(ReactiveNetworkService())
                return Peoples.Commands.Next(pagePeoplesBusiness: pagePeoplesBusinessFunction).eraseToAnyCommand()
            }
            
            func buildSearchCommand(query: String) -> AnyCommand<Observable<Peoples.Action>, Peoples.State> {
                let searchPeoplesBusinessFunction = curry3(function: Peoples.Business.search)(baseUrl)(ReactiveNetworkService())
                return Peoples.Commands.Search(searchPeoplesBusiness: searchPeoplesBusinessFunction, query: query).eraseToAnyCommand()
            }
        }
        
        struct All: Command {
            let pagePeoplesBusinessFunction: (Int?) -> Single<([People], Int?, Int?)>
            
            func execute(basedOn state: Peoples.State) -> Observable<Peoples.Action> {
                return self.pagePeoplesBusinessFunction(nil)
                .asObservable()
                .map { .succeedLoad(peoples: $0.0, previousPage: $0.1, nextPage: $0.2) }
                .catchErrorJustReturn(.failLoad)
                .startWith(.startLoad)
            }
        }
        
        struct Previous: Command {
            let pagePeoplesBusiness: (Int?) -> Single<([People], Int?, Int?)>
            
            func execute(basedOn state: Peoples.State) -> Observable<Peoples.Action> {
                guard let previousPage = state.previousPage else { return .empty() }
                return self.pagePeoplesBusiness(previousPage)
                    .asObservable()
                    .map { .succeedLoad(peoples: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .catchErrorJustReturn(.failLoad)
                    .startWith(.startLoad)
            }
        }
        
        struct Next: Command {
            let pagePeoplesBusiness: (Int?) -> Single<([People], Int?, Int?)>
            
            func execute(basedOn state: Peoples.State) -> Observable<Peoples.Action> {
                guard let nextPage = state.nextPage else { return .empty() }
                return self.pagePeoplesBusiness(nextPage)
                    .asObservable()
                    .map { .succeedLoad(peoples: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .catchErrorJustReturn(.failLoad)
                    .startWith(.startLoad)
            }
        }
        
        struct Search: Command {
            let searchPeoplesBusiness: (String) -> Single<[People]>
            let query: String
            
            func execute(basedOn state: Peoples.State) -> Observable<Peoples.Action> {
                return self.searchPeoplesBusiness(self.query)
                .asObservable()
                .map { .succeedLoad(peoples: $0, previousPage: nil, nextPage: nil) }
                .catchErrorJustReturn(.failLoad)
                .startWith(.startLoad)
            }
        }
    }
}
