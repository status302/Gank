//
//  ViewController.swift
//  Gank
//
//  Created by 程庆春 on 2017/1/8.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController {

    var tableView: UITableView?
    var tabbarView: TabbarView?

    var statusBarView: UIView?
    var refreshControl: UIRefreshControl?
    var resultJson: GankImageModel? {
        didSet {
            self.tableView?.reloadData()
        }
    }

    var activityView : UIActivityIndicatorView?
    
    var subModels = [GankResult]()
    
    var rootModel: GankDayModel?
    
    fileprivate var lastSelectedMasterIndexPath = IndexPath.init(row: Int(MAXINTERP), section: 1)
    fileprivate var willSelectedIndexPath: IndexPath?
    /// 展开状态
    var isExpanding = false
    var isSelectedSubCell = false

    var categoryDatas = [String]() {
        didSet {
            self.reloadTableViewSectionOne()
        }
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.clear

        let statusBar = UIView().then({
            $0.backgroundColor = UIColor(white: 1.0, alpha: 0.88)
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 10)
            $0.layer.shadowRadius = 20.0
            $0.layer.shadowOpacity = 1.0
            $0.alpha = 0.0
        })
        view.addSubview(statusBar)
        self.statusBarView = statusBar
        
        statusBar.snp.makeConstraints({
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.height.equalTo(20)
        })

        tableView = UITableView(frame: CGRect.zero, style: .grouped).then {
            $0.delegate = self
            $0.dataSource = self
            $0.bounces = true
            $0.isScrollEnabled = true
            $0.contentInset.bottom = 49.0
            $0.contentOffset = CGPoint.zero
            $0.backgroundColor = UIColor(hexString: "0x232329")
            
            $0.registerCell(HomeTopCell.self)
            $0.registerCell(HomeCategoryCell.self)
            $0.registerCell(HomeResultCell.self)
        }
        
        view.insertSubview(tableView!, at: 0)
        tableView?.snp.makeConstraints({
            $0.edges.equalTo(view)
        })

        activityView = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
            .then({
                $0.hidesWhenStopped = true
            })
        view.addSubview(activityView!)
        activityView?.snp.makeConstraints({
            $0.top.equalTo(self.view.snp.top).offset(370)
            $0.centerX.equalTo(self.view.snp.centerX)
        })
        activityView?.startAnimating()

        loadData()
    }

    deinit {
        tableView?.delegate = nil
        tableView?.dataSource = nil
    }

    fileprivate func reloadTableViewSectionOne() {
        let sections = IndexSet(integer: 1)
        tableView?.reloadSections(sections, with: .none)
    }

    private func loadData() {
        GankImageModel.fetchImages(gankType: .welfare) { [weak weakSelf = self] in
            weakSelf?.resultJson = $0
        }

        GankDayModel.getTodayResult(url: "2017/03/15") { [weak self] (dayModel) in
            self?.rootModel = dayModel
            self?.categoryDatas = dayModel?.category ?? [""]
            self?.activityView?.stopAnimating()
            self?.activityView = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.do({
            $0.setNavigationBarHidden(true, animated: false)
        })
        if let currentOffsetY = tableView?.contentOffset.y {
            if currentOffsetY < 20.0 {
                UIApplication.shared.isStatusBarHidden = true
            }
            else {
                UIApplication.shared.isStatusBarHidden = false
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return categoryDatas.count + subModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0  {
            let cell = tableView.dequeueReusableCell(indexPath) as HomeTopCell
            if resultJson != nil {
                cell.resultJson = self.resultJson
            }
            return cell
        }
        else {
            if subModels.count > 0 {
                if indexPath.row > lastSelectedMasterIndexPath.row
                    && indexPath.row <= (lastSelectedMasterIndexPath.row + subModels.count) {
                    let cell = tableView.dequeueReusableCell(indexPath) as HomeResultCell
                    let currentRow = indexPath.row - lastSelectedMasterIndexPath.row - 1
                    cell.model = subModels[currentRow]
                    return cell
                }
                else if indexPath.row < lastSelectedMasterIndexPath.row {
                    let cell = tableView.dequeueReusableCell(indexPath) as HomeCategoryCell
                    cell.categoryName = categoryDatas[indexPath.row]
                    return cell
                }
                else if indexPath.row > lastSelectedMasterIndexPath.row + subModels.count {
                    let cell = tableView.dequeueReusableCell(indexPath) as HomeCategoryCell
                    cell.categoryName = categoryDatas[indexPath.row - subModels.count]
                    return cell
                }
            }
            let cell = tableView.dequeueReusableCell(indexPath) as HomeCategoryCell
            cell.categoryName = categoryDatas[indexPath.row]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return TopScrollView.height
        }
        else if indexPath.section == 1 {
            if subModels.count > 0 {
                if indexPath.row > lastSelectedMasterIndexPath.row
                    && indexPath.row <= lastSelectedMasterIndexPath.row + subModels.count {
                    return 60
                }
            }
            return 58.0
        }
        return CGFloat.leastNormalMagnitude
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    //MARK: - select cell
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        willSelectedIndexPath = indexPath
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return indexPath
        }
        if cell.isMember(of: HomeCategoryCell.self) {
            isSelectedSubCell = false
            if isExpanding {
                if indexPath.row > lastSelectedMasterIndexPath.row {
                    return IndexPath(row: indexPath.row - subModels.count, section: indexPath.section)
                }
                return indexPath
            }
            return indexPath
        }
        else {
            isSelectedSubCell = true
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if isSelectedSubCell {
            isSelectedSubCell = false
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath),
            cell.isMember(of: HomeCategoryCell.self) {
            if subModels.count > 0 && isExpanding == true {
                var deletedIndexPaths = [IndexPath]()
                for i in 1...subModels.count {
                    deletedIndexPaths.append(IndexPath(row: i + indexPath.row, section: indexPath.section))
                }
                tableView.beginUpdates()
                tableView.deleteRows(at: deletedIndexPaths, with: .right)
                subModels.removeAll()
                tableView.endUpdates()
                isExpanding = false
            }
        }
        else {
            isSelectedSubCell = false
            isExpanding = false
            subModels.removeAll()
            reloadTableViewSectionOne()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1,
            let cell = tableView.cellForRow(at: indexPath),
            cell.isMember(of: HomeCategoryCell.self) {
            isSelectedSubCell = false

            if isExpanding == true,
                lastSelectedMasterIndexPath == indexPath {
                tableView.deselectRow(at: indexPath, animated: true)
                self.tableView(tableView, didDeselectRowAt: indexPath)
                return
            }

            lastSelectedMasterIndexPath = indexPath
            isExpanding = true

            let category = categoryDatas[indexPath.row]
            if category == GankType.android.rawValue {
                if let android = rootModel?.results?.android {
                    subModels.append(contentsOf: android)
                }
            }
            else if category == GankType.iOS.rawValue {
                if let ios = rootModel?.results?.ios {
                    subModels.append(contentsOf: ios)
                }
            }
            else if category == GankType.frontEnd.rawValue {
                if let frontEnd = rootModel?.results?.frontEnd {
                    subModels.append(contentsOf: frontEnd)
                }
            }
            else if category == GankType.other.rawValue {
                if let other = rootModel?.results?.others {
                    subModels.append(contentsOf: other)
                }
            }
            else if category == GankType.video.rawValue {
                if let video = rootModel?.results?.video {
                    subModels.append(contentsOf: video)
                }
            }
            else if category == GankType.welfare.rawValue {
                if let welfare = rootModel?.results?.welfare {
                    subModels.append(contentsOf: welfare)
                }
            }
            else if category == GankType.resource.rawValue {
                if let resource = rootModel?.results?.resource {
                    subModels.append(contentsOf: resource)
                }
            }
            
            var indexPaths = [IndexPath]()
            for index in 1...subModels.count {
                let ip = IndexPath(row: indexPath.row + index, section: indexPath.section)
                indexPaths.append(ip)
            }
            tableView.beginUpdates()
            tableView.insertRows(at: indexPaths, with: .top)
            tableView.endUpdates()
            tableView.scrollTo(atRow: lastSelectedMasterIndexPath.row + subModels.count, atSection: 1, animated: true)
        }
        else if indexPath.section == 1,
            let cell = tableView.cellForRow(at: indexPath),
            cell.isMember(of: HomeResultCell.self) {
            if categoryDatas[lastSelectedMasterIndexPath.row] == GankType.welfare.rawValue {
                //TODO: 福利部分
                print("++福利来了++")
            }
            else {
              let selectedIndex = indexPath.row - lastSelectedMasterIndexPath.row - 1
              if let urlStr = subModels[selectedIndex].url {
                let webController = SafariViewController.init(urlString: urlStr)
                self.tabBarController?.show(webController, sender: self)
              }
            }
            isSelectedSubCell = true
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let currentOffsetY = scrollView.contentOffset.y
            if currentOffsetY > 20 {
                UIApplication.shared.isStatusBarHidden = false
                statusBarView?.alpha = min(1.0, max(0.0, currentOffsetY/100.0))
            }
            else if currentOffsetY <= 0 {
                UIApplication.shared.isStatusBarHidden = true
                statusBarView?.alpha = 0.0
            }
        }
    }
}
