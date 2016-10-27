//
//  PhotoMetaDataTableViewController.swift
//  SelfSnap
//
//  Created by Alexander Nelson on 10/26/16.
//  Copyright © 2016 JetWolfe Labs. All rights reserved.
//

import UIKit
import CoreLocation

class PhotoMetaDataTableViewController: UITableViewController {

    private let photo: UIImage

    init(photo: UIImage) {
        self.photo = photo

        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Metadata fields

    fileprivate lazy var photoImageView: UIImageView = {
        let imageView = UIImageView(image: self.photo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    fileprivate lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to add location"
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    fileprivate var locationManager: LocationManager!
    fileprivate var location: CLLocation!

    lazy var imageViewHeight: CGFloat = {
        let imageFactor = self.photoImageView.frame.size.height / self.photoImageView.frame.size.width
        let screenWidth = UIScreen.main.bounds.size.width
        return screenWidth * imageFactor
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }



}

extension PhotoMetaDataTableViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.selectionStyle = .none

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.contentView.addSubview(photoImageView)

            NSLayoutConstraint.activate([
                photoImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                photoImageView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
                photoImageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                photoImageView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor)
                ])
        case (1, 0):
            cell.contentView.addSubview(locationLabel)
            cell.contentView.addSubview(activityIndicator)

            NSLayoutConstraint.activate([
                locationLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                locationLabel.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 16.0),
                locationLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                locationLabel.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0),
                activityIndicator.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                activityIndicator.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0)
                ])
        default:
            break
        }

        return cell
    }
}

// MARK: UITableViewDelegate

extension PhotoMetaDataTableViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 0): return imageViewHeight
        default: return tableView.rowHeight
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            locationLabel.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            locationManager = LocationManager()
            locationManager.onLocationFix = {
                placemark, error in
                if let placemark = placemark {
                    self.location = placemark.location
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.locationLabel.isHidden = false

                    guard let name = placemark.name, let city = placemark.locality, let area = placemark.administrativeArea else { return }
                    self.locationLabel.text = "\(name), \(city), \(area)"
                }
            }
        default:
            break
        }
    }
}
