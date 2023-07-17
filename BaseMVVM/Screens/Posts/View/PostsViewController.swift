//
//  PostsViewController.swift
//  BaseMVVM
//
//  Created by Thulani Mtetwa on 2023/07/15.
//

import UIKit

class PostsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!{
        didSet {
            activityIndicatorView.startAnimating()
            activityIndicatorView.hidesWhenStopped = true
        }
    }
    
    lazy var viewModel = {
        PostsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initViewModel()
        loadActivityIndicator()
        stopLoadActivityIndicator()
        showErrorMessage()
    }
    
    
    private func initView() {
        // TableView customisation
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 130
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        tableView.backgroundView = activityIndicatorView
        
        tableView.register(PostTableViewCell.nib, forCellReuseIdentifier: PostTableViewCell.identifier)
    }
    
    private func loadActivityIndicator() {
        viewModel.showActivityIndicator = {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicatorView.startAnimating()
                self?.activityIndicatorView.hidesWhenStopped = true
                self?.tableView.isHidden = true
            }
        }
    }
    
    private func stopLoadActivityIndicator() {
        viewModel.hideActivityIndicator = {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.refreshControl?.endRefreshing()
                self?.activityIndicatorView.stopAnimating()
                self?.tableView.isHidden = false
            }
        }
    }
    
    
    private func initViewModel() {
        viewModel.getPosts()
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func showErrorMessage() {
        self.viewModel.handleError = {
            DispatchQueue.main.async {
                self.tableView.setEmptyView(title: "Something unexpected happened.",
                                            message: "Please pull down to refresh to try again :)",
                                            messageImage: UIImage(systemName: "exclamationmark.triangle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal),
                                            action: { [weak self] in
                    self?.tableView.restore()
                    self?.initViewModel()
                })
            }
        }
    }
    
    @objc func callPullToRefresh(){
        self.initViewModel()
    }
}


// MARK: - UITableViewDelegate

extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.postCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else { fatalError("xib does not exists") }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        
        cell.cellViewModel = cellVM
        return cell
    }
}
