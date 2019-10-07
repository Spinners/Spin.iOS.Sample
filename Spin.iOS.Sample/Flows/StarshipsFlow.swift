//
//  StarshipsFlow.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-10-06.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxFlow
import RxSwift
import RxRelay
import Spin
import Spin_RxSwift
import UIKit

class StarshipsFlow: Flow {

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
        case .starships:
            return self.navigateToStarships()
        default:
            return .none
        }
    }
}

extension StarshipsFlow {
    func navigateToStarships() -> FlowContributors {

        // build Spin
        let viewController = StarshipsViewController.make(commandBuilder: Starships.Commands.Builder())

        Spinner
            .from(function: viewController.emitCommands)
            .executeAndScan(initial: .idle, reducer: Starships.reducer)
            .consume(by: viewController.interpret, on: DispatchQueue.main)
            .spin()
            .disposed(by: &viewController.disposeBag)

        self.rootViewController.pushViewController(viewController, animated: true)

        return .none
    }
}
