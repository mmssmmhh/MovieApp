//
//  ViewController.swift
//  MovieApp
//
//  Created by Mohamed Kelany on 7/27/18.
//  Copyright © 2018 Mohamed Kelany. All rights reserved.
//

import UIKit
import Kingfisher

class MovieViewController: UIViewController {
    
    //MARK:- UI properties
    @IBOutlet weak var movieCollectionView: UICollectionView!
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresher
    }()
    
    
    //MARK:- properties and instance
    private let client = MovieClient()
    fileprivate let cellIdentifier = "MovieCell"
    var isLoading: Bool = false
    var movieListResults = [Movie]()
    var pageNum: Int = 1
    
    //MARK:- Refresher controller
    @objc fileprivate func handleRefresh() {
        self.refresher.endRefreshing()
        guard !isLoading else {
            return
        }
        isLoading = true
        loadMore()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        collectionViewConfiguration()
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        MovieFeeding(for: pageNum)
        
    }

    //MARK: configureCollectionView
    func collectionViewConfiguration() {
        movieCollectionView.addSubview(refresher)
        movieCollectionView.backgroundColor = .clear
        movieCollectionView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    //MARK: fetchMoreItemsOfMovie
    func MovieFeeding(for page: Int) {
        let parameters: [String: Any] = ["page": page]
        client.getFeedWithQueryParameters(from: .discoverMovie, and: parameters ) { [weak self] result in
            switch result {
            case .success(let movieFeedResult):
                self?.movieListResults += (movieFeedResult?.results)!
                if self?.movieListResults.count == nil { return }
                self?.movieCollectionView.reloadData()
            case .failure(let error):
                print("the error \(error)")
            }
        }
    }
    
    //MARK: fetchMoreItemsOfMovie
    func loadMore() {
        pageNum += 1
        MovieFeeding(for: pageNum)
    }
}

//MARK:- Collection View Delegate FlowLayout
extension MovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //getting screen width to set height and width of collection view cell item
        let screenWidth = UIScreen.main.bounds.width
        var width = (screenWidth - 30)/2
        width = width > 200 ? 200 : width
        return CGSize.init(width: width, height: width)
    }
}

//MARK:- Collection View Data Source
extension MovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return movieListResults.count
        }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let imagePath = "https://image.tmdb.org/t/p/w300\(movieListResults[indexPath.item].backdrop_path ?? "no image")"
        let url = URL(string: imagePath)
        cell.movieImageView.kf.setImage(with: url)
        cell.movieTitleLabel.text = movieListResults[indexPath.item].title
        return cell
    }
}

//MARK:- Collection View Delegate
extension MovieViewController: UICollectionViewDelegate{
    //Loading More items
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row ==  movieListResults.count - 1{
            loadMore()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //MARK:- Navigation to Movie Details
        let storyboard = UIStoryboard(name: "MovieDetails", bundle: nil)
        let MovieDetailsController = storyboard.instantiateViewController(withIdentifier :"MovieDetailsViewController") as! MovieDetailsViewController
        //passing data to other view controller
        MovieDetailsController.passingData["id"] = "\(movieListResults[indexPath.item].id ?? 0)"
        MovieDetailsController.passingData["year"] = movieListResults[indexPath.item].release_date!
        
        self.navigationController?.pushViewController(MovieDetailsController, animated: true)
    }
}
