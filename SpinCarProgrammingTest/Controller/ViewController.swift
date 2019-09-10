//
//  ViewController.swift
//  SpinCarProgrammingTest
//
//  Created by Aaron Treinish on 9/4/19.
//  Copyright © 2019 Treinish. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var maximumNumberTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    
    var images = [Image]()

    var countString = ""
    var searchedString = ""

    var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.tableView.tableFooterView = UIView()

        setUpActivityIndicator()

        setUpShadowAroundSearchView()
    }

    // Sets up the shadow and rounded corners around the searchView
    func setUpShadowAroundSearchView() {
        searchView.layer.cornerRadius = 10
        
        searchView.layer.shadowColor = UIColor.black.cgColor
        searchView.layer.shadowOpacity = 1
        searchView.layer.shadowOffset = .zero
        searchView.layer.shadowRadius = 10

        searchView.layer.shadowPath = UIBezierPath(rect: searchView.bounds).cgPath
        searchView.layer.shouldRasterize = true
        searchView.layer.rasterizationScale = UIScreen.main.scale
    }

    // Setting up the activity indicator programmatically so it is always centered in the middle
    func setUpActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
    }

    // Parse JSON from Bing Image Search API
    func fetchImages(completion: @escaping ([Image]) -> Void) {
        let url = URL(string: "https://api.cognitive.microsoft.com/bing/v7.0/images/search?q=\(searchedString)&count=\(countString)")!

        var request = URLRequest(url: url)
        request.addValue("65a67afed34b4eb3a66813543a01df76", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        // fetch data
        URLSession.shared.dataTask(with: request) {(data, response, error) in

            // to avoid non optional in JSONDecoder
            guard let data = data else { return }

            var images = [Image]()

            do {
                // decode object
                let decoder = JSONDecoder()
                let downloadedData = try decoder.decode(ImagesResult.self, from: data)
                images.append(contentsOf: downloadedData.images)

                DispatchQueue.main.async {
                    completion(images)
                }

            } catch {
                print(error)
            }

        }.resume()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ImagesTableViewCell else { return UITableViewCell() }

        cell.searchedImage.loadImageUsingCacheWithUrlString(urlString: images[indexPath.row].thumbnailURL)

        return cell
    }

    // Checks if the number is prime by checking the divisibility of only formula integers
    // Does not check redundant numbers
    func isPrimeNumber(number: Int) -> Bool {
        guard number >= 2     else { return false }
        guard number != 2     else { return true  }
        guard number % 2 != 0 else { return false }
        return !stride(from: 3, through: Int(sqrt(Double(number))), by: 2).contains { number % $0 == 0 }
    }

    func setUpAndShowAlert() {
        // Create the alert
        let alert = UIAlertController(title: "Error", message: "This is an invalid input. Either the number you selected is not prime or it is less than one.", preferredStyle: UIAlertController.Style.alert)

        // Add an action
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // Show the alert
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func enterButton(_ sender: Any) {
        // Sets the searchString to what you put in the textfield
        // Also gets rid of the extra white spaces so you can search something with spaces and the URL is correct
        if searchedString == "" {
            searchedString = searchTextField.text!.replacingOccurrences(of: " ", with: "")
        }

        // Sets the countString to what you put in the textfield
        // Also gets rid of the extra white spaces so you can pick a number something with spaces (no number has white space but I added it just in case a user puts a space after a the number) and the URL is correct
        if countString == "" {
            countString = maximumNumberTextField.text!.replacingOccurrences(of: " ", with: "")
        }

        // Converts the countString to an Int so I can check if it is a prime number or not
        let convertedCountString = Int(countString) ?? 0
        if !isPrimeNumber(number: convertedCountString) || convertedCountString <= 1 || countString == "" || searchedString == "" {
            setUpAndShowAlert()
        } else {
            activityIndicator.startAnimating()
            fetchImages(completion: updateImages)
        }

        // Dismiss keyboard after searching
        self.view.endEditing(true)

        // Clear all 3 of these so if a user does a new search the previous search results won't be there
        images.removeAll()
        searchedString.removeAll()
        countString.removeAll()
    }

    func updateImages(images: [Image]) {
        self.images = images
        self.activityIndicator.stopAnimating()
        self.tableView.reloadData()
        // Starts back at the top after new search
        if self.tableView.numberOfRows(inSection: 0) != 0 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}
