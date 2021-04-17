//
//  PhotosCollectionViewController.swift
//  FlickrSwift
//
//  Created by Владислав Мокров on 14.04.2021.
//

import UIKit

class PhotosCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var photosModel: WelcomePh?
    var currentTag: String = ""
    
    let itemsPerRow: CGFloat = 3
    let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    func fetchData() {
        let jsonUrlString = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=0ecc4c74990e79aecd529db51f83dd76&tags=\(currentTag)&tag_mode=&per_page=10&page=&format=json&nojsoncallback=1"

        guard let url = URL(string: jsonUrlString) else { return }

        URLSession.shared.dataTask(with: url) {( data, responce, error) in

            guard let data = data else { return }

            do {
                self.photosModel = try WelcomePh.init(data: data)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch let error {
                print("Error serialization json", error)
            }
        }.resume()
    }
    
    private func configureCell(cell: PhotoCollectionViewCell, for indexPath: IndexPath) {
        
        guard let photos = photosModel?.photos.photo[indexPath.item] else { return }
        let farm = photos.farm
        let id = photos.id
        let secret = photos.secret
        let server = photos.server
        
        DispatchQueue.global().async {
            guard let imageUrl = self.convert(farm: farm, server: server, id: id, secret: secret) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                cell.collectionImage.image = UIImage(data: imageData)
            }
        }
    }
    
    func convert(farm: Int, server: String, id:String, secret: String) -> URL? {
        return URL(string:"https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_c.jpg")
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickPhotoSegue" {
            let photoVC = segue.destination as! PhotoViewController
            let cell = sender as! PhotoCollectionViewCell
            photoVC.currentPhoto = cell.collectionImage.image
        }
    }
 

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photosModel?.photos.photo.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        
        configureCell(cell: cell, for: indexPath)
        
        return cell
    }
    
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left

    }
}
