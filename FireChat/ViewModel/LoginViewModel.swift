//
//  LoginViewModel.swift
//  FireChat
//
//  Created by Edward McGuiggan on 11/20/20.
//

import Foundation


protocol AuthenticationProtocol {
    var formIsValid: Bool {get}
}

struct LoginViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
