//
//  SearchViewController.swift
//  IOS_Hackathon
//
//  Created by 임태완 on 2019. 8. 23..
//  Copyright © 2019년 임태완. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var foodTable : UITableView!
    @IBOutlet weak var selectTable : UITableView!
    @IBOutlet weak var totalCalorieLabel : UILabel!
//    @IBOutlet weak var foodSearch : UISearchBar!

    
    var foods : [Food] = []
    var filteredFoods = [Food]()
    var totalCalorie : Int = 0
    

    var selectList = [Food]()
    
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.foodTable.delegate = self
        self.foodTable.dataSource = self
        self.selectTable.delegate = self
        self.selectTable.dataSource = self

        guard let dataAsset : NSDataAsset = NSDataAsset(name : "foods2") else {
            print("데이터 에셋 로드 실패")
            return
        }
        
        let jsonData : Data = dataAsset.data
        let decoder : JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        
        do {
            foods = try decoder.decode([Food].self, from: jsonData)
        } catch {
            print("json decode failed" + error.localizedDescription)
        }
        filteredFoods = foods

        print("음식 \(foods.count)개 로드됨")
        foodTable.reloadData()
        selectTable.reloadData()
        
//        self.foodSearch.delegate = self
//        self.foodSearch.placeholder = "Input food name"
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        foodTable.tableHeaderView = searchController.searchBar
        
        self.foodTable.register(UITableViewCell.self, forCellReuseIdentifier: "upcell")
        // Do any additional setup after loading the view.
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredFoods = foods
        } else {
            // Filter the results
            filteredFoods = foods.filter { ($0.name?.lowercased().contains(searchController.searchBar.text!.lowercased()))! }
        }
        
        self.foodTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView{
        case foodTable :
            numberOfRow = filteredFoods.count
        case selectTable :
            numberOfRow = selectList.count
        default :
            print("Something Wrong1")
        }
    
        return numberOfRow
//        return self.filteredFoods.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        var cell = UITableViewCell()
        switch tableView {
        case foodTable :
            cell = tableView.dequeueReusableCell(withIdentifier: "upCell", for: indexPath)
            cell.textLabel?.text = self.filteredFoods[indexPath.row].name
            cell.detailTextLabel?.text = String(self.filteredFoods[indexPath.row].calorie!)+" kcal"
        case selectTable :
            cell = tableView.dequeueReusableCell(withIdentifier: "downCell", for: indexPath)
            cell.textLabel?.text = self.selectList[indexPath.row].name
            cell.detailTextLabel?.text = String(self.selectList[indexPath.row].calorie!)+" kcal"
        default :
            print("Something Wrong2")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch tableView{
        case selectTable :
            return true
        default :
            return false
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch tableView{
        case selectTable :
            if editingStyle == .delete {
//                let foodsArray = Array(self.foods)
//                let food = foodsArray[indexPath.row]
                
                totalCalorie -= selectList[indexPath.row].calorie!
                totalCalorieLabel.text? = String(totalCalorie)+" kcal"
                self.selectList.remove(at: indexPath.row)
                

                selectTable.reloadSections(IndexSet(0...0), with: .automatic)
            }
        default :
            print("Something Wrong3")
    
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case foodTable :
//            let selectName : String?
//            let selectCalorie : String?
//            let newFoods : [Food] = []
//            selectName = filteredFoods[indexPath.row].name
//            selectCalorie = filteredFoods[indexPath.row].calorie
            let selectFood : Food = filteredFoods[indexPath.row]
            selectList.append(selectFood)
            print("sth selected")
            print("\(selectList)")
            selectTable.reloadData()
            totalCalorie += selectFood.calorie!
            totalCalorieLabel.text? = String(totalCalorie) + " kcal"
        default :
            print("default")
        }
    }
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

