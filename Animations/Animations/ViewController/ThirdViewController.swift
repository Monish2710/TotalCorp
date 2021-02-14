//
//  ThirdViewController.swift
//  Animations
//
//  Created by Pyramidions on 13/02/21.
//

import UIKit
class ThirdCollectionCell: UICollectionViewCell
{
    
    
}
class ThirdViewController: UIViewController {

    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var playButton: UIButton!
    
    var attay = ["","","",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.layer.cornerRadius = 25
        collectionVIew.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func playButton(_ sender: Any) {
        let visibleItems : NSArray = self.collectionVIew.indexPathsForVisibleItems as NSArray
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        if nextItem.row < attay.count {
                    self.collectionVIew.scrollToItem(at: nextItem, at: .left, animated: true)
            }
    }
}

extension ThirdViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return attay.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThirdCollectionCell", for: indexPath) as! ThirdCollectionCell
//        cell.configure(with: DataManager.data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
