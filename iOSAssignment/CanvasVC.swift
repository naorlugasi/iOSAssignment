//
//  CanvasVC.swift
//  iOSAssignment
//
//  Created by Naor Lugassi on 12/12/17.
//  Copyright © 2017 Naor Lugassi. All rights reserved.
//

import UIKit

protocol RefreshDelegate: NSObjectProtocol {
    func refreshListDate()
}

class CanvasVC: UIViewController ,UICollectionViewDelegate ,UICollectionViewDataSource{

    @IBOutlet weak var brushSlider: UISlider!
    @IBOutlet weak var imgView: UIImageView!
    var lastPoint:CGPoint!
    var isSwiping:Bool!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!
    var selectedCanvas: UIImage?
    let startWork = Date()
    var startDate = Date()
    weak var delegate: RefreshDelegate?
    var workTime: Double = 0
    var brushColor: CGColor = UIColor.blue.cgColor
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func saveClicked(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(imgView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    @IBAction func eraseClicked(_ sender: Any) {
        brushColor = UIColor.white.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedImg = selectedCanvas {
            CanvasAPI.sharedInstance.deleteCanvas(startDate: startDate)
            imgView.image = selectedImg
        }
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func saveImage(){
        if let canvasImg = self.imgView.image {
            CanvasAPI.sharedInstance.save(image: canvasImg, startDate: startDate, endDate: Date(), totalTime: workTime + Date().offsetFrom(date: startWork))
            self.delegate?.refreshListDate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveImage()
    }
    
    //MARK: Touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        if let touch = touches.first{
            lastPoint = touch.location(in: imgView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        if let touch = touches.first{
            let currentPoint = touch.location(in: imgView)
            UIGraphicsBeginImageContext(self.imgView.frame.size)
            self.imgView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imgView.frame.size.width , height: self.imgView.frame.size.height))
    
            let context = UIGraphicsGetCurrentContext()
            context?.move(to: lastPoint)
            context?.addLine(to: currentPoint)
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(CGFloat(brushSlider.value))
            context?.setStrokeColor(brushColor)
            context?.strokePath()
            self.imgView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            lastPoint = currentPoint
        }
    }

    // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        cell.backgroundColor = .random() // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let color = (cell?.backgroundColor?.cgColor){
            brushColor = color
        }
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}




