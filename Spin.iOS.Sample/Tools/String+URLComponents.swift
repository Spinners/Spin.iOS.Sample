//
//  String+URLComponents.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-14.
//  Copyright © 2019 Spinners. All rights reserved.
//

import Foundation

extension String {
    var path: String {
        guard let url = try? self.asURL() else { return "" }
        return "/"+url.lastPathComponent+"/?"+url.query!
    }
    
    var baseUrl: String {
        guard let url = try? self.asURL() else { return "" }
        guard let baseUrl = url.host else { return "" }
        return baseUrl.description
    }
}
