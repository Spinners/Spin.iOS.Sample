//
//  PlanetsCommand.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-14.
//  Copyright © 2019 Spinners. All rights reserved.
//

import ReactiveSwift
import Spin
import Spin_ReactiveSwift

extension Planets {
    enum Commands {
        
        class Builder {
            
            private let baseUrl = "swapi.co"

            func buildAllCommand() -> AnyCommand<SignalProducer<Planets.Action, Never>, Planets.State> {
                let pagePlanetsBusinessFunction = curry3(function: Planets.Business.page)(baseUrl)(ReactiveNetworkService())
                return Planets.Commands.All(pagePlanetsBusiness: pagePlanetsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildPreviousCommand() -> AnyCommand<SignalProducer<Planets.Action, Never>, Planets.State> {
                let pagePlanetsBusinessFunction = curry3(function: Planets.Business.page)(baseUrl)(ReactiveNetworkService())
                return Planets.Commands.Previous(pagePlanetsBusiness: pagePlanetsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildNextCommand() -> AnyCommand<SignalProducer<Planets.Action, Never>, Planets.State> {
                let pagePlanetsBusinessFunction = curry3(function: Planets.Business.page)(baseUrl)(ReactiveNetworkService())
                return Planets.Commands.Next(pagePlanetsBusiness: pagePlanetsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildSearchCommand(query: String) -> AnyCommand<SignalProducer<Planets.Action, Never>, Planets.State> {
                let searchPlanetsBusinessFunction = curry3(function: Planets.Business.search)(baseUrl)(ReactiveNetworkService())
                return Planets.Commands.Search(searchPlanetsBusiness: searchPlanetsBusinessFunction, query: query).eraseToAnyCommand()
            }
        }
        
        struct All: Command {
            let pagePlanetsBusiness: (Int?) -> SignalProducer<([Planet], Int?, Int?), NetworkError>
            
            func execute(basedOn state: Planets.State) -> SignalProducer<Planets.Action, Never> {
                return self.pagePlanetsBusiness(nil)
                    .map { .succeedLoad(planets: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .flatMapError { (error) -> SignalProducer<Planets.Action, Never> in
                        return SignalProducer<Planets.Action, Never>(value: .failLoad)
                }
                .prefix(value: .startLoad)
            }
        }
        
        struct Previous: Command {
            let pagePlanetsBusiness: (Int?) -> SignalProducer<([Planet], Int?, Int?), NetworkError>
            
            func execute(basedOn state: Planets.State) -> SignalProducer<Planets.Action, Never> {
                guard let previousPage = state.previousPage else { return SignalProducer<Planets.Action, Never>.empty }
                return self.pagePlanetsBusiness(previousPage)
                    .map { .succeedLoad(planets: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .flatMapError { (error) -> SignalProducer<Planets.Action, Never> in
                        return SignalProducer<Planets.Action, Never>(value: .failLoad)
                }
                .prefix(value: .startLoad)
            }
        }
        
        struct Next: Command {
            let pagePlanetsBusiness: (Int?) -> SignalProducer<([Planet], Int?, Int?), NetworkError>
            
            func execute(basedOn state: Planets.State) -> SignalProducer<Planets.Action, Never> {
                guard let nextPage = state.nextPage else { return SignalProducer<Planets.Action, Never>.empty }
                return self.pagePlanetsBusiness(nextPage)
                    .map { .succeedLoad(planets: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .flatMapError { (error) -> SignalProducer<Planets.Action, Never> in
                        return SignalProducer<Planets.Action, Never>(value: .failLoad)
                }
                .prefix(value: .startLoad)
            }
        }
        
        struct Search: Command {
            let searchPlanetsBusiness: (String) -> SignalProducer<[Planet], NetworkError>
            let query: String
            
            func execute(basedOn state: Planets.State) -> SignalProducer<Planets.Action, Never> {
                return self.searchPlanetsBusiness(self.query)
                    .map { .succeedLoad(planets: $0, previousPage: nil, nextPage: nil) }
                    .flatMapError { (error) -> SignalProducer<Planets.Action, Never> in
                        return SignalProducer<Planets.Action, Never>(value: .failLoad)
                }
                .prefix(value: .startLoad)
            }
        }
    }
}
