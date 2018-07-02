//
//  Skinnable.swift
//  Loqator-qa
//
//  Created by Javier Loucim on 25/03/2018.
//  Copyright © 2018 Qeeptouch. All rights reserved.
//

import Foundation
import UIKit

struct Skin {
    var primaryColor:String
    var darkPrimaryColor:String
    var lightPrimaryColor:String
    var textColor:String
    var accentColor:String
    var primaryText:String
    var secondaryText:String
    var dividerColor:String
    var name:String
    var color1:String
    var color2:String
    var color3:String
    var backgroundColor:String
}

struct SkinAppEvents {
    static let SkinHasBeenUpdated = NSNotification.Name(rawValue: "SkinHasBeenUpdated")
}


class SkinData {
    static var sharedInstance = SkinData()
    static let kDefaultSkinName = "Loqator"
    
    var currentSkin: Skin!
    var titleFont: UIFont!
    var normalFont: UIFont!
    var tinyFont: UIFont!
    var smallFont: UIFont!
    var availableSkins = Array<Skin>()
    var boldFont: UIFont!
    var chatFont: UIFont!
    var buttonFont: UIFont!
    
    
    init() {
        //        dumpFonts()
        //        checkFont()
        let fontName1 = "Gibson-Regular"
        let fontName2 = "Gibson-SemiBold"
        let fontName3 = "Gibson-SemiBold"
        let fontName4 = "Gibson-Light"
        
        normalFont = UIFont(name: fontName1, size: 14) ?? UIFont.systemFont(ofSize: 14)
        tinyFont = UIFont(name: fontName4, size: 10) ?? UIFont.systemFont(ofSize: 10)
        titleFont = UIFont(name: fontName2, size: 18) ?? UIFont.systemFont(ofSize: 18)
        smallFont = UIFont(name: fontName1, size: 12) ?? UIFont.systemFont(ofSize: 12)
        boldFont = UIFont(name: fontName2, size: 14) ?? UIFont.systemFont(ofSize: 14)
        chatFont = UIFont(name: fontName4, size: 13)
        buttonFont = UIFont(name: fontName3, size: 15) ?? UIFont.systemFont(ofSize: 15)
        
        availableSkins.append(
            Skin(primaryColor: "#454F63",
                 darkPrimaryColor: "#2A2E43",
                 lightPrimaryColor: "#78849E",
                 textColor: "#FFFFFF",
                 accentColor: "#3497FD",
                 primaryText: "#454F63",
                 secondaryText: "#888888",
                 dividerColor: "#D2D4D8",
                 name: "Loqator",
                 color1: "#FF4463 ", color2: "#FF743C", color3: "#EFEFEF", backgroundColor: "#FCFDFD"
            )
        )
        
        resetDefaultSkin()
    }
    
    func checkFont(){
        for family in UIFont.familyNames {
            print("\(family)")
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
    func dumpFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
        
    }
    func resetDefaultSkin() {
        for skin in availableSkins {
            if skin.name.uppercased() == SkinData.kDefaultSkinName.uppercased() {
                currentSkin = skin
            }
        }
    }
    
    func setCurrentSkinTo(skinName: String){
        var skinMustUpdate = false
        if skinName.characters.count > 0{
            for skin in availableSkins {
                if skin.name.uppercased() == skinName.uppercased() {
                    currentSkin = skin
                    skinMustUpdate = true
                }
            }
        }
        if skinMustUpdate{
            NotificationCenter.default.post(name: SkinAppEvents.SkinHasBeenUpdated, object: self)
        }
    }
    
    
}
protocol Skinnable {
}

extension Skinnable {
    
    func skinPrimaryColor() -> UIColor {
        return UIColor(hex: SkinData.sharedInstance.currentSkin.primaryColor)
    }
    
    func skinDarkPrimaryColor() -> UIColor {
        return UIColor(hex: SkinData.sharedInstance.currentSkin.darkPrimaryColor)
    }
    
    func skinLightPrimaryColor() -> UIColor {
        return UIColor(hex: SkinData.sharedInstance.currentSkin.lightPrimaryColor)
    }
    func skinTextColor() -> UIColor {
        return UIColor(hex: SkinData.sharedInstance.currentSkin.textColor)
    }
    
    func skinAccentColor() -> UIColor {
        return UIColor(hex: SkinData.sharedInstance.currentSkin.accentColor)
    }
    
    func skinPrimaryTextColor() -> UIColor {
        return UIColor(hex: SkinData.sharedInstance.currentSkin.primaryText)
    }
    
    func skinSecondaryTextColor() -> UIColor {
        return UIColor(hex: SkinData.sharedInstance.currentSkin.secondaryText)
    }
    
    func skinDividerColor() -> UIColor {
        return UIColor(hex: SkinData.sharedInstance.currentSkin.dividerColor)
    }
    func skinColor1() -> UIColor {
        return UIColor(hex: SkinData.sharedInstance.currentSkin.color1)
    }
    func skinColor2() -> UIColor {
        return UIColor(hex: SkinData.sharedInstance.currentSkin.color2)
    }
    func skinColor3() -> UIColor {
        return UIColor(hex: SkinData.sharedInstance.currentSkin.color3)
    }
    func skinBackgroundColor() -> UIColor {
        return UIColor(hex: SkinData.sharedInstance.currentSkin.backgroundColor)
    }
    
    func skinApp() {
        
        UINavigationBar.appearance().backgroundColor = UIColor.green
        UINavigationBar.appearance().barTintColor = skinPrimaryColor()
        UINavigationBar.appearance().tintColor = skinPrimaryColor()
        
        UINavigationBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = skinPrimaryColor()
        
        
        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: skinTextColor(),
                                                        NSAttributedStringKey.font: SkinData.sharedInstance.titleFont!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().tintColor = skinTextColor()
    }
    
}


extension UIView: Skinnable {
    func skinViewLabels() {
        skinViewLabels(color: skinTextColor())
    }
    func skinViewLabels(color:UIColor) {
        for view in self.subviews {
            if type(of: view) == UILabel.self {
                let label = view as! UILabel
                label.textColor = color
            }
        }
    }
}
extension UIDevice {
    class func isPhoneX() -> Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480:
                print("iPhone Classic")
            case 960:
                print("iPhone 4 or 4S")
            case 1136:
                print("iPhone 5 or 5S or 5C")
            case 1334:
                print("iPhone 6 or 6S")
            case 2208:
                print("iPhone 6+ or 6S+")
            case 2436:
                return true
                print("iPhone X")
            default:
                print("unknown")
            }
        }
        return false
    }
}

extension Skinnable where Self: UIViewController {
    private func imageLayerForGradientBackground() -> UIImage? {
        
        if let controller = self.navigationController {
            var updatedFrame = controller.navigationBar.bounds
            // take into account the status bar
            updatedFrame.size.height += 20
            
            if UIDevice.isPhoneX() {
                updatedFrame.size.height = 145
            }
            
            let layer = CAGradientLayer()
            layer.frame = updatedFrame
            
            layer.colors = [#colorLiteral(red: 1, green: 0.2666666667, blue: 0.3882352941, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.4549019608, blue: 0.2352941176, alpha: 1).cgColor]
            layer.startPoint = CGPoint(x: 0, y: 1)
            layer.endPoint = CGPoint(x: 1, y: 0)
            UIGraphicsBeginImageContext(layer.bounds.size)
            layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }

    func skinNavigationBarTransparent() {
        if let navigationController = self.navigationController {
            let backIcon = #imageLiteral(resourceName: "back-icon")
            self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
            self.navigationController?.navigationBar.backIndicatorImage = backIcon
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backIcon
            self.navigationController?.navigationBar.backItem?.title = ""

            navigationController.navigationBar.tintColor = skinPrimaryColor()
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
        }
    }
    
    func skinStatusBarLight() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    func skinStatusBarDark() {
        UIApplication.shared.statusBarStyle = .default
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
}

extension UIView  {
    func addBottomLineBorder(color: UIColor = .lightGray, rect: CGRect = .zero) {
        var rect = rect
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        if rect == .zero {
            rect = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        }else {
            rect.origin.y = rect.size.height - width
        }
        border.frame = rect
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
extension UIViewController {
    func removeBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
}
