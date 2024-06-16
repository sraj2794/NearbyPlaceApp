//
//  NearbyPlacesViewController.swift
//  NearbyApp
//
//  Created by Raj Shekhar on 15/06/24.
//

import UIKit

class NearbyPlacesViewController: UIViewController {
    @IBOutlet weak var mainTableView: UITableView! {
        didSet{
            mainTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 140, right: 0)
        }
    }
    
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var retsurantDistanceLabel: UILabel!
    @IBOutlet weak var searchPlaceTextField: UITextField!
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        retsurantDistanceLabel.text = "Restaurants within \(value) Km"
        viewModel.filterDistance = Double(value)
        viewModel.resetPagination()
    }
    private var viewModel = VenuesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        registerXIB()
        setupUI()
        setupBindings()
        // Set initial user location (for example, Bangalore coordinates)
        viewModel.setUserLocation(lat: 12.9569, lon: 77.7015)

        // Fetch venues within 5 km radius by default
        viewModel.fetchVenues()
    
        searchPlaceTextField.delegate = self
    }
    
    fileprivate func registerXIB() {
        mainTableView.register(NearbyPlacesTableViewCell.nib, forCellReuseIdentifier: NearbyPlacesTableViewCell.className)
        //  mainTableView.register(UINib(nibName: "NearbyPlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "NearbyPlacesTableViewCell")
    }
    
    private func setupUI() {
        distanceSlider.minimumValue = 1
        distanceSlider.maximumValue = 50
        distanceSlider.value = 5
        // Slider Label
        retsurantDistanceLabel.text = "Restaurants within \(Int(distanceSlider.value)) Km"
    }
    
    private func setupBindings() {
        viewModel.updateHandler = { [weak self] in
            DispatchQueue.main.async {
                self?.mainTableView.reloadData()
            }
        }
        
        viewModel.errorHandler = { [weak self] error in
            DispatchQueue.main.async {
                self?.showError(error)
            }
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

//MARK: UITableViewDelegateMethods, UITableViewDataSourceMethods
extension NearbyPlacesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredVenues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NearbyPlacesTableViewCell.self), for: indexPath) as?  NearbyPlacesTableViewCell  else { return UITableViewCell() }
        guard indexPath.row < viewModel.filteredVenues.count else {
            return cell
        }
        let venue = viewModel.filteredVenues[indexPath.row]
        cell.configure(with: venue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - UITextFieldDelegate
extension NearbyPlacesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        print("Search text: \(searchText)")
        viewModel.searchVenuesLocally(by: searchText)
    }
}
