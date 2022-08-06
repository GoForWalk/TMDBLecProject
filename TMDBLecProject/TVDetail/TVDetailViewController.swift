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

final class TVDetailViewController: OrientationPortraitLockedViewController {

    enum TableSection: Int, CaseIterable {
        case overview, cast
    }
    
    var trendData: TrendData?
    let tmdbAPIManager = TMDBAPIManager.shared
    var isOverviewSectionTapped: Bool = false
    var isFirstLoaded = true
    
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

    private func adoptProtocol() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: CastingTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CastingTableViewCell.identifier)
        tableView.register(UINib(nibName: OverviewTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OverviewTableViewCell.identifier)
    }

    private func setUI() {
        guard let url = URL(string: "\(EndPoint.imageURL)\(trendData!.wildImageURLString)") else { return }
         wildImageView.kf.setImage(with: url)
  
        guard let thumbnailURL = URL(string: "\(EndPoint.imageURL)\(trendData!.imageURLString)") else { return }
        thumbnailImageView.kf.setImage(with: thumbnailURL)
        
        titleLabel.text = trendData!.title
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = .white

        opacityView.backgroundColor = .lightGray.withAlphaComponent(0.3)

    }
        
    private func fetchTVData() {
        tmdbAPIManager.fetchCastAPI(trendData: trendData) { actorInfo in
            self.actorArray.append(contentsOf: actorInfo)
            
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: TableSection.cast.rawValue), with: .fade)
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
            
            if isFirstLoaded {
                isFirstLoaded = false
                flipOverviewSection(isOverviewSectionTapped: isOverviewSectionTapped, indexPath: indexPath)
            }
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
    
    // automaticdemension
    // layout
    // numberOfLines
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        if indexPath.section == TableSection.overview.rawValue {
            flipOverviewSection(isOverviewSectionTapped: isOverviewSectionTapped, indexPath: indexPath)
        }
    }
    
    private func flipOverviewSection(isOverviewSectionTapped: Bool, indexPath: IndexPath) {
        
        switch isOverviewSectionTapped {
        case false:
            print("false")
            tableView.rowHeight = 120
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier, for: indexPath) as? OverviewTableViewCell else { return }
            
            cell.overviewLabel.numberOfLines = 2
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            self.isOverviewSectionTapped = true
        
        case true:
            print("true")
            tableView.rowHeight = UITableView.automaticDimension

            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier, for: indexPath) as? OverviewTableViewCell else { return }

            cell.overviewLabel.numberOfLines = 0
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            self.isOverviewSectionTapped = false
        }
        
    }
}
