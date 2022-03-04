//
//  ViewController.swift
//  MoviesList
//
//  Created by Mohamed Maged on 02/02/2022.
//

import UIKit
import Cosmos
import Kingfisher


class DetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return movies.genre.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genre", for: indexPath)
        
        cell.textLabel?.text = movies.genre[indexPath.row]
      
        return cell
    }
    
    
    

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieRate: CosmosView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieReleaseYear: UILabel!
    
    
    var movies = MovieDetails()
    
    override func viewWillAppear(_ animated: Bool) {
       
        let url = URL(string: movies.image)
        movieImage.kf.setImage(with: url)
        movieImage.layer.cornerRadius = 150
        
        
        movieName.text = movies.title
        movieRate.rating = (movies.rating)/2.0
        movieReleaseYear.text = String(movies.releaseYear)
        	
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }


}

