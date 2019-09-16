//
//  AppFlow.swift
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

class AppFlow: Flow {
    
    private lazy var rootViewController: UITabBarController = {
        let viewController = UITabBarController()
        return viewController
    }()
        
    var root: Presentable {
        return self.rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppSteps else { return .none }
        
        switch step {
        case .home:
            return self.navigateToHome()
        default:
            return .none
        }
    }
}

extension AppFlow {
    func navigateToHome() -> FlowContributors {
        
        let filmsFlow = FilmsFlow()
        let peoplesFlow = PeoplesFlow()

        Flows.whenReady(flow1: filmsFlow, flow2: peoplesFlow) { [weak self] (filmsRoot, peoplesRoot) in
            let tabBarItem1 = UITabBarItem(title: "Films", image: UIImage(systemName: "film"), selectedImage: nil)
            filmsRoot.tabBarItem = tabBarItem1
            filmsRoot.title = "Films"
            
            let tabBarItem2 = UITabBarItem(title: "Peoples", image: UIImage(systemName: "person"), selectedImage: nil)
            peoplesRoot.tabBarItem = tabBarItem2
            peoplesRoot.title = "Peoples"
            
            self?.rootViewController.setViewControllers([filmsRoot, peoplesRoot], animated: false)
        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: filmsFlow, withNextStepper: OneStepper(withSingleStep: AppSteps.films)),
            .contribute(withNextPresentable: peoplesFlow, withNextStepper: OneStepper(withSingleStep: AppSteps.peoples))])
    }
}
