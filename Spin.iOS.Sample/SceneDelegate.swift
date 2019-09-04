//
//  SceneDelegate.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-01.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxFlow
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let coordinator = FlowCoordinator()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let window = self.window else { return }
        
        let appFlow = AppFlow()
        Flows.whenReady(flow1: appFlow) { root in
            window.rootViewController = root
        }
        
        self.coordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: AppSteps.films))
    }
}

