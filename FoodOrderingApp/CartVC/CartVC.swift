//
//  CartVC.swift
//  FoodOrderingApp
//
//  Created by Subham Padhi on 02/11/18.
//  Copyright © 2018 Subham Padhi. All rights reserved.
//

import Foundation
import UIKit

class CartVC: UIViewController , UITableViewDataSource ,UITableViewDelegate{
    
    var selectedData: [[MenuModel]] = [[]]
    var orderCount:[Int] = []
    var cartData:[MenuModel] = []
    
    func showAlert(title: String, message: String, presenter: UIViewController) {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        presenter.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        titleLabel.text = "Cart"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Nunito-Bold", size: 18)
        titleLabel.textColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 0.9529411765, alpha: 1)
        navigationItem.titleView = titleLabel
       for data in selectedData {
        if data.count > 0 {
            orderCount.append(data.count)
            for item in data {
                cartData.append(item)
                print(item.item_name)
                break
            }
        }
    }
        setUpViews()
    }
    
    var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 0.9529411765, alpha: 1)
        button.setTitle("Order", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 20)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(CartVC.submit), for: .touchUpInside)
        return button
    }()
    
    var totalLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.font = UIFont(name: "Nunito-Regular", size: 20)
        view.text = "Total: "
        view.numberOfLines = 0
        return view
    }()
    
    var amountLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.font = UIFont(name: "Nunito-Regular", size: 20)
        view.text = "₹ 350"
        view.numberOfLines = 0
        return view
    }()
    
    lazy var bottomborder1: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return view
    }()
    
    lazy var bottomborder2: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return view
    }()
    
    lazy var promoCodeTextField: UITextField = {
        let nameText = UITextField()
        nameText.translatesAutoresizingMaskIntoConstraints = false
        nameText.attributedPlaceholder = NSAttributedString(text: " Enter Promo Code", aligment: .left)
        nameText.setPadding()
        nameText.setBottomBorder()
        nameText.autocapitalizationType = .none
        nameText.font = UIFont(name: "Nunito-Regular", size: 14)
        return nameText
    }()
    
    lazy var checkPromoCode: UIButton = {
        
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("check", for: .normal)
        view.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 20)
        view.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        view.layer.cornerRadius = 15
        view.addTarget(self, action: #selector(CartVC.checkPromo), for: .touchUpInside)
        return view
    }()
    
    @objc func checkPromo() {
        
    }
    
    @objc func submit() {
        
    }
    
    lazy var cartTable: UITableView = {
        
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for data in selectedData {
            if data.count > 0 {
                count+=1
            }
        }
        if count == 0 {
            showAlert(title: "Oops", message: "Your cart is empty!", presenter: self)
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartTableViewCell") as! CartTableViewCell
        let item = self.orderCount[indexPath.row]
        let cart = self.cartData[indexPath.row]
        cell.itemNameLabel.text = cart.item_name
        cell.totalValueLabel.text = "\(cart.item_price * item)"
        cell.itemCountLabel.text = " X \(item)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func setUpViews() {
        view.addSubview(submitButton)
        view.addSubview(totalLabel)
        view.addSubview(amountLabel)
        view.addSubview(bottomborder1)
        view.addSubview(promoCodeTextField)
        view.addSubview(checkPromoCode)
        view.addSubview(bottomborder2)
        view.addSubview(cartTable)
        
        cartTable.dataSource = self
        cartTable.delegate = self
        
        cartTable.register(CartTableViewCell.self, forCellReuseIdentifier: "cartTableViewCell")
        
        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        totalLabel.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -10).isActive = true
        
        amountLabel.bottomAnchor.constraint(equalTo: totalLabel.bottomAnchor).isActive = true
        amountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:-15).isActive = true
        
        bottomborder1.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant:5).isActive = true
        bottomborder1.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant:-5).isActive = true
        bottomborder1.bottomAnchor.constraint(equalTo: amountLabel.topAnchor,constant:-5).isActive = true
        bottomborder1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        promoCodeTextField.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 15).isActive = true
        promoCodeTextField.widthAnchor.constraint(equalToConstant: 130).isActive = true
        promoCodeTextField.bottomAnchor.constraint(equalTo: bottomborder1.topAnchor, constant: -10).isActive = true
        
        checkPromoCode.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        checkPromoCode.bottomAnchor.constraint(equalTo: promoCodeTextField.bottomAnchor).isActive = true
        checkPromoCode.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkPromoCode.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        bottomborder2.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant:5).isActive = true
        bottomborder2.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant:-5).isActive = true
        bottomborder2.bottomAnchor.constraint(equalTo: checkPromoCode.topAnchor,constant:-5).isActive = true
        bottomborder2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        cartTable.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        cartTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cartTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cartTable.bottomAnchor.constraint(equalTo: bottomborder2.topAnchor).isActive = true
        
    }
 }

extension UITextField {
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width - 4))
        self.leftView = paddingView
        
        self.leftViewMode = .always
    }
    
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 0.0
    }
}

extension String {
    func attributedStringOne(aligment: NSTextAlignment) -> NSAttributedString {
        return NSAttributedString(text: self, aligment: aligment)
    }
}

extension NSAttributedString {
    convenience init(text: String, aligment: NSTextAlignment) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = aligment
        self.init(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
}

class CartTableViewCell: UITableViewCell {
    
    var itemNameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.font = UIFont(name: "Nunito-Regular", size: 16)
        view.text = ""
        view.numberOfLines = 0
        return view
    }()
    
    var itemCountLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        view.font = UIFont(name: "Nunito-Regular", size: 14)
        view.text = ""
        view.numberOfLines = 0
        return view
    }()
    
    var totalValueLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        view.font = UIFont(name: "Nunito-Regular", size: 16)
        view.text = ""
        view.numberOfLines = 0
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        addSubview(itemNameLabel)
        addSubview(itemCountLabel)
        addSubview(totalValueLabel)
        
        itemNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        itemNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        itemCountLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 4).isActive = true
        itemCountLabel.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor).isActive = true
        
        totalValueLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        totalValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
    }
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

