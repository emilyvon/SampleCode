
import UIKit
import ParseUI
import SKPhotoBrowser

class PhotoCollectionViewController: PFQueryCollectionViewController {
    
    var browser: SKPhotoBrowser!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UINib(nibName: PhotoCollectionViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: PhotoCollectionViewCell.cellIdentifier)
    }

    override init(collectionViewLayout layout: UICollectionViewLayout, className: String?) {
        super.init(collectionViewLayout: layout, className: className)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        objectsPerPage = 20
    }
    
    override func queryForCollection() -> PFQuery<PFObject> {
        let query = PFQuery(className: UserPhoto.parseClassName())
        query.cachePolicy = .cacheThenNetwork
        query.whereKey(UserPhoto.Field.user.rawValue, equalTo: PFObject(withoutDataWithClassName: DanceUser.tableName, objectId: DanceUser.current?.objectId!))
        return query
    }
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.cellIdentifier, for: indexPath) as? PhotoCollectionViewCell {
            cell.configCell(file: (self.objects[indexPath.row] as? UserPhoto)?.photo)
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let suitableSize = (self.view.frame.size.width - 3) / 4
        return CGSize(width: suitableSize, height: suitableSize)
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var images = [SKPhoto]()
        
        for userPhotoImage in SessionManager.shared.userPhotos {
            let skPhoto = SKPhoto.photoWithImage(userPhotoImage.userImage)
            images.append(skPhoto)
        }
        
        browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.row)
        browser.delegate = self
        SKPhotoBrowserOptions.displayAction = true
        SKPhotoBrowserOptions.displayDeleteButton = true
        present(browser, animated: true, completion: nil)

    }
}

extension PhotoCollectionViewController: SKPhotoBrowserDelegate {
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        let alert = UIAlertController(title: String(), message: "Delete this photo?", preferredStyle: UIAlertControllerStyle.alert)
        
        let actionOk = UIAlertAction(title: "Yes", style: .default) { (_) in
            
            CustomProgressView.shared.showProgressView(window: UIApplication.shared.keyWindow!)
            
            let photo = SessionManager.shared.userPhotos[index]
            
            let userPhoto = UserPhoto(objectId: photo.objectId, userImage: photo.userImage)
            
            // delete from db
            DataAccessManager.shared.deleteUserPhoto(with: userPhoto, completion: { (error) in
                
                CustomProgressView.shared.hideProgressView()
                
                if let err = error {
                    print("removePhoto error: \(err.localizedDescription)")
                    showAlertMessage(in: browser, title: String(), message: AppErrorCode.unknownError.description, handler: nil)
                } else {
                    SessionManager.shared.userPhotos.remove(at: index)
                    reload()
                    self.loadObjects()
                }
            })
        }
        let actionNo = UIAlertAction(title: "No", style: .cancel)
        
        alert.addAction(actionOk)
        alert.addAction(actionNo)
        browser.present(alert, animated: true, completion: nil)
    }
}
