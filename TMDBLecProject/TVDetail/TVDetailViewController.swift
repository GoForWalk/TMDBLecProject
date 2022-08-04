//
//  TVDetailViewController.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/04.
//

import UIKit

import Kingfisher
import Alamofire
import SwiftyJSON

struct ActorInfo {
    
    var actorName: String
    var actorImageURLString: String?
    var characterName: String
}

class TVDetailViewController: UIViewController {

    enum TableSection: Int, CaseIterable {
        case overview, cast
    }
    
    var trendData: TrendData?

    var actorArray: [ActorInfo] = []
    
    @IBOutlet weak var wildImageView: UIImageView!
    @IBOutlet weak var thumbnailView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var opacityView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        adoptProtocol()
        fetchTVData()
    }
}

// MARK: UISet, FetchData
extension TVDetailViewController {

    func adoptProtocol() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: CastingTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CastingTableViewCell.identifier)
        tableView.register(UINib(nibName: OverviewTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OverviewTableViewCell.identifier)
    }

    func setUI() {
        guard let url = URL(string: "\(EndPoint.imageURL)\(trendData!.wildImageURLString)") else { return }
         wildImageView.kf.setImage(with: url)
  
        guard let thumbnailURL = URL(string: "\(EndPoint.imageURL)\(trendData!.imageURLString)") else { return }
        thumbnailImageView.kf.setImage(with: thumbnailURL)
        
        titleLabel.text = trendData!.title
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = .white
        setImage()
    }
    
    func setImage() {
        opacityView.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }
    
    func fetchTVData() {
        
        let url = EndPoint.creditURL(tvID: trendData!.tvID)
        
        let quaryString: Parameters = ["api_key": APIKey.TMDB_KEY]
        
        AF.request(url, method: .get, parameters: quaryString).validate().responseData { response in
            
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                
                let tempData = json["cast"]
                
                tempData.forEach { (_ , json) in
                    
                    let actorName = json["original_name"].stringValue
                    let characterName = json["character"].stringValue
                    let actorImageURLString = json["profile_path"].string
                
                    self.actorArray.append(ActorInfo(actorName: actorName, actorImageURLString: actorImageURLString, characterName: characterName))
                }
                
                
                self.tableView.reloadSections(IndexSet(integer: TableSection.cast.rawValue), with: .none)
                
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension TVDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case TableSection.overview.rawValue:
            return "Overview"
        case TableSection.cast.rawValue:
            return "Cast"
        default: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case TableSection.overview.rawValue:
            return 1
        case TableSection.cast.rawValue:
            return actorArray.count
        default: return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case TableSection.overview.rawValue:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier, for: indexPath) as? OverviewTableViewCell else { return UITableViewCell() }
            
            cell.setData(str: trendData!.description)
            
            return cell
            
        case TableSection.cast.rawValue:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastingTableViewCell.identifier, for: indexPath) as? CastingTableViewCell else { return UITableViewCell() }
            
            cell.configueCell()
            cell.setData(actor: actorArray[indexPath.row])
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
}
