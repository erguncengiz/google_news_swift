//
//  ViewController.swift
//  Google News
//
//  Created by Ergün Yunus Cengiz on 8.01.2022.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var viewModel: NewsViewModel!

    let refreshControl = UIRefreshControl()
    
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(x: 10, y: 10, width: 200, height:700), collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(CustomCollectionViewCell.self,
                       forCellWithReuseIdentifier: CustomCollectionViewCell.cellIdentifier)
        collection.backgroundColor = .systemBackground
        return collection
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NewsViewModel()
        viewModel.beginFunc() {
            self.viewModel.insertNews {
                self.viewModel.readFromDatabase {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        refreshControl.attributedTitle = NSAttributedString(string: "")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        title = "Google News"
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        view.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.apiCallSubFunc {
            self.viewModel.insertNews {
                self.viewModel.readFromDatabase {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataFromAPI.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.cellIdentifier, for: indexPath
       ) as? CustomCollectionViewCell
        
        cell?.layer.masksToBounds = true
        cell?.layer.cornerRadius = 10
        cell?.layer.borderWidth = 1
        cell?.layer.borderColor = UIColor.gray.cgColor
        
        cell?.configure(with: viewModel.dataFromAPI[indexPath.row])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let new = viewModel.dataFromAPI[indexPath.row]
        guard let url = new.url else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIDevice.current.userInterfaceIdiom == .pad ? (view.frame.size.width - 41) / 2 : view.frame.size.width - 20, height: 380)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 16
        }
}




