//
//  MenuView.swift
//  squarify
//
//  Created by Jeffery Widroff on 12/11/24.
//

import UIKit

class MenuView: UIView, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate {
  
    var tableView = UITableView()
    var model = Model()
    var levelNames = [String]()
    var levelNumber = Int()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, model: Model) {
        
        super.init(frame: frame)

        self.model = model
        backgroundColor = .cyan

        tableView.frame = CGRect(x: 0, y: 40, width: self.frame.width, height: self.frame.height - 40)
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
        addToolBar()
    }
    
    func addToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.frame.size = CGSize(width: frame.width, height: 40.0)
        toolBar.clipsToBounds = true
        let doneButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(MenuView.dismissView))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        toolBar.barStyle = UIBarStyle.black
        toolBar.backgroundColor = UIColor.darkGray
        self.addSubview(toolBar)
    }
    
    @objc func dismissView() {
        removeFromSuperview()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levelNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = levelNames[indexPath.row]

//        let rect = CGRect(x: 0, y: 0, width: cell.frame.height, height: cell.frame.height)

        if model.defaults.integer(forKey: "highestLevel") < indexPath.row {

            cell.backgroundColor = UIColor.gray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.model.defaults.integer(forKey: "highestLevel") >= indexPath.row {
            
            self.model.delegate?.removeViews()
            self.model.setUpGame()
            self.model.setUpControlsAndInstructions()
            self.removeFromSuperview()
        }
    }
}

