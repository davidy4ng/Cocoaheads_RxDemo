//
//  SecondViewController.swift
//  RxDemo
//
//  Created by David Yang on 13/03/2017.
//  Copyright © 2017 David Yang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GithubRepoViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class GithubViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupSearch()
    }

    func registerCells() {
        tableView.register(GithubRepoViewCell.self, forCellReuseIdentifier: "GithubRepoCellIdentifier")
    }
    
    func setupSearch() {
        searchBar.rx.text
        .orEmpty
        .debounce(0.5, scheduler: MainScheduler.instance)
        .map { (searchString) in
            let url = URL(string: "http://api.github.com/search/repositories?q=\(searchString)")!
            return URLRequest(url: url)
        }
        .flatMapLatest { (request) in
            return URLSession.shared.rx.json(request: request).catchErrorJustReturn([])
        }
        .map({ json -> [GithubRepo] in
            if let json = json as? [String: Any], let items = json["items"] as? [[String: Any]] {
                return items.flatMap(GithubRepo.init)
            } else {
                return []
            }
        })
        .observeOn(MainScheduler.instance)
        .bindTo(tableView.rx.items(cellIdentifier: "GithubRepoCellIdentifier", cellType: GithubRepoViewCell.self)) { (index, repo, cell) in
            cell.textLabel?.text = repo.name
            cell.detailTextLabel?.text = repo.url
        }
        .addDisposableTo(disposeBag)
    }
}

