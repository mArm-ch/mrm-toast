//
//  MRMToast.swift
//  MRMToast
//
//  Created by David Ansermot on 05.10.22.
//

import UIKit

/// A toast style alert displayable in multiple positions
///
///
/// - Author: David Ansermot
/// - Version: 1.0.0
///
class MRMToast: UIView {
    
    private(set) var title: String
    private(set) var message: String
    private(set) var config: MRMToastConfig
    
    private var viewInitialized: Bool = false
    private var screen: CGRect
    private var size: CGSize
    
    private var titleLabel: UILabel!
    private var messageLabel: UILabel!
    
    private var hideCallback: (() -> Void)?
    
    /// Start position of the banner
    ///
    /// If the view is already initialized,
    /// changing the position will re-position the banner
    ///
    var position: MRMToastPosition {
        didSet {
            if self.viewInitialized {
                self.frame = position.frame(margin: config.margin,
                                            toastSize: self.size,
                                            screen: self.screen)
            }
        }
    }
    
    
    
    // --------------------------------------------------------
    // MARK: - View life cycle
    
    /// Initialize the toast
    ///
    /// - Author: David Ansermot
    ///
    /// - Parameter title: The title displayed in the toast
    /// - Parameter message: The message displayed in the toast
    /// - Parameter position: The position of the toast
    /// - Parameter config: Configuration of the banner *(default: `MRMToastConfig()`)*
    /// - Returns: `MRMToast`
    ///
    init(title: String,
         message: String,
         position: MRMToastPosition,
         config: MRMToastConfig = MRMToastConfig()) {
    
        self.title = title
        self.message = message
        self.config = config
        self.position = position
        
        // Calculate some sizes
        self.screen = UIScreen.main.bounds
        self.size = CGSize(width: self.screen.width - (2 * self.config.margin),
                           height: 0.0)
        
        // Flag init
        self.viewInitialized = true
        
        super.init(frame: CGRect.zero)
    }
    
    /// Optional initialized (NOT IMPLEMENTED)
    ///
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. ")
    }
    
    
    
    // --------------------------------------------------------
    // MARK: - Display method(s)
    
    /// Show a toast
    ///
    /// - Author: David Ansermot
    ///
    /// - Important: `static`
    ///
    /// - Parameter title: The title of the toast
    /// - Parameter message: The message of the toast
    /// - Parameter position: The start position of the toast
    ///   - default: `MRMToastConfig()`
    /// - Parameter in: The controller to display in. *(default: `nil`, means it will take the top view controller)*
    /// - Parameter didShowCallback: Callback when the toast alert is shown *(default: `nil`)*
    /// - Parameter didHideCallback: Callback when the toast alert is hidden *(default: `nil`)*
    /// - Returns: `Void`
    ///
    static func show(title: String,
                     message: String,
                     position: MRMToastPosition,
                     config: MRMToastConfig = MRMToastConfig(),
                     in controller: UIViewController? = nil,
                     didShowCallback: (() -> Void)? = nil,
                     didHideCallback: (() -> Void)? = nil) {
        
        let toast = MRMToast(title: title, message: message, position: position, config: config)
        toast.show(in: controller, didShowCallback: didShowCallback, didHideCallback: didHideCallback)
    }
    
    
    /// Show the current toast
    ///
    /// - Author: David Ansermot
    ///
    /// - Parameter in: The controller to display in. *(default: `nil`, means it will take the top view controller)*
    /// - Parameter didShowCallback: Callback when the toast alert is shown *(default: `nil`)*
    /// - Parameter didHideCallback: Callback when the toast alert is hidden *(default: `nil`)*
    /// - Returns: `Void`
    ///
    func show(in controller: UIViewController? = nil,
              didShowCallback: (() -> Void)? = nil,
              didHideCallback: (() -> Void)? = nil) {

        // Setup view
        self.setupView()
        
        // Gets valid view controller
        var parentController = controller
        if parentController == nil {
            parentController = MRMToast.topViewController()
        }
        
        // Display the banner
        if let parentController = parentController {
            // Fade in effect
            self.layer.opacity = 0.0
            
            // Adds banner and show
            parentController.view.addSubview(self)
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           options: .curveLinear) {
                // Fade in effect
                self.layer.opacity = 1.0
            } completion: { done in
                didShowCallback?()
                self.hideBanner(delay: self.config.alertDuration,
                                didHideCallback: didHideCallback)
            }
        } else {
            print("\(Date()) - 🏳️‍🌈 MRMBannerAlert - Sorry, no valid parentController available for display")
        }
    }
    
    
    /// Hides the banner
    ///
    /// - Author: David Ansermot
    ///
    /// - Important: `private`
    ///
    /// - Parameter delay: The delay before hide *(default: 0.0)*
    /// - Parameter didHideCallback: Callback to know when banner is hidden *(default: `nil`)*
    /// - Returns: `Void`
    ///
    private func hideBanner(delay: TimeInterval = 0.0, didHideCallback: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2,
                       delay: delay,
                       options: .curveLinear) {
            self.layer.opacity = 0.0
        } completion: { done in
            didHideCallback?()
        }
    }
    
    
    
    // --------------------------------------------------------
    // MARK: - Setup methods
    
    /// Setup the banner view itself
    ///
    /// - Author: David Ansermot
    ///
    /// - Important: `private`
    ///
    /// - Returns: `Void`
    ///
    private func setupView() {
        
        // Create alert elements
        self.createTitleLabel()
        self.createMessageLabel()
        
        // Calculate final height
        self.size.height = self.titleLabel.frame.height + self.config.padding +
                           self.messageLabel.frame.height + (2 * self.config.padding)
        
        self.createBanner(title: self.titleLabel, message: self.messageLabel)
    }
    
    /// Create the title label and setup
    ///
    /// - Author: David Ansermot
    ///
    /// - Important: `private`
    ///
    /// - Returns: `Void`
    ///
    private func createTitleLabel() {
        self.titleLabel = UILabel(frame: CGRect(x: self.config.padding,
                                                y: self.config.padding,
                                                width: self.size.width - (2 * config.padding),
                                                height: 24.0))
        self.titleLabel.text = self.title
        self.titleLabel.textColor = self.config.titleColor
        self.titleLabel.textAlignment = self.config.titleAlignment
        self.titleLabel.font = self.config.titleFont
        self.titleLabel.numberOfLines = 0
        self.titleLabel.sizeToFit()
    }
    
    /// Create the title label and setup
    ///
    /// - Author: David Ansermot
    ///
    /// - Important: `private`
    ///
    /// - Returns: `Void`
    ///
    private func createMessageLabel() {
        self.messageLabel = UILabel(frame: CGRect(x: config.padding,
                                                  y: titleLabel.frame.maxY + config.padding,
                                                  width: self.size.width - (2 * config.padding),
                                                  height: 24.0))
        self.messageLabel.text = self.message
        self.messageLabel.textColor = self.config.messageColor
        self.messageLabel.textAlignment = self.config.messageAlignment
        self.messageLabel.font = self.config.messageFont
        self.messageLabel.numberOfLines = 0
        self.messageLabel.sizeToFit()
    }
    
    /// Create the banner view
    ///
    /// - Important: `private`
    ///
    /// - Parameter title: title label
    /// - Parameter message: message label
    /// - Returns: `Void`
    ///
    private func createBanner(title: UILabel, message: UILabel) {
        self.frame = self.position.frame(margin: self.config.margin,
                                         toastSize: self.size,
                                         screen: self.screen)
        self.addSubview(title)
        self.addSubview(message)
        
        self.setupBackground()
        
        self.layer.cornerRadius = self.config.cornerRadius
        self.layer.borderWidth = self.config.borderWidth
        self.layer.borderColor = self.config.borderColor.cgColor
        
        if self.config.shadowEnabled {
            self.layer.shadowColor = self.config.shadowColor.cgColor
            self.layer.shadowOpacity = self.config.shadowOpacity
            self.layer.shadowOffset = self.config.shadowOffset
            self.layer.shadowRadius = self.config.shadowRadius
        }
    }
    
    /// Setup the correct background
    ///
    /// - Important: `private`
    ///
    /// - Returns: `Void`
    ///
    private func setupBackground() {
        if self.config.backgroundColor.isGradient,
           let backgroundColor = self.config.backgroundColor as? MRMToastConfig.GradientBackgroundColor {
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [backgroundColor.color.cgColor, backgroundColor.color2.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.locations = [0, 1]
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = self.config.cornerRadius
            
            self.backgroundColor = backgroundColor.color
            self.layer.insertSublayer(gradientLayer, at: 0)
        } else {
            self.backgroundColor = self.config.backgroundColor.color
        }
    }
    
    
    // --------------------------------------------------------
    // MARK: - View events
    
    
    /// Hides the banner on click
    ///
    /// - Author: David Ansermot
    ///
    /// - Parameter touches: Set of touches
    /// - Parameter event: The event
    /// - Returns: `Void`
    ///
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.config.alertDuration == 0 {
        
            if touches.count >= 1 {
                self.hideBanner(didHideCallback: self.hideCallback)
            }
        }
    }
    
    
    // --------------------------------------------------------
    // MARK: - Helper methods
    
    /// Retrieve the most top visible view controller
    ///
    /// - Author: David Ansermot
    ///
    /// - Important: `internal`, `static`
    ///
    /// - Returns: `UIViewController`
    ///
    internal static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
}
