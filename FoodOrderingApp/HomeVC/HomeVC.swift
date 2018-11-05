//
//  ViewController.swift
//  FoodOrderingApp
//
//  Created by Subham Padhi on 31/10/18.
//  Copyright © 2018 Subham Padhi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class HomeVC: UIViewController , UITableViewDelegate , UITableViewDataSource , MyProtocol {
    
    var menuData: [MenuModel] = []
    var selectedData: [[MenuModel]] = [[]]
    var sortBy: String?
    
    func sortArray(value:String){
        if value == "Price low to high" {
            menuData.sort { $0.item_price < $1.item_price }
        } else if value == "Price hight to low"{
            menuData.sort { $0.item_price > $1.item_price }
        } else if value == "Average Rating" {
            menuData.sort { $0.average_rating > $1.average_rating }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Nunito-Bold", size: 18)
        titleLabel.textColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 0.9529411765, alpha: 1)
        navigationItem.titleView = titleLabel
        
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(HomeVC.barButtonPressed))
        if let font = UIFont(name: "Nunito-SemiBold", size: 16) {
            filterButton.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
        self.navigationItem.rightBarButtonItem = filterButton
        
        let cartButton = UIBarButtonItem(title: "Cart", style: .plain, target: self, action: #selector(HomeVC.cartButtonPressed))
        if let font = UIFont(name: "Nunito-SemiBold", size: 16) {
            filterButton.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
        self.navigationItem.leftBarButtonItem = cartButton
        
        setUpViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        menuData.removeAll()
        selectedData.removeAll()
        fetchMenuData()
    }
    
    @objc func cartButtonPressed() {
        let vc = CartVC()
        vc.selectedData = selectedData
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func barButtonPressed(){
        let vc = FilterVC()
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
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
        menuTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuTable.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        menuTable.register(MenuTableViewCell.self, forCellReuseIdentifier: "menuTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTableViewCell") as! MenuTableViewCell
        
        let item = self.menuData[indexPath.row]
        cell.foodNameLabel.text = item.item_name
        cell.foodPriceLabel.text = "\(item.item_price)"
        cell.ratingLabel.text = String(item.average_rating)
        cell.itemImage.kf.setImage(with: URL(string: (item.image_url)))
        cell.orderCountLabel.text = "\(selectedData[indexPath.row].count)"
        
        cell.addItem = {
            () in
            self.selectedData[indexPath.row].append(item)
            cell.orderCountLabel.text = "\(self.selectedData[indexPath.row].count)"
        }
        
        cell.minusItem = {
            () in
            if self.selectedData[indexPath.row].count > 0 {
                self.selectedData[indexPath.row].removeLast()
                cell.orderCountLabel.text = "\(self.selectedData[indexPath.row].count)"
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func ShowLoadingIndicator(){
        let alert = UIAlertController(title: nil, message: " Loading ...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, presenter: UIViewController) {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        presenter.present(alert, animated: true, completion: nil)
    }
    
    func fetchMenuData(){
        DispatchQueue.main.async {
            //   self.ShowLoadingIndicator()
            let url = URL(string: "https://android-full-time-task.firebaseio.com/data.json")!
            Alamofire.request(url).validate().responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    
                    json.array?.forEach({ (item) in
                        let item = MenuModel(item_price: Int(Float(item["item_price"].stringValue)!), image_url: item["image_url"].stringValue, item_name: item["item_name"].stringValue, average_rating: Float(item["average_rating"].stringValue)!)
                        self.menuData.append(item)
                    })
                    if self.sortBy?.isEmpty == false{
                        self.sortArray(value: self.sortBy!)
                    }
                    for _ in self.menuData {
                        self.selectedData.append([MenuModel]())
                    }
                    self.menuTable.reloadData()
                    
                case .failure(let error):
                    self.showAlert(title: "OOPS", message: error.localizedDescription, presenter: self)
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    func setResultOfBusinessLogic(valueSent: String) {
        self.sortBy = valueSent
    }
}

class MenuTableViewCell: UITableViewCell{
    
    var addItem: (() -> ())?
    var minusItem: (() -> ())?
    
    lazy var itemImage: UIImageView = {
        
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var plusImage: UIImageView = {
        
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = #imageLiteral(resourceName: "plus")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var minusImage: UIImageView = {
        
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = #imageLiteral(resourceName: "minus")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var starImage: UIImageView = {
        
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "star")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var foodNameLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Burger"
        label.font = UIFont(name: "Nunito-SemiBold", size: 16)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var orderCountLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.font = UIFont(name: "Nunito-SemiBold", size: 16)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var ratingLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4.3"
        label.font = UIFont(name: "Nunito-SemiBold", size: 12)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
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
    
    @objc func plusTapped(){
        addItem?()
    }
    
    @objc func minusTapped(){
        minusItem?()
    }
    
    func setupView(){
        
        addSubview(itemImage)
        addSubview(bottomView)
        addSubview(foodNameLabel)
        addSubview(foodPriceLabel)
        addSubview(starImage)
        addSubview(ratingLabel)
        addSubview(plusImage)
        addSubview(orderCountLabel)
        addSubview(minusImage)
        
        itemImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        itemImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        itemImage.widthAnchor.constraint(equalToConstant: frame.width/3).isActive = true
        itemImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        bottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomView.widthAnchor.constraint(equalToConstant: frame.width/1.2).isActive = true
        bottomView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 10).isActive = true
        
        foodNameLabel.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: 10).isActive = true
        foodNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        foodNameLabel.topAnchor.constraint(equalTo: itemImage.topAnchor, constant: 10).isActive = true
        
        foodPriceLabel.leadingAnchor.constraint(equalTo: foodNameLabel.leadingAnchor).isActive = true
        foodPriceLabel.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor, constant: 5).isActive = true
        
        ratingLabel.leadingAnchor.constraint(equalTo: foodPriceLabel.leadingAnchor).isActive = true
        ratingLabel.topAnchor.constraint(equalTo: foodPriceLabel.bottomAnchor, constant: 3).isActive = true
        
        starImage.leadingAnchor.constraint(equalTo:ratingLabel.trailingAnchor, constant: 4).isActive = true
        starImage.topAnchor.constraint(equalTo: ratingLabel.topAnchor).isActive = true
        starImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        starImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        plusImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        plusImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        plusImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        plusImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        orderCountLabel.trailingAnchor.constraint(equalTo: plusImage.leadingAnchor , constant: -10).isActive = true
        orderCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        minusImage.trailingAnchor.constraint(equalTo: orderCountLabel.leadingAnchor, constant: -10).isActive = true
        minusImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        minusImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        minusImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let plusTap = UITapGestureRecognizer(target: self, action: #selector(MenuTableViewCell.plusTapped))
        plusImage.addGestureRecognizer(plusTap)
        plusImage.isUserInteractionEnabled = true
        
        let minusTap = UITapGestureRecognizer(target: self, action: #selector(MenuTableViewCell.minusTapped))
        minusImage.addGestureRecognizer(minusTap)
        minusImage.isUserInteractionEnabled = true
    }
}
