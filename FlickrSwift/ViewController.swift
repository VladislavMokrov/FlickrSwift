//
//  ViewController.swift
//  FlickrSwift
//
//  Created by Владислав Мокров on 11.04.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    var tagsModel: Welcome?
    var tagsForCollection: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Top 10 tags today"
        fetchData()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickPhotoCollectionSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let tag = tagsForCollection[indexPath.item]
            
            let photosCVC = segue.destination as! PhotosCollectionViewController
            photosCVC.currentTag = tag
        }
    }
    
    func fetchData() {
        let jsonUrlString = "https://www.flickr.com/services/rest/?method=flickr.tags.getHotList&api_key=0ecc4c74990e79aecd529db51f83dd76&count=10&format=json&nojsoncallback=1"
        
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) {( data, responce, error) in
            
            guard let data = data else { return }
            
            do {
                self.tagsModel = try Welcome.init(data: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error serialization json", error)
            }
        }.resume()
    }
    
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        
        let tags = tagsModel?.hottags.tag[indexPath.row]
        cell.tableLabel.text = tags?.content
        tagsForCollection.append(tags?.content ?? "")
        
        guard let firstPhoto = tags?.thmData.photos.photo [0] else { return }
        let farm = firstPhoto.farm
        let id = firstPhoto.id
        let secret = firstPhoto.secret
        let server = firstPhoto.server
        
        DispatchQueue.global().async {
            guard let imageUrl = self.convert(farm: farm, server: server, id: id, secret: secret) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                cell.tableImage.image = UIImage(data: imageData)
            }
        }
    }
    
    func convert(farm: Int, server: String, id:String, secret: String) -> URL? {
        return URL(string:"https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_c.jpg")
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagsModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")! as! TableViewCell
        
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
