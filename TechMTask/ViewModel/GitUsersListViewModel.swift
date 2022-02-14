//
//  GitUsersListViewModel.swift
//  TechMTask
//
//  Created by Mani bhushan M on 14/02/22.
//

import Foundation
import UIKit

class GitUsersListViewModel {
    
    var controller : UIViewController!
    var usersList = [UserList]()
    var searchStr = ""
    var page = 0
    var per_page_items = 15
    var total_page = 0
    var isSearch = false
    
    init(controller:  UIViewController) {
        self.controller = controller
    }
    
    func getData(completion:@escaping([UserList]?)->Void){
        
        APIManager.sharedInstance.getUserData(url_str: URLConstants.GET_GIT_USERS_LIST_API, page: page, per_page_items: per_page_items, completion: {(status_code , JSON) in
            
            if status_code != 200 {
                let alert = UIAlertController(title: "ERROR", message: "Something went wrong, please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.controller.present(alert, animated: false, completion: nil)
                return
            }
            guard let data = JSON else{return completion(nil)}
            
            DispatchQueue.main.async {
                self.total_page = ((data.total_count ?? 0)/15) + (((data.total_count ?? 0)%15) == 0 ? 0 : 1)
                print("Total result:- \(self.total_page) :: \(data.total_count ?? 0)")
                let list = data.items ?? []
                completion(list)
            }
        })
                        
    }
    
}

