//
//  FilmsCommand.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-14.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

extension Films {
    enum Commands {
        
        class Builder {
            
            private let baseUrl = "swapi.co"

            func buildAllCommand() -> AnyCommand<Films.State, Films.Action> {
                let allFilmsBusinessFunction = curry2Extended(function: Films.Business.all)(baseUrl)(AlamofireNetworkService())
                return Films.Commands.All(allFilmsBusiness: allFilmsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildPreviousCommand() -> AnyCommand<Films.State, Films.Action> {
                let pageFilmsBusinessFunction = curry3(function: Films.Business.page)(baseUrl)(AlamofireNetworkService())
                return Films.Commands.Previous(pageFilmsBusiness: pageFilmsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildNextCommand() -> AnyCommand<Films.State, Films.Action> {
                let pageFilmsBusinessFunction = curry3(function: Films.Business.page)(baseUrl)(AlamofireNetworkService())
                return Films.Commands.Next(pageFilmsBusiness: pageFilmsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildSearchCommand(query: String) -> AnyCommand<Films.State, Films.Action> {
                let searchFilmsBusinessFunction = curry3(function: Films.Business.search)(baseUrl)(AlamofireNetworkService())
                return Films.Commands.Search(searchFilmsBusiness: searchFilmsBusinessFunction, query: query).eraseToAnyCommand()
            }
        }
        
        struct All: Command {
            let allFilmsBusiness: () -> Single<([Film], Int?, Int?)>
            
            func execute(basedOn state: Films.State) -> Observable<Films.Action> {
                return self.allFilmsBusiness()
                .asObservable()
                .map { .succeedLoad(films: $0.0, previousPage: $0.1, nextPage: $0.2) }
                .catchErrorJustReturn(.failLoad)
                .startWith(.startLoad)
            }
        }
        
        struct Previous: Command {
            let pageFilmsBusiness: (Int) -> Single<([Film], Int?, Int?)>
            
            func execute(basedOn state: Films.State) -> Observable<Films.Action> {
                guard let previousPage = state.previousPage else { return .empty() }
                return self.pageFilmsBusiness(previousPage)
                    .asObservable()
                    .map { .succeedLoad(films: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .catchErrorJustReturn(.failLoad)
                    .startWith(.startLoad)
            }
        }
        
        struct Next: Command {
            let pageFilmsBusiness: (Int) -> Single<([Film], Int?, Int?)>
            
            func execute(basedOn state: Films.State) -> Observable<Films.Action> {
                guard let nextPage = state.nextPage else { return .empty() }
                return self.pageFilmsBusiness(nextPage)
                    .asObservable()
                    .map { .succeedLoad(films: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .catchErrorJustReturn(.failLoad)
                    .startWith(.startLoad)
            }
        }
        
        struct Search: Command {
            let searchFilmsBusiness: (String) -> Single<[Film]>
            let query: String
            
            func execute(basedOn state: Films.State) -> Observable<Films.Action> {
                return self.searchFilmsBusiness(self.query)
                .asObservable()
                .map { .succeedLoad(films: $0, previousPage: nil, nextPage: nil) }
                .catchErrorJustReturn(.failLoad)
                .startWith(.startLoad)
            }
        }
    }
}
