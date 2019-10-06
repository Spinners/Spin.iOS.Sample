//
//  PlanetsCommand.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-14.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift
import Spin

extension Starships {
    enum Commands {
        
        class Builder {
            
            private let baseUrl = "swapi.co"

            func buildAllCommand() -> AnyCommand<Observable<Starships.Action>, Starships.State> {
                let allStarshipsBusinessFunction = curry2Extended(function: Starships.Business.all)(baseUrl)(AlamofireNetworkService())
                return Starships.Commands.All(allStarshipsBusiness: allStarshipsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildPreviousCommand() -> AnyCommand<Observable<Starships.Action>, Starships.State> {
                let pageStarshipsBusinessFunction = curry3(function: Starships.Business.page)(baseUrl)(AlamofireNetworkService())
                return Starships.Commands.Previous(pageStarshipsBusiness: pageStarshipsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildNextCommand() -> AnyCommand<Observable<Starships.Action>, Starships.State> {
                let pageStarshipsBusinessFunction = curry3(function: Starships.Business.page)(baseUrl)(AlamofireNetworkService())
                return Starships.Commands.Next(pageStarshipsBusiness: pageStarshipsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildSearchCommand(query: String) -> AnyCommand<Observable<Starships.Action>, Starships.State> {
                let searchStarshipsBusinessFunction = curry3(function: Starships.Business.search)(baseUrl)(AlamofireNetworkService())
                return Starships.Commands.Search(searchStarshipsBusiness: searchStarshipsBusinessFunction, query: query).eraseToAnyCommand()
            }
        }
        
        struct All: Command {
            let allStarshipsBusiness: () -> Single<([Starship], Int?, Int?)>
            
            func execute(basedOn state: Starships.State) -> Observable<Starships.Action> {
                return self.allStarshipsBusiness()
                .asObservable()
                .map { .succeedLoad(starships: $0.0, previousPage: $0.1, nextPage: $0.2) }
                .catchErrorJustReturn(.failLoad)
                .startWith(.startLoad)
            }
        }
        
        struct Previous: Command {
            let pageStarshipsBusiness: (Int) -> Single<([Starship], Int?, Int?)>
            
            func execute(basedOn state: Starships.State) -> Observable<Starships.Action> {
                guard let previousPage = state.previousPage else { return .empty() }
                return self.pageStarshipsBusiness(previousPage)
                    .asObservable()
                    .map { .succeedLoad(starships: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .catchErrorJustReturn(.failLoad)
                    .startWith(.startLoad)
            }
        }
        
        struct Next: Command {
            let pageStarshipsBusiness: (Int) -> Single<([Starship], Int?, Int?)>
            
            func execute(basedOn state: Starships.State) -> Observable<Starships.Action> {
                guard let nextPage = state.nextPage else { return .empty() }
                return self.pageStarshipsBusiness(nextPage)
                    .asObservable()
                    .map { .succeedLoad(starships: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .catchErrorJustReturn(.failLoad)
                    .startWith(.startLoad)
            }
        }
        
        struct Search: Command {
            let searchStarshipsBusiness: (String) -> Single<[Starship]>
            let query: String
            
            func execute(basedOn state: Starships.State) -> Observable<Starships.Action> {
                return self.searchStarshipsBusiness(self.query)
                .asObservable()
                .map { .succeedLoad(starships: $0, previousPage: nil, nextPage: nil) }
                .catchErrorJustReturn(.failLoad)
                .startWith(.startLoad)
            }
        }
    }
}
