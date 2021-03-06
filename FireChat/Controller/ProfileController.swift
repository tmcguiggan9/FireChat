//
//  ProfileController.swift
//  FireChat
//
//  Created by Edward McGuiggan on 12/3/20.
//

import UIKit
import Firebase


private let reuseIdentifier = "ProfileCell"

protocol ProfileControllerDelegate: class {
    func handleLogout()
}

class ProfileController: UITableViewController {
    
    
    private var user: User? {
        didSet { headerView.user = user }
    }
    
    weak var delegate: ProfileControllerDelegate?
    
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0, width: view.frame.width, height: 380))
    
    private let footerView = ProfileFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Service.fetchUser(withUid: uid) { user in
            self.user = user
            print(user.username)
        }
    }
    
    func configureUI() {
        tableView.backgroundColor = .white
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 64
        tableView.backgroundColor = .systemGroupedBackground
        
        footerView.delegate = self
        footerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
        
        
    }
}


extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        let viewModel = ProfileViewModel(rawValue: indexPath.row)
        cell.viewModel = viewModel
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}


extension ProfileController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = ProfileViewModel(rawValue: indexPath.row) else {return}
        print("debug handle action for \(viewModel.description)")
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}


extension ProfileController: ProfileHeaderDelegate {
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}


extension ProfileController: ProfileFooterDelegate {
    func handleLogout() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
}
