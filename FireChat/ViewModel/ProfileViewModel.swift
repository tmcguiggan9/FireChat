//
//  ProfileViewModel.swift
//  FireChat
//
//  Created by Edward McGuiggan on 12/16/20.
//

import Foundation


enum ProfileViewModel: Int, CaseIterable {
    case accountInfo
    case settings
    
    
    var description: String {
        switch self {
        case .accountInfo: return "Account Info"
        case .settings: return "Settings"
        }
    }
    
    var iconImageName: String {
        switch self {
        case.accountInfo: return "person.circle"
        case .settings: return "gear"
        }
    }
}
