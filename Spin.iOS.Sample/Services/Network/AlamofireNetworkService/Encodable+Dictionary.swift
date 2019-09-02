//
//  Encodable+Dictionary.swift
//  ClearID
//
//  Created by Thibault Wittemberg on 18-09-02.
//  Copyright © 2018 Genetec. All rights reserved.
//

import Foundation

// MARK: - Transform an Encodable to a [String: Any] if possible
extension Encodable {
    public var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return nil }
        return jsonObject as? [String: Any]
    }
}
