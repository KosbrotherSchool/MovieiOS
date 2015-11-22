import UIKit

class HallaViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {
    
    
    @IBOutlet weak var topCollectionView: UICollectionView!
    
    
    @IBOutlet weak var bottomCollectionView: BoardCollectionView!
    
    
    var str_array = ["aaa", "bbb", "ccc", "dddd", "eeeee", "sdfsdf","dfdsf"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomCollectionView.delegate = bottomCollectionView.self
        bottomCollectionView.dataSource = bottomCollectionView.self
        
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        topCollectionView.pagingEnabled = true
    }
    
    // MARK data source
    // how many section in the collection view, most 1
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // how many cell in the collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return str_array.count
    }
    
    // what look for every cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PromoteCell", forIndexPath: indexPath) as! PromoteCell
        cell.label.text = str_array[indexPath.row]
        return cell
    }
    
    // MARK delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    // width and height of every cell
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let cell_width = collectionView.frame.size.width
            let cell_height = collectionView.frame.size.height
            return CGSize(width: cell_width, height: cell_height)
            
            
    }
    
    
    
    
}