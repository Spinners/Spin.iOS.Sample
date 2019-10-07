//
//  PlanetsFlow.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxFlow
import ReactiveSwift
import Spin
import Spin_ReactiveSwift
import UIKit

class PlanetsFlow: Flow {
    
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
        case .planets:
            return self.navigateToPlanets()
        default:
            return .none
        }
    }
}

extension PlanetsFlow {
    func navigateToPlanets() -> FlowContributors {
        
        // build Spin
        let viewController = PlanetsViewController.make(commandBuilder: Planets.Commands.Builder())
                
        Spinner
            .from(function: viewController.emitCommands)
            .feedback(initial: .idle, reducer: Planets.reducer)
            .consume(by: viewController.interpret, on: UIScheduler())
            .spin()
            .disposed(by: viewController.disposeBag)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .none
    }
}
