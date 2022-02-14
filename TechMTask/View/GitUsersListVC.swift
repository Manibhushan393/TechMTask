//
//  ViewController.swift
//  TechMTask
//
//  Created by Mani bhushan M on 14/02/22.
//

import UIKit

class GitUsersListVC: UIViewController , UIScrollViewDelegate{

    @IBOutlet weak var userListTV : UITableView!
    @IBOutlet var searchview: UISearchBar!
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    @IBOutlet var notFoundLbl: UILabel!
    
    var viewmodel : GitUsersListViewModel!
    var isLoading = true
    var sectionHeight = 1
    var keyboardActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewmodel = GitUsersListViewModel(controller: self)
        self.searchview.delegate = self
        self.activityIndicator.startAnimating()
        self.viewmodel.getData(completion: { info in
            self.activityIndicator.stopAnimating()
            self.viewmodel.usersList = info ?? []
            self.setupListViews()
        })
        let vv = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(vv)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
        self.notFoundLbl.isHidden = true
        if !keyboardActive {return}
        if self.viewmodel.searchStr.count > 0 {
            self.viewmodel.isSearch = true
        }else{
            self.viewmodel.isSearch = false
        }

        self.activityIndicator.startAnimating()
        self.viewmodel.usersList = []
        self.userListTV.reloadData()
        self.viewmodel.page = 0
        self.viewmodel.total_page = 0
        self.viewmodel.getData(completion: { info in
            self.viewmodel.usersList = info ?? []
            self.isLoading = (self.viewmodel.total_page > 1)
            self.activityIndicator.stopAnimating()
            self.userListTV.reloadData()
        })
    }
    
    func setupListViews(){
        userListTV.register(UINib(nibName: "LoadingTVCell", bundle: nil), forCellReuseIdentifier: "LoadingTVCell")
        userListTV.register(UINib(nibName: "UserListTVCell", bundle: nil), forCellReuseIdentifier: "UserListTVCell")
        
        userListTV.delegate = self
        userListTV.dataSource = self
        DispatchQueue.main.async {
            self.userListTV.reloadData()
        }
    }


}

extension GitUsersListVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        self.userListTV.isHidden = (self.viewmodel.usersList.count == 0)
        self.notFoundLbl.isHidden = (self.viewmodel.usersList.count > 0)
        
      return self.viewmodel.usersList.count
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cell  = tableView.dequeueReusableCell(withIdentifier: "UserListTVCell") as! UserListTVCell
        
        let cellInfo = self.viewmodel.usersList[indexPath.row]
        cell.userNameLbl.text = cellInfo.login ?? ""
        
        if let url = URL(string: cellInfo.avatar_url ?? "") {
            let data = try? Data(contentsOf: url)
            cell.userAvathar.image = UIImage(data: data!)
        }
        
        return cell
    
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return UITableView.automaticDimension
    
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row >= (self.viewmodel.usersList.count - 1)) && (self.viewmodel.page <= self.viewmodel.total_page) {
            
            if self.isLoading {
                
            self.activityIndicator.startAnimating()
            
            DispatchQueue.global().async {
                self.viewmodel.page += 1
                self.isLoading = true
                self.viewmodel.getData(completion: { info in
                    let inn = info ?? []
                    if inn.count == 0 {
                        self.activityIndicator.stopAnimating()
                        self.isLoading = false
                    }
                    self.viewmodel.usersList += info ?? []
                    self.activityIndicator.stopAnimating()
                    self.userListTV.reloadData()
                })
            }
        }
        }
    }

}

extension GitUsersListVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewmodel.searchStr = searchText
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let RISTRICTED_CHARACTERS = "'*=+[]\\|;:'\",<>/?%@!@#$%^&()₹-."
        let set = CharacterSet(charactersIn: RISTRICTED_CHARACTERS)
            let inverted = set.inverted
            let filtered = text.components(separatedBy: inverted).joined(separator: "")
        return filtered != text
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsSearchResultsButton = true
        self.keyboardActive = true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsSearchResultsButton = false
        searchview.endEditing(true)
        self.keyboardActive = false
        if self.viewmodel.searchStr.count > 0 {
            self.viewmodel.isSearch = true
        }else{
            self.viewmodel.isSearch = false
        }
        
        self.activityIndicator.startAnimating()
        self.viewmodel.usersList = []
        self.userListTV.reloadData()
        self.viewmodel.page = 0
        self.viewmodel.total_page = 0
        self.notFoundLbl.isHidden = true
        self.viewmodel.getData(completion: { info in
            self.viewmodel.usersList = info ?? []
            self.isLoading = (self.viewmodel.total_page > 1)
            self.activityIndicator.stopAnimating()
            self.userListTV.reloadData()
        })
    }
   
    
}
