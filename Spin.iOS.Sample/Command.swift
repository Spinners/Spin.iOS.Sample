//
//  Command.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-10.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

protocol Command {
    associatedtype Mutation
    func execute() -> Observable<Mutation>
}

class AnyCommand<AnyMutation>: Command {
    
    private let executeClosure: () -> Observable<Mutation>
    
    init<CommandType: Command> (command: CommandType) where CommandType.Mutation == Mutation {
        self.executeClosure = command.execute
    }
    
    func execute() -> Observable<AnyMutation> {
        return self.executeClosure()
    }

}

extension Command {
    func eraseToAnyCommand() -> AnyCommand<Mutation> {
        return AnyCommand<Mutation>(command: self)
    }
}
