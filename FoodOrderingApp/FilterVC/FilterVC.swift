//
//  FilterVC.swift
//  FoodOrderingApp
//
//  Created by Subham Padhi on 02/11/18.
//  Copyright © 2018 Subham Padhi. All rights reserved.
//

import Foundation
import UIKit

protocol MyProtocol {
    func setResultOfBusinessLogic(valueSent: String)
}

class FilterVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    let homeVC = HomeVC()
    var delegate: MyProtocol?
    
    lazy var filterTable: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let options = ["Price low to high" ,"Price hight to low" , "Average Rating" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        titleLabel.text = "Filter By"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Nunito-Bold", size: 18)
        titleLabel.textColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 0.9529411765, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationItem.titleView = titleLabel
        setUpViews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < options.count{
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterTableCell") as! FilterTableCell
        cell.choicelabel.text = options[indexPath.row]
        cell.selectionStyle = .none
        return cell
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            homeVC.sortBy = options[indexPath.row]
            delegate?.setResultOfBusinessLogic(valueSent: options[indexPath.row])
        
        
            navigationController?.popViewController(animated: true)
        
    }
    
    
    func setUpViews(){
        view.addSubview(filterTable)
        filterTable.dataSource = self
        filterTable.delegate = self
        filterTable.register(FilterTableCell.self, forCellReuseIdentifier: "filterTableCell")
        filterTable.tableFooterView = UIView()
        
        filterTable.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
        filterTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        filterTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant:20).isActive = true
        filterTable.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
}

class FilterTableCell: UITableViewCell{
    
    var choicelabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Burger"
        label.font = UIFont(name: "Nunito-SemiBold", size: 16)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(){
        addSubview(choicelabel)
        choicelabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        choicelabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
}
