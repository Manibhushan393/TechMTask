//
//  SearchUserResponse.swift
//  TechMTask
//
//  Created by Mani bhushan M on 14/02/22.
//

import Foundation

struct SearchUserResponse : Codable {
    let total_count : Int?
    let incomplete_results : Bool?
    let items : [UserList]?
   
    enum CodingKeys: String, CodingKey {

        case total_count = "total_count"
        case incomplete_results = "incomplete_results"
        case items = "items"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
        incomplete_results = try values.decodeIfPresent(Bool.self, forKey: .incomplete_results)
        items = try values.decodeIfPresent([UserList].self, forKey: .items)
    }

}
