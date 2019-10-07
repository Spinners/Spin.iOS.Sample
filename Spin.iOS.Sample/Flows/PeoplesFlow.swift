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

        Spinner
            .from(function: viewController.emitCommands)
            .executeAndScan(initial: .idle, reducer: Peoples.reducer)
            .consume(by: viewController.interpret, on: MainScheduler.instance)
            .spin()
            .disposed(by: viewController.disposeBag)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .none
    }
}
