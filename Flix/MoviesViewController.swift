//
//  ViewController.swift
//  Flix
//
//  Created by Phantom on 9/5/22.
//

import UIKit
import AlamofireImage


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
 
    
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self 
        // Do any additional setup after loading the view.
 
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 
                 
                 self.movies = dataDictionary["results"] as! [[String:Any]]
                 
                 self.tableView.reloadData()

    
                 // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell //prevents from overloading by using the recycle cell if not any recycle cell it'll create a new one
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string:  baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterURL!)
        
        return cell
    }
    
    //this is to prepare the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("loading..")
        
        //find the selective movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        //Pass the selective movie to the details ViewController
        let detailsViewController = segue.destination as! MovieDetaisViewController
        detailsViewController.movie = movie //calling movie from line88
        
        tableView.deselectRow(at: indexPath, animated: true)//to deselect the cell

    }

}

