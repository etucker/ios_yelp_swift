//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {

    var businesses: [Business]!
    var searchTerm = "Restaurants"
    var searchCategories: [String]? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140 // only used for scrollbar row height dimension
        
        search()
    }
    
    func search() {
        doSearch(searchTerm, categories: searchCategories)
    }

    func doSearch(term: String, categories: [String]? = nil) {
        Business.searchWithTerm(term, sort: .Distance,
            categories: categories, //["thai", "asianfusion", "burgers"],
            deals: true) { (businessesReturned: [Business]!, error: NSError!) -> Void in
                println(error)
                self.updateBusinessList(businessesReturned)
        }
    }
    
    func updateBusinessList(businesses: [Business]) {
        self.businesses = businesses
        self.tableView.reloadData()

//        for business in businesses {
//            println(business.name!)
//            println(business.address!)
//        }
    }
    
    // --- UISearchBarDelegate handling
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchTerm = searchBar.text
        search()
    }
    
    // TODO: Why doesn't this get called?
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        println("Search was cancelled")
        searchTerm = "Restaurants"
        search()
    }
    // --- end UISearchBarDelegate handling
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = self.businesses[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        
        searchCategories = categories
        search()
    }

}
