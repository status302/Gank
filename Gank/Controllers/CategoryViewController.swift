//
//  CategoryViewController.swift
//  Gank
//
//  Created by 程庆春 on 2017/3/1.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryViewController: UIViewController {

    weak var bgView: CategoryTopScrollView?

    let disposedBag = DisposeBag()
    let item = ["haha", "test", "will", "animation"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = CategoryTopScrollView()
            .then({ [weak self] in
                $0.backgroundColor = UIColor.clear
                $0.frame = CGRect(x: 12, y: 0, width: UIScreen.mainWidth - 24, height: 44)
                self?.bgView = $0
                $0.addTarget(self, action: #selector(self?.valueChange(view:)), for: .touchUpInside)
            })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
            .then({
                $0.delegate = self
                $0.dataSource = self
                $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            })
        view.addSubview(tableView)
        tableView.snp.makeConstraints({
            $0.edges.equalTo(self.view)
        })
    }
    
    func valueChange(view: CategoryTopScrollView) {
        
    }

    func makeContraints() {
        guard let superView = bgView?.superview else {
            return
        }
        bgView?.snp.makeConstraints({
            $0.left.equalTo(superView.snp.left).offset(10)
            $0.top.equalTo(superView.snp.top)
            $0.bottom.equalTo(superView.snp.bottom)
            $0.right.equalTo(superView.snp.right).offset(-10)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Log(indexPath)
        Log("----\(tableView.indexPathForSelectedRow)")
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        Log(indexPath)
        return indexPath
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        Log(indexPath)
        return indexPath
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        Log(indexPath)
    }
}
