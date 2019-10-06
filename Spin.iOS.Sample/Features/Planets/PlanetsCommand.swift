//
//  PlanetsCommand.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-14.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift
import Spin

extension Planets {
    enum Commands {
        
        class Builder {
            
            private let baseUrl = "swapi.co"

            func buildAllCommand() -> AnyCommand<Observable<Planets.Action>, Planets.State> {
                let allPlanetsBusinessFunction = curry2Extended(function: Planets.Business.all)(baseUrl)(AlamofireNetworkService())
                return Planets.Commands.All(allPlanetsBusiness: allPlanetsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildPreviousCommand() -> AnyCommand<Observable<Planets.Action>, Planets.State> {
                let pagePlanetsBusinessFunction = curry3(function: Planets.Business.page)(baseUrl)(AlamofireNetworkService())
                return Planets.Commands.Previous(pagePlanetsBusiness: pagePlanetsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildNextCommand() -> AnyCommand<Observable<Planets.Action>, Planets.State> {
                let pagePlanetsBusinessFunction = curry3(function: Planets.Business.page)(baseUrl)(AlamofireNetworkService())
                return Planets.Commands.Next(pagePlanetsBusiness: pagePlanetsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildSearchCommand(query: String) -> AnyCommand<Observable<Planets.Action>, Planets.State> {
                let searchPlanetsBusinessFunction = curry3(function: Planets.Business.search)(baseUrl)(AlamofireNetworkService())
                return Planets.Commands.Search(searchPlanetsBusiness: searchPlanetsBusinessFunction, query: query).eraseToAnyCommand()
            }
        }
        
        struct All: Command {
            let allPlanetsBusiness: () -> Single<([Planet], Int?, Int?)>
            
            func execute(basedOn state: Planets.State) -> Observable<Planets.Action> {
                return self.allPlanetsBusiness()
                .asObservable()
                .map { .succeedLoad(planets: $0.0, previousPage: $0.1, nextPage: $0.2) }
                .catchErrorJustReturn(.failLoad)
                .startWith(.startLoad)
            }
        }
        
        struct Previous: Command {
            let pagePlanetsBusiness: (Int) -> Single<([Planet], Int?, Int?)>
            
            func execute(basedOn state: Planets.State) -> Observable<Planets.Action> {
                guard let previousPage = state.previousPage else { return .empty() }
                return self.pagePlanetsBusiness(previousPage)
                    .asObservable()
                    .map { .succeedLoad(planets: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .catchErrorJustReturn(.failLoad)
                    .startWith(.startLoad)
            }
        }
        
        struct Next: Command {
            let pagePlanetsBusiness: (Int) -> Single<([Planet], Int?, Int?)>
            
            func execute(basedOn state: Planets.State) -> Observable<Planets.Action> {
                guard let nextPage = state.nextPage else { return .empty() }
                return self.pagePlanetsBusiness(nextPage)
                    .asObservable()
                    .map { .succeedLoad(planets: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .catchErrorJustReturn(.failLoad)
                    .startWith(.startLoad)
            }
        }
        
        struct Search: Command {
            let searchPlanetsBusiness: (String) -> Single<[Planet]>
            let query: String
            
            func execute(basedOn state: Planets.State) -> Observable<Planets.Action> {
                return self.searchPlanetsBusiness(self.query)
                .asObservable()
                .map { .succeedLoad(planets: $0, previousPage: nil, nextPage: nil) }
                .catchErrorJustReturn(.failLoad)
                .startWith(.startLoad)
            }
        }
    }
}
