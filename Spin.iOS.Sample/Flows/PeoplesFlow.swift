//
//  PeopleFlow.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-14.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxFlow
import RxSwift
import RxRelay
import Spin
import Spin_RxSwift
import UIKit

class PeoplesFlow: Flow {
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
        
    var root: Presentable {
        return self.rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppSteps else { return .none }
        
        switch step {
        case .peoples:
            return self.navigateToPeoples()
        default:
            return .none
        }
    }
}

extension PeoplesFlow {
    func navigateToPeoples() -> FlowContributors {
        
        // build Spin
        let viewController = PeoplesViewController.make(commandBuilder: Peoples.Commands.Builder())
        
        let currentState = BehaviorRelay<Peoples.State>(value: .idle)
        
        Spin
            .from(function: viewController.emitCommands)
            .compose(function: { (commands) -> Observable<Peoples.Action> in
                return commands.withLatestFrom(currentState) { return ($0, $1) }
                    .flatMap { (command, state) -> Observable<Peoples.Action> in
                        return command.execute(basedOn: state)
                }
            })
            .scan(initial: .idle, reducer: Peoples.reducer)
            .consume(by: viewController.interpret, on: MainScheduler.instance)
            .consume(by: { currentState.accept($0) }, on: MainScheduler.instance)
            .spin()
            .disposed(by: viewController.disposeBag)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNext: viewController))
    }
}
