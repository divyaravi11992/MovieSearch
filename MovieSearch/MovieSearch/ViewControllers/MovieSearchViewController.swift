//
//  MovieSearchViewController.swift
//  MovieSearch
//
//  Created by Ravi, Divya on 9/9/19.
//  Copyright © 2019 Ravi, Divya. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController {
    
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var movieSearchResultTableView: UITableView!
    
    fileprivate var searchResults: MovieVM?
    
    fileprivate var imgCache: NSCache<NSString, UIImage> = NSCache()
    
    fileprivate lazy var movieSearchTasker: MovieSearchTaskerInterface = {
        let tasker = MovieSearchTasker()
        tasker.delegate = self
        return tasker
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        searchBar.delegate = self
    }
    
    private func setUpTableView() {
        movieSearchResultTableView.separatorStyle = .none
        movieSearchResultTableView.tableFooterView = UIView(frame: .zero)
        movieSearchResultTableView.separatorInset = .zero
        movieSearchResultTableView.dataSource = self
        movieSearchResultTableView.register(UINib(nibName: String(describing: MovieSearchResultTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: MovieSearchResultTableViewCell.self))
    }
    
    fileprivate func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    fileprivate func refreshTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.movieSearchResultTableView.reloadData()
        }
    }
}

//MARK: - UISearchBarDelegate
extension MovieSearchViewController: UISearchBarDelegate {
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { searchResults?.movies.removeAll()
            refreshTableView()
            return }
        movieSearchTasker.searchMovie(searchText)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults?.movies.removeAll()
        refreshTableView()
    }
    
}

//MARK: - UITableViewDataSource
extension MovieSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.movies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieSearchResultTableViewCell.self)),
            let movieCell = cell as? MovieSearchResultTableViewCell
            else { return UITableViewCell() }
        movieCell.title.text = searchResults?.movies[indexPath.row].title
        movieCell.overview.text = searchResults?.movies[indexPath.row].overview
        
        if let posterString = searchResults?.movies[indexPath.row].poster as NSString?, let poster = imgCache.object(forKey: posterString) {
            movieCell.poster.image = poster
        } else if let url = URL(string: searchResults?.movies[indexPath.row].poster ?? "") {
            getDataFromUrl(url: url) { [weak self] (data, response, error) in
                guard let strongSelf = self else { return }
                guard let data = data,
                    error == nil,
                    indexPath.row < strongSelf.searchResults?.movies.count ?? 0,
                    let posterString = strongSelf.searchResults?.movies[indexPath.row].poster as NSString? else { return }
                DispatchQueue.main.async() {
                    guard let fetchedImg = UIImage(data: data) else { return }
                    movieCell.poster.image = fetchedImg
                    self?.imgCache.setObject(fetchedImg, forKey: posterString)
                }
            }
        }
        return movieCell
    }
}

//MARK: - Movie Search Tasker Delegate
extension MovieSearchViewController: MovieSearchTaskerDelegate {
    func didSucceedSearchingMovie(_ tasker: MovieSearchTaskerInterface, movies: MovieVM?) {
        searchResults = movies
        refreshTableView()
    }
    
    func didFailSearchingMovie(_ tasker: MovieSearchTaskerInterface, error: Error?) {
        // Code
    }
}
