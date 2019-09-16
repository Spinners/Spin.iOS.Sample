//
//  FilmsFlow.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxFlow
import RxSwift
import RxRelay
import Spin
import Spin_RxSwift
import UIKit

class FilmsFlow: Flow {
    
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
        case .films:
            return self.navigateToFilms()
        default:
            return .none
        }
    }
}

extension FilmsFlow {
    func navigateToFilms() -> FlowContributors {
        
        // build Spin
        let viewController = FilmsViewController.make(commandBuilder: Films.Commands.Builder())
        
        let currentState = BehaviorRelay<Films.State>(value: .idle)
        
        Spin
            .from(function: viewController.emitCommands)
            .compose(function: { (commands) -> Observable<Films.Action> in
                return commands.withLatestFrom(currentState) { return ($0, $1) }
                    .flatMap { (command, state) -> Observable<Films.Action> in
                        return command.execute(basedOn: state)
                }
            })
            .scan(initial: .idle, reducer: Films.reducer)
            .consume(by: viewController.interpret, on: MainScheduler.instance)
            .consume(by: { currentState.accept($0) }, on: MainScheduler.instance)
            .spin()
            .disposed(by: viewController.disposeBag)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNext: viewController))
    }
}
