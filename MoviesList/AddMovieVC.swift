//
//  AddMovieVC.swift
//  MoviesList
//
//  Created by Mohamed Maged on 03/02/2022.
//

import UIKit

class AddMovieVC: UIViewController {

    var delegate: addProtocol?
    @IBOutlet weak var yearTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var rateTxt: UITextField!
    @IBOutlet weak var imgTxt: UITextField!
    @IBOutlet weak var genreTxt: UITextField!
    @IBAction func saveButton(_ sender: Any) {
        
//        let movieVC = self.storyboard?.instantiateViewController(withIdentifier: "MoviesTableVC") as! MoviesTableVC
        
        var movie = MovieDetails(title: nameTxt.text!, image: imgTxt.text!, rating: Double(rateTxt.text!)!, releaseYear: Int(yearTxt.text!)!, genre: [genreTxt.text!])
        
        delegate?.addMovieToList(movie: movie)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTxt.placeholder = "Enter Name"
        yearTxt.placeholder = "Enter Year"
        rateTxt.placeholder = "Enter Rate"
        imgTxt.placeholder = "Enter Image Name"
        genreTxt.placeholder = "Enter Genre"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
