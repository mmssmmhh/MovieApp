//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Mohamed Kelany on 7/27/18.
//  Copyright © 2018 Mohamed Kelany. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos

class MovieDetailsViewController: UIViewController {
    
    //MARK:- UI properties
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var productCompaniesTableView: UITableView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieBudgetLabel: UILabel!
    @IBOutlet weak var movieTopicLabel: UILabel!
    
    //MARK:- properties & Instances
    fileprivate let cellIdentifier = "ProductCompaniesCell"
    fileprivate let cellHeight: CGFloat = 35.0
    var passingData: Dictionary = [String: String]()
    private let client = MovieClient()
    var movieDetailsResults = [MovieDetails]()
    var productCompaniesModel = [ProductionCompanies]()
    var genresModel = [Genres]()
    var isLoading: Bool = false


   

    //MARK:- Methods

    //Mark:- Loading viewing
    override func viewDidLoad() {
        super.viewDidLoad()
        productCompaniesTableView.delegate = self
        productCompaniesTableView.dataSource = self
        navigationControllerConfiguartion()
        tableViewConfiguration()
        MovieDetailsFeeding()
        
    }
    
    //MARK:- NAvigation Controller Configuration
    func navigationControllerConfiguartion() {
        
        title = "Loading......"
        let favButton = UIBarButtonItem(image: #imageLiteral(resourceName: "navbar_fav"), style: .plain, target: self, action: #selector(addToFavorite))
        // navigationItem.rightBarButtonItem = favButton
        
        let shareButton = UIBarButtonItem(image: #imageLiteral(resourceName: "navbar_share"), style: .plain, target: self, action: #selector(shareMovie))
        navigationItem.rightBarButtonItems = [shareButton, favButton]
        
    }
    
    @objc func addToFavorite(){
        //no actions but if we want we can put result in array of model and display on collection view or table view
    }
    @objc func shareMovie(){
        //no actions but if we want we can share movie title and it's attributes
    }
    
    //MARK:- Table View Configuration
    func tableViewConfiguration() {
        let nibfile = UINib.init(nibName: "ProductionCompaniesCell", bundle: nil)
        productCompaniesTableView.register(nibfile, forCellReuseIdentifier: cellIdentifier)
    }

    //MARK:- Fetching Movie Data to view
    func MovieDetailsFeeding() {

        client.getFeedWithPathParameters(from: .movieDetails, pathParameters: [passingData["id"]!]) { [weak self] result in
            switch result {
            case .success(let movieDetailsResult):
                print(movieDetailsResult?.overview ?? "nil")
                let imagePath = "https://image.tmdb.org/t/p/w500\(movieDetailsResult?.backdrop_path ?? "no image")"
               // "https://image.tmdb.org/t/p/w500\(movieDetailsResult!.backdrop_path! ))"
                print(imagePath)
                let url = URL(string: imagePath)
                self?.movieImageView.kf.setImage(with: url)
                self?.title = movieDetailsResult!.title!
                let fullDate = self?.passingData["year"]!.components(separatedBy: "-")
                let year = fullDate![0]
                self?.movieYearLabel.text = year
                self?.movieTitleLabel.text = movieDetailsResult!.title!
                self?.movieOverviewLabel.text = movieDetailsResult!.overview!
                self?.movieBudgetLabel.text = "\(movieDetailsResult!.budget!)"
                self?.cosmosView.rating = Double(movieDetailsResult!.vote_average!)/2.0
                self?.productCompaniesModel = (movieDetailsResult?.production_companies)!
                self?.productCompaniesTableView.reloadData()
                //genres fetching
                self?.genresModel = (movieDetailsResult?.genres)!
                self?.movieTopicLabel.text = ""
                for genre in (self?.genresModel)! {
                    self?.movieTopicLabel.text = ((self?.movieTopicLabel.text)! + "\(genre.name ?? "No Movie Topic")/")
                }

            case .failure(let error):
                print("the error \(error)")
            }
        }
    }
    


}

//MARK:- Table View Delegate
extension MovieDetailsViewController: UITableViewDelegate {
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
 
    
}
//MARK:- //MARK:- Table View Data Source
extension MovieDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(productCompaniesModel.count)
        return productCompaniesModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = productCompaniesTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProductionCompaniesCell else {
            return UITableViewCell()
        }
        let productCompanies = productCompaniesModel[indexPath.row]
        print(productCompanies.name ?? 0)
        
        cell.configureCell(productCompany: productCompanies)

        return cell
    }
    
    
}
