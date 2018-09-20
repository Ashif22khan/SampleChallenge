//
//  ViewController.swift
//  SampleChallenge
//
//  Created by ashif khan on 18/09/18.
//  Copyright © 2018 ashif khan. All rights reserved.
//

import UIKit
import CoreLocation
enum CellType {
    case map
    case normal
}
class ViewController: UIViewController {
    var selectionIndex:Int = -1
    var table = UITableView(frame: CGRect.zero)
    var deliveryData = [DeliveryModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let params = ["offset":0, "limit":10]
        APIInterface.commonInterface.requestDataForDeliveries(with: params) { (data, error) in
            if let error = error{
                print("Error:\(error.localizedDescription)")
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let deliveryArray = try decoder.decode([DeliveryModel].self, from: data)
                    self.deliveryData.append(contentsOf: deliveryArray)
                    DispatchQueue.main.async {
                        self.table.delegate = self
                        self.table.dataSource = self
                        self.table.reloadData()
                    }
                } catch let err {
                    print("Err", err)
                }
            }
        }
        self.table.register(DetailCell.self, forCellReuseIdentifier: "detail")
        self.table.register(DescriptionCell.self, forCellReuseIdentifier: "description")
        self.view.addSubview(self.table)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.table.frame = self.view.frame
    }
}
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deliveryData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if selectionIndex != indexPath.row{
            var cell = tableView.dequeueReusableCell(withIdentifier: "detail") as? DetailCell
            if let _ = cell {
            }else{
                cell = DetailCell(style: .default, reuseIdentifier: "detail")
            }
            self.configureNormalCell(cell: cell!, indexPath: indexPath)
            return cell!
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "description") as? DescriptionCell
            if let _ = cell {
            }else{
                cell = DescriptionCell(style: .default, reuseIdentifier: "description")
            }
            cell?.delegate = self
            self.configureDescriptionCell(cell: cell!, indexPath: indexPath)
            return cell!
        }
    }
    func configureNormalCell(cell:UITableViewCell, indexPath: IndexPath){
        let model = self.deliveryData[indexPath.row]
        if let id = model.id{
            cell.tag = id
        }
        if let imageUrl = model.imageUrl{
            cell.imageView?.image = UIImage(data: try! Data(contentsOf: URL(string: imageUrl)!, options: Data.ReadingOptions.alwaysMapped))
            cell.imageView?.roundedRect()
        }
        if let description = model.description{
            if let location = model.location{
                if let address = location.address{
                    cell.textLabel?.text = "\(description) at \(address)"
                    cell.textLabel?.textAlignment = .right
                    cell.textLabel?.numberOfLines = 0
                }
            }
        }
    }
    func configureDescriptionCell(cell:DescriptionCell, indexPath: IndexPath){
        let model = self.deliveryData[indexPath.row]
        if let id = model.id{
            cell.tag = id
        }
        if let description = model.description{
            if let imageUrl = model.imageUrl{
                if let location = model.location{
                    if let address = location.address{
                        let title = "\(description) at \(address)"
                        if let lat = location.lat, let lng = location.lng{
                            cell.coords = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            cell.configureMap(with: title, andIcon: imageUrl)
                        }
                    }
                }
            }
        }
    }
}
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if selectionIndex == indexPath.row {
            return 300
        }
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectionIndex = indexPath.row
        tableView.reloadData()
    }
}
extension ViewController:DescriptionCellProtocol{
    func closeMap(index: Int) {
        self.selectionIndex = -1
        self.table.reloadData()
    }
}
