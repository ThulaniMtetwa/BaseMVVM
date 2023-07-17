//
//  UITableView+ErrorView.swift
//  BaseMVVM
//
//  Created by Thulani Mtetwa on 2023/07/17.
//

import UIKit

extension UITableView {
    
    func setEmptyView(title: String, message: String, messageImage: UIImage?, action: (() -> Void)?) {
        
        let view = HandleErrorView(frame: self.bounds)
        if messageImage != nil {
            view.messageImageView.image = messageImage
        }
        
        if let theCallback = action {
            view.retryButton.isHidden = false
            view.tryAgainAction = theCallback
        }
        
        view.titleLabel.text = title
        view.messageLabel.text = message
        
        UIView.animate(withDuration: 1, animations: {
                    
            view.messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
                }, completion: { (finish) in
                    UIView.animate(withDuration: 1, animations: {
                        view.messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
                    }, completion: { (finish) in
                        UIView.animate(withDuration: 1, animations: {
                            view.messageImageView.transform = CGAffineTransform.identity
                        })
                    })
                    
                })
        
        self.backgroundView = view
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
}
