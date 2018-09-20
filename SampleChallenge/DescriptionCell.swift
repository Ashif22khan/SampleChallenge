//
//  DescriptionCell.swift
//  SampleChallenge
//
//  Created by ashif khan on 19/09/18.
//  Copyright © 2018 ashif khan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
protocol DescriptionCellProtocol :NSObjectProtocol{
    func closeMap(index:Int)
}
class DescriptionCell: UITableViewCell {
    let mapView = MKMapView(frame: CGRect.zero)
    let label = UILabel(frame: CGRect.zero)
    let icon = UIImageView(frame: CGRect.zero)
    let headerView = UIView(frame: CGRect.zero)
    let close = UIButton(type: UIButton.ButtonType.custom)
    var coords:CLLocationCoordinate2D?
    weak var delegate:DescriptionCellProtocol?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(self.mapView)
        self.addSubview(self.headerView)
        self.headerView.addSubview(self.label)
        self.headerView.addSubview(self.close)
        self.headerView.addSubview(self.icon)
        
        self.headerView.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width, height: 50)
        self.headerView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        self.headerView.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.6)
        
        
        let originH = self.headerView.bounds.origin
        let sizeH = self.headerView.bounds.size
        self.label.frame = CGRect(x: originH.x + 70, y: originH.y, width: sizeH.width - 100, height: 50)
        self.label.numberOfLines = 0
        self.label.autoresizingMask = [.flexibleWidth]
        self.label.textColor = UIColor.white
        
        self.close.frame = CGRect(x: sizeH.width - 40 , y: originH.y + 5, width: 35, height: 35)
        self.close.autoresizingMask = [.flexibleLeftMargin]
        self.close.setTitle("X", for: UIControl.State.normal)
        self.close.addTarget(self, action: #selector(DescriptionCell.closeTapped(sender:)), for: UIControl.Event.touchUpInside)
    
        self.icon.frame = CGRect(x: 10 , y: originH.y + 15, width: 55, height: 55)
        self.icon.roundedRect()
    
        self.mapView.frame = self.bounds
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 2.0
        self.insetsLayoutMarginsFromSafeArea = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public func configureMap(with title:String, andIcon icon:String){
        self.mapView.frame = self.bounds
        if let coords = self.coords {
            self.mapView.delegate = self
            let position = MKPointAnnotation()
            position.coordinate = CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude)
            self.mapView.addAnnotation(position)
            let viewRegion = MKCoordinateRegion(center: position.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: false)
            self.headerView.bringSubviewToFront(self.label)
            self.headerView.bringSubviewToFront(self.close)
            self.label.text = "  \(title)"
            self.icon.image = UIImage(data: try! Data(contentsOf: URL(string: icon)!, options: Data.ReadingOptions.alwaysMapped))
        }
    }
    @objc func closeTapped(sender:UIButton) {
        self.delegate?.closeMap(index: self.tag)
    }
}
extension DescriptionCell:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "posAnnotation") as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "posAnnotation")
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.pinTintColor = UIColor.red
        return annotationView
    }
}
