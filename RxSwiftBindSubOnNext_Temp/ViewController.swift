//
//  ViewController.swift
//  RxSwiftBindSubOnNext
//
//  Created by V000273 on 08/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController, UIScrollViewDelegate {
    
    //    let tableViewItems = BehaviorRelay.init(value:[Food.init(name: "Humbergar", image: "humbergar"),
    //                                                   Food.init(name: "Pizza", image: "pizza"),
    //                                                   Food.init(name: "Eating", image: "eating"),
    //                                                   Food.init(name: "Ice Cream", image: "ice"),
    //                                                   Food.init(name: "Cafe", image: "cafe"),
    //                                                   Food.init(name: "Cake", image: "cake"),
    //                                                   Food.init(name: "Beer", image: "beer"),
    //                                                   Food.init(name: "CocaCola", image: "coca"),
    //                                                   Food.init(name: "Fluit", image: "fluit")])
    
    //data use SectionModel
    let tableViewItemSection = BehaviorRelay.init(value: [
        SectionModel(header: "Drink", items: [
            Food.init(name: "Humbergar", image: "humbergar", price: 10),
            Food.init(name: "Pizza", image: "pizza", price: 20),
            Food.init(name: "Eating", image: "eating", price: 30),
            Food.init(name: "Ice Cream", image: "ice", price: 40),
            Food.init(name: "Fluit", image: "fluit", price: 50)
        ]),
        SectionModel(header: "Food", items: [
            Food.init(name: "Cafe", image: "cafe", price: 12),
            Food.init(name: "Cake", image: "cake",price: 12),
            Food.init(name: "Beer", image: "beer", price: 12),
            Food.init(name: "CocaCola", image: "coca", price: 12)
        ])
    ])
    
    let bag = DisposeBag()
    @IBOutlet weak var searchBarView: UISearchBar!
    @IBOutlet weak var foodTableView: UITableView!
    
    var dataSoucres = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: {
        ds, tv, ip, item in
        let cell: FoodTableViewCell = tv.dequeueReusableCell(withIdentifier: "FoodTableViewCell", for: ip) as! FoodTableViewCell
        cell.foodname.text = item.name
        cell.imageName.image = UIImage.init(named: item.image ?? "")
        cell.price.text = String(describing: item.price ?? 0) + "$"
        
        return cell
    },
                                                                         titleForHeaderInSection: {
        ds, index in
        return ds.sectionModels[index].header
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menu Food"
        foodTableView.register(UINib(nibName: "FoodTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodTableViewCell")
        let _: () = searchBarView.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map ({ query in
                self.tableViewItemSection.value.map ({ sectionModel in
                    SectionModel(header: sectionModel.header , items: sectionModel.items.filter ({ food in
                        query.isEmpty || ((food.name?.lowercased().contains(query.lowercased())) != nil)
                    }))
                })
            })
            .bind(to: foodTableView
                    .rx
                    .items(dataSource: dataSoucres))
            .disposed(by: bag)
        //                    .items(cellIdentifier: "FoodTableViewCell", cellType: FoodTableViewCell.self)) {
        //                (tv, tableViewItem, cell ) in
        //                cell.foodname.text = tableViewItem.name
        //                cell.imageName.image = UIImage.init(named: tableViewItem.image)
        //            }.disposed(by: bag)
        
        foodTableView
            .rx.modelSelected(Food.self)
            .subscribe(onNext: { [weak self] foodObject in
                let foodVC = self?.storyboard?.instantiateViewController(identifier: "FoodVC") as! FoodTableViewDetailController
                foodVC.imageNameFood.accept(foodObject.image ?? "")
                foodVC.nameFood.accept(foodObject.name ?? "")
                self?.navigationController?.pushViewController(foodVC, animated: true)
            }).disposed(by: bag)
    }
    
    
    @IBAction func btLogout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "autoLogin")
        let loginVC = self.storyboard?.instantiateViewController(identifier: "LoginController") as! LoginController
        setRootViewController(loginVC)
    }
    
    func setRootViewController(_ vc: UIViewController){
        let navigationController = UINavigationController(rootViewController: vc)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

extension UITableView {
    
    func registerCell(for id: String) {
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forCellReuseIdentifier: id)
    }
}

