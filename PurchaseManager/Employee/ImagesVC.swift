//
//  ImagesVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 12/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import MWPhotoBrowser
import PINRemoteImage

class ImagesVC: UIViewController {

   
    @IBOutlet var carImagesCollectionView: UICollectionView!
  
    @IBOutlet var commentView: UITextView!
    @IBOutlet var commentViewHeightCinstraints: NSLayoutConstraint!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
   
    var imagesArray = [ImagesListModel]()
    var MWImagesArr = [MWPhoto]()

    var vehicleId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        gettingImagesArray()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onTapBackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func gettingImagesArray(){
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()

        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix:CUrls.vehicle.Evaluated_VehicleAllPartsImages +  "?vehicleId=" + vehicleId , method: .get, contentType: .urlencode, params: [:], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()

            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {

                switch response.result {
                    
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess{
                        print(jsonResponse.response)
                        let jsonArr = jsonResponse.response.dictionaryValue
                        self.commentView.text = jsonArr["comments"]!.stringValue
                        self.commentViewHeightCinstraints.constant = self.commentView.contentSize.height
                        
                        let jsonDic = jsonResponse.response["ImagesInfo"].arrayValue
                        jsonDic.forEach({ (data) in
                            self.imagesArray.append(ImagesListModel.init(data: data))
                        })
                        self.collectionViewHeight.constant = 420
                       
                        self.carImagesCollectionView.reloadData()
                        
                    }
                        
                    else {
                        self.view.ShowBlackTostWithText(message: jsonResponse.responseMessage, Interval: 3)
                        
                    }
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    Message.SomethingWrongAlert(self)
                    self.dismiss(animated: true, completion: nil)
                    break
                }
            }
        }
    }
    

}
extension ImagesVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath)as!  ImagesCollectionViewCell
        cell.positionLabel.text = imagesArray[indexPath.row].labelName
        if imagesArray[indexPath.row].labelImage.count == 0 {
            cell.vehicleImages.image = #imageLiteral(resourceName: "NoImage")
        }else {
            cell.vehicleImages.pin_updateWithProgress = true
            
            let aString = self.imagesArray[indexPath.row].labelImage
            let newString = aString!.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            cell.vehicleImages.pin_setImage(from: URL(string: newString)!, placeholderImage: #imageLiteral(resourceName: "NoImage"))
        }
        
//        if let imageurl = URL.init(string: imagesArray[indexPath.row].labelImage) {
//            if let image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: imageurl.absoluteString) {
//                cell.vehicleImages.image = image
//            }
//            else {
//                cell.vehicleImages.kf.setImage(with: imageurl, placeholder: #imageLiteral(resourceName: "NoImage"), options: nil, progressBlock: nil, completionHandler: { (image, error, _ , gettingimageurl) in
//                    if (gettingimageurl?.absoluteString)! == imageurl.absoluteString {
//                        cell.vehicleImages.image = image
//                    }
//                })
//            }
//        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //CGSize.init(width: self., height: 100)
        //        let width  = (view.frame.width-20)/3
        return CGSize(width:collectionView.frame.size.width/3 - 10, height: 100)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        MWImagesArr.removeAll()
        if imagesArray[indexPath.row].labelImage != "" {
            
            for Images in imagesArray.enumerated(){
                if imagesArray[Images.offset].labelImage == "" {
                    
                }else{
                    MWImagesArr.append(MWPhoto.init(url: URL.init(string: imagesArray[Images.offset].labelImage)!))
                }
            }
            
            let browser = MWPhotoBrowser(delegate: self)
            browser?.displayActionButton = false
            browser?.displayNavArrows = false
            browser?.displaySelectionButtons = false
            browser?.zoomPhotosToFill = true
            browser?.alwaysShowControls = false
            browser?.enableGrid = true
            browser?.startOnGrid = false
            browser?.autoPlayOnAppear = false
            
            browser?.setCurrentPhotoIndex(UInt(indexPath.row))
            browser?.customImageSelectedIconName = imagesArray[indexPath.row].labelName
            
            self.navigationController?.pushViewController(browser!, animated: true)
        }
        
    }
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.MWImagesArr.count)
    }
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if index < MWImagesArr.count {
            return MWImagesArr[Int(index)] as? MWPhotoProtocol
        }
        return nil;
    }
   
    
   
    
    
}

class ImagesCollectionViewCell:UICollectionViewCell{
    
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var vehicleImages: UIImageView!
}
