//
//  ImagePreviewVC.swift
//  Petara
//
//  Created by bd01 on 19/10/22.
//

import UIKit

class ImagePreviewVC: UIViewController {

    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var imgUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.maximumZoomScale = 4
         scrollView.minimumZoomScale = 1
        
        scrollView.delegate = self
        let imgBaseURL = "https://alitisdev.alitis.se/AlecomFirstResponderAPI/"
   
        let url = URL(string: "\(imgBaseURL)\(imgUrl)")
        
            imgPreview.kf.setImage(with: url)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension ImagePreviewVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
           return imgPreview
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imgPreview.image {
                let ratioW = imgPreview.frame.width / image.size.width
                let ratioH = imgPreview.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > imgPreview.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imgPreview.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > imgPreview.frame.height
                
                let top = 0.5 * (conditioTop ? newHeight - imgPreview.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
