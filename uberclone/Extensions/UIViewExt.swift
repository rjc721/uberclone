//
//  UIViewExt.swift
//  uberclone
//
//  Created by Ryan Chingway on 5/20/18.
//  Copyright © 2018 Ryan Chingway. All rights reserved.
//

import UIKit

extension UIView {
    func fadeTo(alphaValue: CGFloat, withDuration duration: TimeInterval) {
        
        UIView.animate(withDuration: duration) {
            self.alpha = alphaValue
        }
    }
}
