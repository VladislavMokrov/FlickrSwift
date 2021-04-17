//
//  PhotoViewController.swift
//  FlickrSwift
//
//  Created by Владислав Мокров on 15.04.2021.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var currentPhoto: UIImage?

    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.image = currentPhoto
        
    }
}
