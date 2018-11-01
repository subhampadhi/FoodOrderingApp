//
//  ViewController.swift
//  FoodOrderingApp
//
//  Created by Subham Padhi on 31/10/18.
//  Copyright © 2018 Subham Padhi. All rights reserved.
//

import UIKit

class HomeVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationItem.title = "Food Court"
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        setUpViews()
    }
    
    lazy var menuTable: UITableView = {
        
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setUpViews() {
        
        view.addSubview(menuTable)
        
        menuTable.dataSource = self
        menuTable.delegate = self
        menuTable.separatorStyle = .none
        menuTable.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
        menuTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        menuTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuTable.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        menuTable.register(MenuTableViewCell.self, forCellReuseIdentifier: "menuTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTableViewCell") as! MenuTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

class MenuTableViewCell: UITableViewCell{
    
    lazy var itemImage: UIImageView = {
        
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var foodNameLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Burger"
        label.font = UIFont(name: "Nunito-SemiBold", size: 16)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    var foodPriceLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "₹ 125.5"
        label.font = UIFont(name: "Nunito-Bold", size: 12)
        label.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return label
    }()
    
    var bottomView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.7333333333, green: 0.7333333333, blue: 0.7333333333, alpha: 1)
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
        addSubview(itemImage)
        addSubview(bottomView)
        addSubview(foodNameLabel)
        addSubview(foodPriceLabel)
        
        itemImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        itemImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        itemImage.widthAnchor.constraint(equalToConstant: frame.width/3).isActive = true
        itemImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        bottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomView.widthAnchor.constraint(equalToConstant: frame.width/1.2).isActive = true
        bottomView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: itemImage.bottomAnchor, constant: 10).isActive = true
        
        foodNameLabel.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: 10).isActive = true
        foodNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        foodNameLabel.topAnchor.constraint(equalTo: itemImage.topAnchor, constant: 10).isActive = true
        
        foodPriceLabel.leadingAnchor.constraint(equalTo: foodNameLabel.leadingAnchor).isActive = true
        foodPriceLabel.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor, constant: 5).isActive = true

        
    }
}
