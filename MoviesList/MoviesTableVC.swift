//
//  MoviesTableVC.swift
//  MoviesList
//
//  Created by Mohamed Maged on 02/02/2022.
//

import UIKit
import Reachability
import Alamofire


class MoviesTableVC: UITableViewController, addProtocol {
    let reachability = try! Reachability()
    func addMovieToList(movie: MovieDetails) {
        movieArray.append(movie)
        self.tableView.reloadData()
    }
    
    var movie1 = MovieDetails(title: "The God Father", image: "TheGodFather", rating: 4.5, releaseYear: 1930, genre: ["Drama" , "Action"])
    var movie2 = MovieDetails(title: "Spiderman", image: "SpiderMan", rating: 4, releaseYear: 2022, genre: ["Drama", "Action", "Comedy"])
    var movie3 = MovieDetails(title: "Avengers", image: "Avengers", rating: 3.5, releaseYear: 2020, genre: ["Drama", "Action"])
    var movie4 = MovieDetails(title: "Hacksaw Ridge", image: "HacksawRidge", rating: 4, releaseYear: 2018, genre: ["Action", "War"])
    var movie5 = MovieDetails(title: "Eternals", image: "Eternals", rating: 2.5, releaseYear: 2020, genre: ["Drama", "Action"])
    
    var movieArray = [MovieDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieArray.append(movie1)
        movieArray.append(movie2)
        movieArray.append(movie3)
        movieArray.append(movie4)
        movieArray.append(movie5)
        navigationItem.title = "Movies"
        
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                let url = URL(string: "https://api.androidhive.info/json/movies.json")
                if let url = url {
                    let req = URLRequest(url: url)

                    let session = URLSession(configuration: URLSessionConfiguration.default)

                    let task = session.dataTask(with: req) { data, response, error in
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [Dictionary<String, Any>]
                            for i in 0...json.count-1{
                            var mov = MovieDetails()
                            mov.title = json[i]["title"] as! String
                            mov.rating = json[i]["rating"] as! Double
                            mov.releaseYear = json[i]["releaseYear"] as! Int
                            mov.genre = json[i]["genre"] as! [String]
                            mov.image = json[i]["image"] as! String

                                self.movieArray.append(mov)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }

                            }
                        }catch{

                        }
                    }.resume()

                }

            }else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")

            let alert = UIAlertController(title: "Error", message: "No Internet Connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
//        AF.request("https://api.androidhive.info/json/movies.json", method: .get).validate().responseJSON{ response in switch response.result{
//        case .success(_):
//            let jsonDecoder = JSONDecoder()
//            if let movie = try? jsonDecoder.decode([MovieDetails].self, from: response.data!){
//               self.movieArray = movie
//                self.tableView.reloadData()
//                //print(self.movieArray)
//            }
//        case .failure(let error):
//            print(error.localizedDescription)
//        }
//
//        }
        
    }
    @IBAction func addButton(_ sender: Any) {
        
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddMovieVC") as! AddMovieVC
        
        addVC.delegate = self
        
        self.navigationController?.pushViewController(addVC, animated: true)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movieArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = movieArray[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let details = self.storyboard?.instantiateViewController(withIdentifier: "detailsVC") as! DetailsVC
        
        details.movies = movieArray[indexPath.row]
        
        navigationController?.pushViewController(details, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
