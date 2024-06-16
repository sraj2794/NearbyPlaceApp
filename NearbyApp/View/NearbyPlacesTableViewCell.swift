//
//  NearbyPlacesTableViewCell.swift
//  NearbyApp
//
//  Created by Raj Shekhar on 16/06/24.
//

import UIKit

class NearbyPlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityIndicator.isHidden = true
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        placeImageView.layer.cornerRadius = 10
        placeImageView.layer.masksToBounds = true
        activityIndicator.hidesWhenStopped = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with venue: Venue) {
        placeLabel.text = venue.name
        addressLabel.text = venue.displayLocation
        // Assuming there's a placeholder image
        //placeImageView.image = UIImage(named: "placeholder")
//        
//        if let urlString = venue.imageURL, let url = URL(string: urlString) {
//            activityIndicator.startAnimating()
//            loadImage(from: url) { [weak self] image in
//                DispatchQueue.main.async {
//                    self?.activityIndicator.stopAnimating()
//                    self?.placeImageView.image = image
//                }
//            }
//        } else {
//            activityIndicator.stopAnimating()
//            placeImageView.image = UIImage(named: "placeholder")
//        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }.resume()
    }
}

