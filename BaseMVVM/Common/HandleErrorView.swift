//
//  HandleErrorView.swift
//  BaseMVVM
//
//  Created by Thulani Mtetwa on 2023/07/17.
//

import UIKit

class HandleErrorView: UIView {
    
    @IBOutlet weak var messageImageView: UIImageView!{
        didSet{
            messageImageView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!{
        didSet {
            retryButton.isHidden = true
        }
    }
    
    var tryAgainAction: (() -> Void)?
    let nibName = String(describing: HandleErrorView.self)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    @IBAction func tryAgainActionPressed() {
        self.tryAgainAction?()
    }
    
}
