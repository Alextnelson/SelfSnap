//
//  PhotoFetchedResultsController.swift
//  SelfSnap
//
//  Created by Alexander Nelson on 10/27/16.
//  Copyright © 2016 JetWolfe Labs. All rights reserved.
//

import UIKit
import CoreData

class PhotoFetchedResultsController: NSFetchedResultsController<Photo>, NSFetchedResultsControllerDelegate {

    fileprivate let collectionView: UICollectionView
    init(fetchRequest: NSFetchRequest<Photo>, managedObjectContext: NSManagedObjectContext, collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }

    func executeFetch() {
        do {
            try performFetch()
        } catch let error as NSError {
            print("Unresolved error \(error.localizedDescription)")
        }
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }

}
