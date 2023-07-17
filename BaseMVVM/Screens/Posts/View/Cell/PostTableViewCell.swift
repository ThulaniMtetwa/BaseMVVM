//
//  PostTableViewCell.swift
//  BaseMVVM
//
//  Created by Thulani Mtetwa on 2023/07/15.
//https://jsonplaceholder.typicode.com/posts

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    var cellViewModel: PostCellViewModel? {
            didSet {
                titleLabel.text = cellViewModel?.title
                bodyLabel.text = cellViewModel?.body
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    func initView() {
        // Cell view customization
        backgroundColor = .clear
        
        // Line separator full width
        self.layer.cornerRadius = self.frame.size.width / 2
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        bodyLabel.text = nil
    }
}
