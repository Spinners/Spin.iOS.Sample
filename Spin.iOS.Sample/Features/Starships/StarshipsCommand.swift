//
//  PlanetsCommand.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-14.
//  Copyright © 2019 Spinners. All rights reserved.
//

import Combine
import Spin
import Spin_Combine

extension Starships {
    enum Commands {
        
        class Builder {
            
            private let baseUrl = "swapi.co"

            func buildAllCommand() -> AnyCommand<AnyPublisher<Starships.Action, Never>, Starships.State> {
                let pageStarshipsBusinessFunction = curry3(function: Starships.Business.page)(baseUrl)(ReactiveNetworkService())
                return Starships.Commands.All(pageStarshipsBusinessFunction: pageStarshipsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildPreviousCommand() -> AnyCommand<AnyPublisher<Starships.Action, Never>, Starships.State> {
                let pageStarshipsBusinessFunction = curry3(function: Starships.Business.page)(baseUrl)(ReactiveNetworkService())
                return Starships.Commands.Previous(pageStarshipsBusiness: pageStarshipsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildNextCommand() -> AnyCommand<AnyPublisher<Starships.Action, Never>, Starships.State> {
                let pageStarshipsBusinessFunction = curry3(function: Starships.Business.page)(baseUrl)(ReactiveNetworkService())
                return Starships.Commands.Next(pageStarshipsBusiness: pageStarshipsBusinessFunction).eraseToAnyCommand()
            }
            
            func buildSearchCommand(query: String) -> AnyCommand<AnyPublisher<Starships.Action, Never>, Starships.State> {
                let searchStarshipsBusinessFunction = curry3(function: Starships.Business.search)(baseUrl)(ReactiveNetworkService())
                return Starships.Commands.Search(searchStarshipsBusiness: searchStarshipsBusinessFunction, query: query).eraseToAnyCommand()
            }
        }
        
        struct All: Command {
            let pageStarshipsBusinessFunction: (Int?) -> AnyPublisher<([Starship], Int?, Int?), NetworkError>
            
            func execute(basedOn state: Starships.State) -> AnyPublisher<Starships.Action, Never> {
                return self.pageStarshipsBusinessFunction(nil)
                .map { .succeedLoad(starships: $0.0, previousPage: $0.1, nextPage: $0.2) }
                .replaceError(with: .failLoad)
                .prepend(.startLoad)
                .eraseToAnyPublisher()
            }
        }
        
        struct Previous: Command {
            let pageStarshipsBusiness: (Int?) -> AnyPublisher<([Starship], Int?, Int?), NetworkError>
            
            func execute(basedOn state: Starships.State) -> AnyPublisher<Starships.Action, Never> {
                guard let previousPage = state.previousPage else { return Empty().eraseToAnyPublisher() }
                return self.pageStarshipsBusiness(previousPage)
                    .map { .succeedLoad(starships: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .replaceError(with: .failLoad)
                    .prepend(.startLoad)
                    .eraseToAnyPublisher()
            }
        }
        
        struct Next: Command {
            let pageStarshipsBusiness: (Int?) -> AnyPublisher<([Starship], Int?, Int?), NetworkError>
            
            func execute(basedOn state: Starships.State) -> AnyPublisher<Starships.Action, Never> {
                guard let nextPage = state.nextPage else { return Empty().eraseToAnyPublisher() }
                return self.pageStarshipsBusiness(nextPage)
                    .map { .succeedLoad(starships: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .replaceError(with: .failLoad)
                    .prepend(.startLoad)
                    .eraseToAnyPublisher()
            }
        }
        
        struct Search: Command {
            let searchStarshipsBusiness: (String) -> AnyPublisher<[Starship], NetworkError>
            let query: String
            
            func execute(basedOn state: Starships.State) -> AnyPublisher<Starships.Action, Never> {
                return self.searchStarshipsBusiness(self.query)
                .map { .succeedLoad(starships: $0, previousPage: nil, nextPage: nil) }
                .replaceError(with: .failLoad)
                .prepend(.startLoad)
                .eraseToAnyPublisher()
            }
        }
    }
}
