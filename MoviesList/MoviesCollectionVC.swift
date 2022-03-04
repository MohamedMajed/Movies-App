//
//  MoviesCollectionVC.swift
//  MoviesList
//
//  Created by Mohamed Maged on 07/02/2022.
//

import UIKit
import Kingfisher
import Alamofire
import Reachability
import CoreData

private let reuseIdentifier = "Cell"

class MoviesCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
   
   let reachability = try! Reachability()
   var movieArray = [MovieDetails]()
    var savedMovies: [NSManagedObject] = []

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
//        AF.request("https://api.androidhive.info/json/movies.json", method: .get).validate().responseJSON{ response in switch response.result{
//        case .success(_):
//            let jsonDecoder = JSONDecoder()
//            if let movie = try? jsonDecoder.decode([MovieDetails].self, from: response.data!){
//                self.movieArray = movie
//                self.collectionView.reloadData()
//
//            }
//        case .failure(let error):
//            print(error.localizedDescription)
//        }
//
//        }
        
        reachability.whenReachable = { [self] reachability in
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
                                self.collectionView.reloadData()
                                }

                            }
                            DispatchQueue.main.async {
                                self.save(movies: self.movieArray)
                            }
                        }catch{

                        }
                    }.resume()

                }

                print(self.retrieveSavedMovies()!)
                
            }else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")

            let alert = UIAlertController(title: "Connection Error", message: "No Internet Connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.movieArray = self.retrieveSavedMovies()!
            self.collectionView.reloadData()
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movieArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        // Configure the cell
        
        let url = URL(string: movieArray[indexPath.row].image)
        cell.movieImage.kf.setImage(with: url)
//        cell.movieImage.layer.cornerRadius = 200
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: UIScreen.main.bounds.width * 0.487, height: UIScreen.main.bounds.height * 0.25)
//
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: 100, height: 50)
//
//    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let details = self.storyboard?.instantiateViewController(withIdentifier: "detailsVC") as! DetailsVC
        
        details.movies = movieArray[indexPath.row]
        
        navigationController?.pushViewController(details, animated: true)
        
    }

    // MARK: UICollectionViewDelegate

    
    func save(movies: [MovieDetails]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        for myMovie in movies {
            let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: context)
            let movie = NSManagedObject(entity: entity!, insertInto: context)
            movie.setValue(myMovie.title, forKey: "title")
            movie.setValue(myMovie.rating, forKey: "rating")
            movie.setValue(myMovie.releaseYear, forKey: "releaseYear")
            movie.setValue(myMovie.image, forKey: "image")
            movie.setValue(myMovie.genre, forKey: "genre")
        }

        do {
                try context.save()
                print("Success")
            } catch {
                print("Error saving: \(error)")
            }

    }

    
    
    func retrieveSavedMovies() -> [MovieDetails]? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        var retrievedMovies: [MovieDetails] = []
        
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    guard let releaseYear = result.value(forKey: "releaseYear") as? Int else { return nil }
                    guard let title = result.value(forKey: "title") as? String else { return nil }
                    guard let rating = result.value(forKey: "rating") as? Double else { return nil }
                    guard let image = result.value(forKey: "image") as? String else { return nil }

                    guard let genres = result.value(forKey: "genre") as? [String] else { return nil }

                    let movie = MovieDetails(title: title, image: image, rating: rating, releaseYear: releaseYear, genre: genres)
                    retrievedMovies.append(movie)
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        return retrievedMovies
    }}
