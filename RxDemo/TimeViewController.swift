//
//  FirstViewController.swift
//  RxDemo
//
//  Created by David Yang on 13/03/2017.
//  Copyright © 2017 David Yang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TimeViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let dateFormatter = DateFormatter()
    
    let items = Variable<[Date]>([])
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        setupTimeLabel()
        setupAddItemAction()
        setupClearItemAction()
        bindUI()
    }
    
    func registerCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
    }
    
    func setupTimeLabel() {
        Observable<Int>.interval(0.1, scheduler: MainScheduler.instance).map({ (_) -> Date in
            return Date()
        }).map { [weak self] (date) -> String? in
            return self?.dateFormatter.string(from: date)
        }.subscribe(onNext: { [weak self] (dateString) in
            self?.timeLabel.text = dateString ?? ""
        }).addDisposableTo(disposeBag)
    }

    func setupClearItemAction() {
        self.navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.items.value.removeAll()
        }).addDisposableTo(disposeBag)
    }
    
    func setupAddItemAction() {
        self.navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.items.value.append(Date())
        }).addDisposableTo(disposeBag)
    }

    func bindUI() {
        items.asObservable().bindTo(tableView.rx.items(cellIdentifier: "CellIdentifier", cellType: UITableViewCell.self)) { [weak self] (index, date, cell) in
            cell.textLabel?.text = self?.dateFormatter.string(from: date)
        }
        .addDisposableTo(disposeBag)
    }

}

