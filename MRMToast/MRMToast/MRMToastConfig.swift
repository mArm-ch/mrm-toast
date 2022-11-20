//
//  MRMToastConfig.swift
//  MRMToast
//
//  Created by David Ansermot on 05.10.22.
//

import UIKit

protocol MRMToastBackgroundColor {
    var isGradient: Bool { get }
    var color: UIColor { get set }
}

/// Configuration of a toast alert
///
struct MRMToastConfig {
    
    /// Represent a plain color background
    public struct PlainBackgroundColor: MRMToastBackgroundColor {
        var isGradient: Bool = false
        var color: UIColor
    }
    
    /// Represent a gradient background
    public struct GradientBackgroundColor: MRMToastBackgroundColor {
        var isGradient: Bool = true
        var color: UIColor
        var color2: UIColor
        var start: CGPoint = CGPoint(x: 0.5, y: 0.0)
        var end: CGPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
    /// Default initializer
    public init() {}
    
    /// Top security margin for the banner *(default: 24.0)*
    static let securityTopMargin                   = 24.0
    
    /// Title's text color *(default: `.black`)*
    var titleColor: UIColor                         = .black
    /// Title's font *(default: `.boldSystemFont(ofSize: 17.0)`)*
    var titleFont: UIFont                           = .boldSystemFont(ofSize: 17.0)
    /// Title's text alignement *(default: `.left`)*
    var titleAlignment: NSTextAlignment             = .left
    
    /// Message's text color *(default: `.black`)*
    var messageColor: UIColor                       = .black
    /// Message's font *(default: `systemFont(ofSize: 16.0)`)*
    var messageFont: UIFont                         = .systemFont(ofSize: 16.0)
    /// Message's text alignement *(default: `.left`)*
    var messageAlignment: NSTextAlignment           = .left
    
    /// Banner's background color *(default: `PlainBackgroundColor(.white)`)*
    var backgroundColor: MRMToastBackgroundColor    = PlainBackgroundColor(color: .white)
    
    /// Enable/disable shadow *(default: true)*
    var shadowEnabled: Bool                         = true
    /// Banner's shadow color *(default: .gray)*
    var shadowColor: UIColor                        = .gray
    /// Banner's shadow opacity *(default: 0.3)*
    var shadowOpacity: Float                        = 0.3
    /// Banner's shadow offset *(default: CGSize(width: 6.0, height: 6.0))*
    var shadowOffset: CGSize                        = CGSize(width: 6.0, height: 6.0)
    /// Banner's shadow radius *(default: 0.5)*
    var shadowRadius: CGFloat                       = 0.5
    
    /// Banner's border width
    var borderWidth: CGFloat                        = 1.0
    /// Banner's border color
    var borderColor: UIColor                        = .lightGray
    
    /// Banner's corner radius *(default: 8.0)*
    var cornerRadius: Double                        = 8.0
    /// Banner's margin *(default: 12.0)*
    var margin: Double                              = 12.0
    /// Banner's padding *(default: 8.0)*
    var padding: Double                             = 8.0
    

    /// Fade in animation flag *(default: false)*
    var fadeInEnabled: Bool                         = false
    /// Fade out animation flag *(default: false)*
    var fadeOutEnabled: Bool                        = false
    
    /// Alert display time. If equal or lesser to 0,
    /// alert disappear only on click *(default: 2.0)*
    var alertDuration: TimeInterval                 = 2.0

    
    /// Pre-defined available themes enum
    ///
    public enum Theme {

    }
    
    /// Returns a themed configuration from pre-defined themes list
    ///
    /// - Author: David Ansermot
    ///
    /// - Important: `static`
    ///
    /// - Parameter theme: The theme to use
    /// - Returns: `MRMToastConfig`
    ///
    static func themed(_ theme: MRMToastConfig.Theme) -> MRMToastConfig {
        var config = MRMToastConfig()
        switch theme {
       
        }
    
        return config
    }
}
