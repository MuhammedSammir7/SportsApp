//
//  CustomButton.swift
//  SportsApp
//
//  Created by Marco on 2024-08-18.
//

import Foundation
import UIKit

// Custom button for use in animating bar button items
class CustomButton {
    var customButton : UIButton
    //let favouriteButton : UIBarButtonItem
    //let action : () -> Void
    let vc : UIViewController
    
    init(vc : UIViewController) {
        self.vc = vc
        //self.action = action
        //self.favouriteButton = favouriteButton
        
        // Create a custom UIButton
        customButton = UIButton(type: .system)
        //customButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchDown)
        customButton.tintColor = UIColor.red
        customButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        customButton.backgroundColor = .clear
        customButton.layer.cornerRadius = 10
        customButton.frame = CGRect(x: 0, y: 0, width: 42, height: 28) // Adjust size as needed
        
        // Set up the shadow for the glow effect
        customButton.layer.shadowColor = UIColor.red.cgColor
        customButton.layer.shadowRadius = 0
        customButton.layer.shadowOpacity = 0.8
        customButton.layer.shadowOffset = CGSize.zero
        customButton.layer.masksToBounds = false
        
        addPulsatingAnimation(to: customButton)
        
        let tapGesture = UITapGestureRecognizer(target: self.customButton, action: #selector(favoriteButtonTapped))
        self.customButton.addGestureRecognizer(tapGesture)
    }
    
    // Add pulsating animation
    func addPulsatingAnimation(to view: UIView) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.8
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.25
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .zero
        view.layer.add(pulseAnimation, forKey: "pulse")
        
        // Add animation to make the glow pulsate
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 0
        glowAnimation.toValue = 8
        glowAnimation.duration = 1.0
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = .zero
        
        view.layer.add(glowAnimation, forKey: "glowAnimation")
    }
    
    @objc func favoriteButtonTapped() {
        //favouriteButton.customView = nil
        print("ssss")
    }
}
