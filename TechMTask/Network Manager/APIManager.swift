//
//  APIManager.swift
//  TechMTask
//
//  Created by Mani bhushan M on 14/02/22.
//

import Foundation

 protocol APICoreDelegate: AnyObject {
    func didReceiveData(data: SearchUserResponse?)
}

open class APIManager {
    static let sharedInstance = APIManager()
     var delegate : APICoreDelegate?
    
    func getUserData(url_str : String ,page : Int , per_page_items : Int ,completion:@escaping(Int,SearchUserResponse?)->Void){
        
        let url = url_str + "?q=type:user&order=desc&page=\(page)&per_page=\(per_page_items)"
        
        guard let finalURL = URL.init(string: url) else {return}
        
        URLSession.shared.dataTask(with: finalURL){(data,response,err) in
            var statusCode = 500
            
            if let httpResponse = response as? HTTPURLResponse {
                    print("statusCode: \(httpResponse.statusCode)")
                statusCode = httpResponse.statusCode
            }
            
            guard let data = data else {return  completion(statusCode,nil)}
            
            do {
                let data = try JSONDecoder().decode(SearchUserResponse.self, from: data)
                DispatchQueue.main.async { [self] in
                    delegate?.didReceiveData(data: data)
                    completion(statusCode,data)
                    
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                self.delegate?.didReceiveData(data: nil)
                completion(statusCode,nil)
            }
        }.resume()
    }
    
    func getSearchedUsersData(url_str : String ,search_term : String,page : Int , per_page_items : Int ,completion:@escaping(Int,SearchUserResponse?)->Void){
        
        let url = url_str + "?q=\(search_term)&order=desc&page=\(page)&per_page=\(per_page_items)"
        
        guard let finalURL = URL.init(string: url) else {return}
        
        URLSession.shared.dataTask(with: finalURL){(data,response,err) in
            var statusCode = 500
            
            if let httpResponse = response as? HTTPURLResponse {
                    print("statusCode: \(httpResponse.statusCode)")
                statusCode = httpResponse.statusCode
                }
            
            guard let data = data else {return  completion(statusCode,nil)}
            
            do {
                let data = try JSONDecoder().decode(SearchUserResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(statusCode,data)
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                completion(statusCode,nil)
            }
        }.resume()
    }
}
