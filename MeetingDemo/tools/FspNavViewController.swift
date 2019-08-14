//
//  FspNavViewController.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/28.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit

let clearImage = FspTools.createImageWithColor(color: .clear)
let whiteImage = FspTools.createImageWithColor(color: .white)
let grayImage = FspTools.createImageWithColor(color: UIColor.init(red: 242.0/255, green: 242.0/255, blue: 242.0/255, alpha: 1.0))
class FspNavViewController: UINavigationController,UINavigationControllerDelegate {
    
    lazy var rightBarButton: UIBarButtonItem = {
        let button = UIButton.init()
        button.setImage(UIImage.init(named: "setting"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(rightBarButtonDidClick), for: UIControl.Event.touchUpInside)
        let rightBarButton = UIBarButtonItem.init(customView: button)
        return rightBarButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = false
        
        self.navigationBar.shadowImage = clearImage
        self.navigationBar.setBackgroundImage(whiteImage, for: .default)
        //self.navigationItem.rightBarButtonItem = rightBarButton
        // Do any additional setup after loading the view.
    }
    
    @objc
    func rightBarButtonDidClick() -> Void {
        
    }
    
    
    
    /*
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
    }
    */
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.navigationBar.shadowImage = clearImage
        fsp_manager.cur_controller = viewController
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
