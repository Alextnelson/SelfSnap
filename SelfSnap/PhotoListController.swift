//
//  ViewController.swift
//  SelfSnap
//
//  Created by Alexander Nelson on 10/20/16.
//  Copyright © 2016 JetWolfe Labs. All rights reserved.
//

import UIKit

class PhotoListController: UIViewController {

    lazy var cameraButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Camera", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(red: 254/255.0, green: 123/255.0, blue: 135/255.0, alpha: 1.0)

        button.addTarget(self, action: #selector(PhotoListController.presentImagePickerController), for: .touchUpInside)

        return button
    }()

    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager(presentingViewController: self)
        manager.delegate = self
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillLayoutSubviews() {
        // Camera Button Layout

        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cameraButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 56.0)
            ])
    }

    // MARK: Image Picker Controller
    @objc private func presentImagePickerController() {
        mediaPickerManager.presentImagePickerController(animated: true)
    }



}

//MARK: -MediaPickerManagerDelegate

extension PhotoListController: MediaPickerManagerDelegate {
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        //TO DO

        let eaglContext = EAGLContext(api: .openGLES2)
        let ciContext = CIContext(eaglContext: eaglContext!)

        let photoFilterViewController = PhotoFilterViewController(image: image, context: ciContext, eaglContext: eaglContext!)
        let navigationController = UINavigationController(rootViewController: photoFilterViewController)

        manager.dismissImagePickerController(animated: true) {
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}

