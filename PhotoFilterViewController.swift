//
//  PhotoFilterViewController.swift
//  SelfSnap
//
//  Created by Alexander Nelson on 10/26/16.
//  Copyright © 2016 JetWolfe Labs. All rights reserved.
//

import UIKit

class PhotoFilterViewController: UIViewController {

    fileprivate var mainImage: UIImage {
        didSet {
            photoImageView.image = mainImage
        }
    }
    fileprivate let context: CIContext
    fileprivate let eaglContext: EAGLContext

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var filterHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a filter"
        label.textAlignment = .center
        return label
    }()

    lazy var filtersCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 1000
        flowLayout.itemSize = CGSize(width: 100, height: 100)

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(FilteredImageCell.self, forCellWithReuseIdentifier: FilteredImageCell.resuseIdentifier)

        return collectionView
    }()

    fileprivate lazy var filteredImages: [CIImage] = {
        let filteredImageBuilder = FilterImageBuilder(context: self.context, image: self.mainImage)
        return filteredImageBuilder.imageWithDefaultFilters()
    }()

    init(image: UIImage, context: CIContext, eaglContext: EAGLContext) {
        self.mainImage = image
        self.photoImageView.image = self.mainImage
        self.context = context
        self.eaglContext = eaglContext
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PhotoFilterViewController.dismissPhotoFilterViewController))
        navigationItem.leftBarButtonItem = cancelButton

        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(PhotoFilterViewController.presentMetaDataController))
        navigationItem.rightBarButtonItem = nextButton
    }

    override func viewWillLayoutSubviews() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)

        filterHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterHeaderLabel)

        filtersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersCollectionView)

        NSLayoutConstraint.activate([
            filtersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filtersCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            filtersCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            filtersCollectionView.heightAnchor.constraint(equalToConstant: 200.0),
            filtersCollectionView.topAnchor.constraint(equalTo: filterHeaderLabel.bottomAnchor),
            filterHeaderLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            filterHeaderLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: filtersCollectionView.topAnchor),
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }

}



//MARK: UICollectionViewDataSource
extension PhotoFilterViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteredImageCell.resuseIdentifier, for: indexPath) as! FilteredImageCell

        let ciImage = filteredImages[indexPath.row]
        cell.ciContext = context
        cell.eaglContext = eaglContext
        cell.image = ciImage

        return cell
    }
}


//MARK: UICollectionViewDelegate

extension PhotoFilterViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ciImage = filteredImages[indexPath.row]

        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        mainImage = UIImage(cgImage: cgImage!)

    }
}

// MARK: Navigation

extension PhotoFilterViewController {

    @objc func dismissPhotoFilterViewController() {
        dismiss(animated: true, completion: nil)
    }

    @objc func presentMetaDataController() {
        let photoMetaDataController = PhotoMetaDataTableViewController(photo: self.mainImage)
        self.navigationController?.pushViewController(photoMetaDataController, animated: true)
    }
}





