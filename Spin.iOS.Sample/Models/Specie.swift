//
//  Specie.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

struct Specie: Decodable {
    let name: String
    let classification: String
    let designation: String
    let averageHeight: String
    let averageLifespan: String
    let eyeColors: String
    let hairColors: String
    let skinColors: String
    let language: String
    let homeworld: String
    let people: [String]
    let films: [String]
    let url: String
    let created: String
    let edited: String
    
    enum CodingKeys: String, CodingKey {
                case name
                case classification
                case designation
                case averageHeight = "average_height"
                case averageLifespan = "average_lifespan"
                case eyeColors = "eye_colors"
                case hairColors = "hair_colors"
                case skinColors = "skin_colors"
                case language
                case homeworld
                case people
                case films
                case url
                case created
                case edited
    }
}
