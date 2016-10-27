//
//  PhotoDataSource.swift
//  SelfSnap
//
//  Created by Alexander Nelson on 10/27/16.
//  Copyright © 2016 JetWolfe Labs. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PhotoDataSource: NSObject {
    fileprivate let collectionView: UICollectionView
    fileprivate let managedObjectContext = CoreDataController.sharedInstance.managedObjectContext
    fileprivate let fetchedResultsController: PhotoFetchedResultsController

    init(fetchRequest: NSFetchRequest<Photo>, collectionView: UICollectionView) {
        self.collectionView = collectionView

        self.fetchedResultsController = PhotoFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, collectionView: collectionView)
    }
}

// MARK: UICollectionViewDataSource

extension PhotoDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        return section.numberOfObjects
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell

        let photo = fetchedResultsController.object(at: indexPath)
        cell.imageView.image = photo.photoImage

        return cell
    }
}
