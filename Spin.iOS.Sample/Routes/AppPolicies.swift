//
//  AppPolicies.swift
//  ClearID
//
//  Created by Thibault Wittemberg on 18-09-24.
//  Copyright © 2018 Genetec. All rights reserved.
//

/// The Application's policies
///
/// - unauthenticated: the endpoints do not need authentication to be accessed
public enum AppPolicy: String {
    case unauthenticated
}

// MARK: - AppPolicies default implementation of CustomStringConvertible
extension AppPolicy: Policy {
    public var description: String {
        return self.rawValue
    }
}
