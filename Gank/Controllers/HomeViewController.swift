//
//  ViewController.swift
//  Gank
//
//  Created by 程庆春 on 2017/1/8.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var tableView: UITableView?
    var tabbarView: TabbarView?

    var statusBarView: UIView?
    var refreshControl: UIRefreshControl?
    var resultJson: GankImageModel? {
        didSet {
            DispatchQueue.safeMainQueue { [weak self] in
                self?.tableView?.reloadData()
            }
        }
    }
    
    var subModels = [String]()
    fileprivate var lastSelectedMasterIndexPath = IndexPath.init(row: Int(MAXINTERP), section: 1)
    var isExpanding = false

    var categoryDatas: [String] = {
        return ["iOS", "前端", "Android", "扩展资源", "福利", "休息视频"]
    }()
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isStatusBarHidden = true
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.clear
    
        navigationController?.do({
            $0.setNavigationBarHidden(true, animated: false)
        })

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
            
            $0.registerCell(HomeTopCell.self)
            $0.registerCell(HomeCategoryCell.self)
            $0.registerCell(HomeResultCell.self)
            
            $0.backgroundColor = UIColor(hexString: "0x232329")
        }
        
        view.insertSubview(tableView!, at: 0)
        tableView?.snp.makeConstraints({
            $0.edges.equalTo(view)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GankImageModel.fetchImages(gankType: .welfare) { [weak weakSelf = self] in
            weakSelf?.resultJson = $0
        }
    }

    
    deinit {
        tableView?.delegate = nil
        tableView?.dataSource = nil
    }

    func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) { 
            if #available(iOS 10.0, *) {
                self.tableView?.refreshControl?.endRefreshing()
            } else {
                // Fallback on earlier versions
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
                    && indexPath.row <= lastSelectedMasterIndexPath.row + subModels.count {
                    let cell = tableView.dequeueReusableCell(indexPath) as HomeResultCell
                    
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
                    return 40
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
        Log("Will select row at indexPath : \(indexPath)")
        if let cell = tableView.cellForRow(at: indexPath),
           cell.isKind(of: HomeResultCell.self) {
            return indexPath
        }
        else if let cell = tableView.cellForRow(at: indexPath),
            cell.isKind(of: HomeCategoryCell.self) {
            if indexPath.row < lastSelectedMasterIndexPath.row {
                return indexPath
            }
            else if indexPath.row > lastSelectedMasterIndexPath.row + subModels.count {
                return IndexPath(row: indexPath.row - subModels.count, section: 1)
            }
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        Log("Did deselect row at indexPath : \(indexPath)")
        if let cell = tableView.cellForRow(at: indexPath),
            cell.isKind(of: HomeCategoryCell.self) {
            if subModels.count > 0 && isExpanding == true {
                var deletedIndexPaths = [IndexPath]()
                for i in (lastSelectedMasterIndexPath.row + 1) ... (lastSelectedMasterIndexPath.row + subModels.count) {
                    deletedIndexPaths.append(IndexPath(row: i, section: 1))
                }
                tableView.beginUpdates()
                tableView.deleteRows(at: deletedIndexPaths, with: .automatic)
                subModels.removeAll()
                tableView.endUpdates()
                isExpanding = false
                
//                var reloadDataIndexPaths = [IndexPath]()
//                for i in lastSelectedMasterIndexPath.row ..< categoryDatas.count {
//                    let indexPath = IndexPath.init(row: i, section: 1)
//                    reloadDataIndexPaths.append(indexPath)
//                }
//                tableView.reloadRows(at: reloadDataIndexPaths, with: .none)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Log("Did select row at indexPath : \(indexPath)")
//        guard lastSelectedMasterIndexPath != indexPath, isExpanding != true else {
//            tableView.deselectRow(at: lastSelectedMasterIndexPath, animated: true)
//            self.tableView(tableView, didDeselectRowAt: lastSelectedMasterIndexPath)
//            lastSelectedMasterIndexPath = IndexPath(row: Int.max, section: 1)
//            isExpanding = false
//            return
//        }
        if indexPath.section == 1,
            let cell = tableView.cellForRow(at: indexPath),
            cell.isKind(of: HomeResultCell.self) {
            print("home result cell")
            return
        }
        
        if indexPath.section == 1,
            let cell = tableView.cellForRow(at: indexPath),
            cell.isKind(of: HomeCategoryCell.self) {
            if isExpanding == true, lastSelectedMasterIndexPath == indexPath {
                tableView.deselectRow(at: lastSelectedMasterIndexPath, animated: true)
                self.tableView(tableView, didDeselectRowAt: lastSelectedMasterIndexPath)
//                if lastSelectedMasterIndexPath.row == indexPath.row {
                lastSelectedMasterIndexPath = IndexPath(row: Int.max, section: 1)
                return
//                }
            }
            
            lastSelectedMasterIndexPath = indexPath
            isExpanding = true
            let appendingDatas = ["哈哈", "测试"]
            subModels.append(contentsOf: appendingDatas)
            tableView.beginUpdates()
            var indexPaths = [IndexPath]()
            for (index, data) in subModels.enumerated() {
                let ip = IndexPath(row: indexPath.row + index + 1, section: 1)
                indexPaths.append(ip)
            }
            tableView.insertRows(at: indexPaths, with: .bottom)
            tableView.endUpdates()
            
//            var reloadDataIndexPaths = [IndexPath]()
//            for i in indexPath.row ..< (subModels.count + categoryDatas.count) {
//                let indexPath = IndexPath(row: i, section: 1)
//                reloadDataIndexPaths.append(indexPath)
//            }
//            tableView.reloadRows(at: reloadDataIndexPaths, with: .none)
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == tableView {
//            let currentOffsetY = scrollView.contentOffset.y + 329.0
//            if currentOffsetY > 0 && currentOffsetY < 260 {
//                self.topScrollView?.snp.updateConstraints({
//                    $0.top.equalTo(view.snp.top).offset(-currentOffsetY)
//                })
//            }
//            else if currentOffsetY >= 260 {
//                self.topScrollView?.snp.updateConstraints({
//                    $0.top.equalTo(view.snp.top).offset(-260)
//                })
//            } else {
//                self.topScrollView?.snp.updateConstraints({
//                    $0.top.equalTo(view.snp.top)
//                })
//            }
//            
//            if currentOffsetY > 20 {
//                UIApplication.shared.isStatusBarHidden = false
//                statusBarView?.alpha = min(1.0, max(0.0, currentOffsetY/100))
//            }
//            else if currentOffsetY <= 0 {
//                UIApplication.shared.isStatusBarHidden = true
//                statusBarView?.alpha = 0.0
//            }
//        }
    }
}
