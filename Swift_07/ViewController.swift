//
//  ViewController.swift
//  Swift_07
//
//  Created by 陈孟迪 on 2017/11/28.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

import UIKit

let w = UIScreen.main.bounds.size.width
let h = UIScreen.main.bounds.size.height
let p = h/4/7

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.view.backgroundColor = UIColor.gray
        createUI()
//        save()
        
        
    }
    
//    func save()  {
//        let gamescore:BmobObject = BmobObject.init(className: "GameScore")
//        gamescore.setObject("Jhon Smith", forKey: "playerName")
//        gamescore.setObject(90, forKey: "score")
//        gamescore.saveInBackground { (isSuccessful, error) in
//            if error != nil{
//                print("error is\(String(describing: error?.localizedDescription))")
//            }else{
//                print("success")
//            }
//        }
//
//    }

    
    func createUI(){
        
        let array:NSArray = ["sign up","login"]
        for i in 0..<array.count {
           
            let button = UIButton.init(type: .custom)
            button.frame = CGRect.init(x: 20, y: h*3/4 + p + (p * 2 + p) * CGFloat(i), width: w-40, height: p*2)
            button.setTitle(array[i] as? String, for: .normal)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.backgroundColor = UIColor.white
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.tag = 10+i
            button.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
            self.view.addSubview(button)
        }
        
        
    }
    
    @objc func action(sender:UIButton) {
        
        if sender.tag == 10 {
        self.navigationController?.pushViewController(RegisterViewController(), animated: false)
        }else if sender.tag == 11 {
         self.navigationController?.pushViewController(LoginViewController(), animated: false)
        }
    }
}

