//
//  PostsViewModel.swift
//  BaseMVVM
//
//  Created by Thulani Mtetwa on 2023/07/16.
//

import Foundation

class PostsViewModel: NSObject {
    private var networkManager: NetworkManagerProtocol
    typealias ErrorParams = (title: String, message: String, image: String)
    var reloadTableView: (() -> Void)?
    var showActivityIndicator: (() -> Void)?
    var hideActivityIndicator: (() -> Void)?
    var handleError: (() -> Void)?
    var posts = Posts()
    
    var postCellViewModels = [PostCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getPosts() {
        self.showActivityIndicator?()
        networkManager.getRequest {[weak self] success, model, error in
            if success, let posts = model {
                self?.fetchData(posts: posts)
                self?.hideActivityIndicator?()
            } else {
                self?.handleError?()
            }
        }
    }
    
    func fetchData(posts: Posts) {
        self.posts = posts // Cache
        var vms = [PostCellViewModel]()
        
        if self.posts.count == 0 {
            self.handleError?()
            return
        }
        
        for post in posts {
            vms.append(createCellModel(post: post))
        }
        postCellViewModels = vms
    }
    
    func createCellModel(post: PostServerResponse) -> PostCellViewModel {
        let title = post.title
        let body = post.body
        
        return PostCellViewModel(title: title, body: body)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> PostCellViewModel {
        return postCellViewModels[indexPath.row]
    }
}
