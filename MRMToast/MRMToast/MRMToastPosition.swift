//
//  MRMToastPosition.swift
//  MRMToast
//
//  Created by David Ansermot on 05.10.22.
//

import UIKit

/// Start position for the banner
///
enum MRMToastPosition {
    case top
    case middle
    case bottom
    
    /// Returns the frame for the toast corresponding
    /// to the position
    ///
    /// - Author: David Ansermot
    ///
    /// - Parameter margin: The margin of the banner
    /// - Parameter toastSize: The toast size
    /// - Parameter screen: The bounds of the screen
    /// - Returns: `CGRect`
    ///
    func frame(margin: Double, toastSize: CGSize, screen: CGRect) -> CGRect {
        switch self {
        case .top:
            return CGRect(x: margin, y: -(toastSize.height + margin),
                          width: toastSize.width, height: toastSize.height)
        case .middle:
            return CGRect(x: screen.width, y: margin + MRMToastConfig.securityTopMargin,
                          width: toastSize.width, height: toastSize.height)
        case .bottom:
            return CGRect(x: margin, y: screen.height,
                          width: toastSize.width, height: toastSize.height)
        }
    }
}
