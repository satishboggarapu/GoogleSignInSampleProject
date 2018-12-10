//
//  ViewController.swift
//  GoogleSignInSampleProject
//
//  Created by Satish Boggarapu on 12/9/18.
//  Copyright © 2018 SatishBoggarapu. All rights reserved.
//

import UIKit
import MaterialComponents.MDCButton
import Firebase
import FirebaseAuth
import GoogleSignIn

/*
    https://firebase.google.com/docs/auth/ios/google-signin
    1. Add URL to URL Types in Project -> Info -> URL Types
    2. App Delegate Initialiazation
    3. Call GoogleSignin with GIDSignIn.sharedInstance().signIn()
 
 */

class ViewController: UIViewController, GIDSignInUIDelegate {

    private var googleLoginButton: MDCButton!
    private var logoutButton: MDCButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor(hex: 0x111111)
        
        // set the UI delegate of the GIDSignIn object, and (optionally) to sign in silently when possible.
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // UI for Google Signin button
        googleLoginButton = MDCButton()
        googleLoginButton.frame = CGRect(x: 100, y: 100, width: 250, height: 48)
        googleLoginButton.backgroundColor = .white
        googleLoginButton.setImage(UIImage(named: "ic_google_36pt"), for: .normal)
        googleLoginButton.imageView?.contentMode = .scaleAspectFit
        googleLoginButton.imageEdgeInsets = UIEdgeInsets(top: -3, left: 0, bottom: -3, right: 8)
        googleLoginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        googleLoginButton.setTitle("Signin with Google", for: .normal)
        googleLoginButton.setTitleColor(.black, for: .normal)
        googleLoginButton.setTitleFont(UIFont.boldSystemFont(ofSize: 16), for: .normal)
        googleLoginButton.isUppercaseTitle = false
        googleLoginButton.addTarget(self, action: #selector(googleSignInButton), for: .touchUpInside)
        view.addSubview(googleLoginButton)
        
        // UI for logout button
        logoutButton = MDCButton()
        logoutButton.frame = CGRect(x: 100, y: 400, width: 200, height: 48)
        logoutButton.backgroundColor = .white
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleFont(UIFont.boldSystemFont(ofSize: 16), for: .normal)
        logoutButton.setTitleColor(.black, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        view.addSubview(logoutButton)
    }

    // Function called when google account is selected to signin
    // Once google credentials are retrieved, they are used to signin into firebase and retrieve data.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error signing in using Google SignIn -> \(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        print("Google signin credentials -> \(credential)")
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Failed to signin with google credentials")
                return
            }
            print("Signed in with google credentials")
        }
    }
    
    // Google signin button action, call the GIDSignIn signin method
    @objc func googleSignInButton() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    // Logout account
    @objc func logoutButtonAction() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance()?.signOut()
            print("Signed out user")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

}

