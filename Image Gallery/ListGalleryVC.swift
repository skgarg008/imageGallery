//
//  ListGalleryVC.swift
//  Image Gallery
//
//  Created by Sandeep Kumar on 5/10/24.
//

import UIKit

class ListGalleryVC: UIViewController {

    //MARK:- ====== Outlets ======
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width/3
        layout.itemSize = .init(width: width, height: width)
        layout.sectionInset = .zero
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .red
        return collection
    }()
    
    //MARK:- ====== Variables ======
    var error: Error? = nil
    var arrayList: [ImageCollectionCellViewModel] = [] {
        didSet {
            print("arrayList: ", arrayList.count)
            collectionView.reloadData()
        }
    }
    
    //MARK:- ====== Life Cycle ======
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    }
    
    //MARK:- ====== Functions ======
    func initSetup() {
        // Sub Views
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        // Register Cells
        collectionView.register(UINib(nibName: ImageCollectionCell.identifier, bundle: nil), forCellWithReuseIdentifier: ImageCollectionCell.identifier)

        // REST API Call
        apiRequest()
    }
    
    func apiRequest() {
        ApiHelper.shared.fetchList {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let list):
                self.error = nil
                self.arrayList = list.map({ ImageCollectionCellViewModel($0) })
                
            case .failure(let error):
                print(error.localizedDescription)
                showError(error.localizedDescription)
                self.error = error
            }
        }
    }
    
    func showError(_ messgae: String) {
        let alert = UIAlertController(title: "Error", message: messgae, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }

}

extension ListGalleryVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionCell.identifier, for: indexPath) as? ImageCollectionCell else {
            fatalError("cell is not defined")
        }
        cell.objVModel = arrayList[indexPath.item]
        return cell
    }
}
