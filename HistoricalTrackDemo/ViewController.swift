//
//  ViewController.swift
//  HistoricalTrackDemo
//
//  Created by YaM on 2019/4/17.
//  Copyright © 2019 yam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let titleClasses = [[["高德地图", AMapTrackVC.self]]]
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}

private let cellId = "tableViewCell_id"

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleClasses.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleClasses[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = "高德地图"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sec_class = titleClasses[indexPath.section][indexPath.row].last
        let vc = (sec_class as! UIViewController.Type).init()
        navigationController?.pushViewController(vc, animated: true)
    }
}
