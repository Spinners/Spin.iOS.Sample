//
//  Command.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-10.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

protocol Command {
    associatedtype State
    associatedtype Mutation
    func execute(basedOn state: State) -> Observable<Mutation>
}

class AnyCommand<AnyState, AnyMutation>: Command {
    
    private let executeClosure: (State) -> Observable<Mutation>
    
    init<CommandType: Command> (command: CommandType) where CommandType.State == State, CommandType.Mutation == Mutation {
        self.executeClosure = command.execute
    }
    
    func execute(basedOn state: AnyState) -> Observable<AnyMutation> {
        return self.executeClosure(state)
    }

}

extension Command {
    func eraseToAnyCommand() -> AnyCommand<State, Mutation> {
        return AnyCommand<State, Mutation>(command: self)
    }
}
