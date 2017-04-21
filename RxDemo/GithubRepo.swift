//
//  GithubRepo.swift
//  RxDemo
//
//  Created by David Yang on 13/03/2017.
//  Copyright © 2017 David Yang. All rights reserved.
//

import Foundation

struct GithubRepo {
    var name: String
    var description: String
    var url: String
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as? String ?? ""
        description = dictionary["description"] as? String ?? ""
        url = dictionary["url"] as? String ?? ""
    }
}
