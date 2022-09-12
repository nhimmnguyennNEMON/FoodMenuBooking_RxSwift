//
//  FoodDetailTableViewCell.swift
//  RxSwiftBindSubOnNext
//
//  Created by V000273 on 08/09/2022.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class FoodTableViewDetailController : UIViewController {
    
    
    @IBOutlet weak var nameFoodView: UILabel!
    @IBOutlet weak var imageFoodView: UIImageView!
    let disposeBag = DisposeBag()
    let imageNameFood: BehaviorRelay = BehaviorRelay<String>(value: "")
    let nameFood: BehaviorRelay = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageFoodView.layer.cornerRadius = self.imageFoodView.frame.width/4.0
        self.imageFoodView.layer.masksToBounds = true
        
        imageNameFood.map ({ image in
            UIImage.init(named: image)
        }).bind(to: imageFoodView
                    .rx
                    .image
        ).disposed(by: disposeBag)
        
        nameFood.map ({ text -> String? in
            return text
        }).bind(to: nameFoodView
                    .rx
                    .text
        ).disposed(by: disposeBag)
        
    }
}
