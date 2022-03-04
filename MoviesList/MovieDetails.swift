//
//  MovieDetails.swift
//  MoviesList
//
//  Created by Mohamed Maged on 02/02/2022.
//

import Foundation
import UIKit

struct MovieDetails: Codable {
var title = String()
var image = String()
var rating = Double()
var releaseYear: Int = 0
var genre:[String] = []
    

}
