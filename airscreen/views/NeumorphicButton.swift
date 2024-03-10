import UIKit

class NeumorphicButton: UIButton {
    private var leftTopShadow: CALayer?
    private var rightBottomShadow: CALayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Create a background layer
        let backgroundLayer = CALayer()
        backgroundLayer.frame = bounds
        backgroundLayer.backgroundColor = UIColor.lightestBlue.cgColor
        backgroundLayer.cornerRadius = layer.cornerRadius
        
        // Insert the background layer at the bottom of the layer hierarchy
        layer.insertSublayer(backgroundLayer, at: 0)
        
        // Left top shadow
        leftTopShadow = CALayer()
        leftTopShadow?.frame = bounds
        leftTopShadow?.cornerRadius = layer.cornerRadius
        leftTopShadow?.shadowColor = UIColor.white.cgColor
        leftTopShadow?.shadowOffset = CGSize(width: -4.0, height: -4.0)
        leftTopShadow?.shadowOpacity = 1
        leftTopShadow?.shadowRadius = 5
        leftTopShadow?.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        
        // Right bottom shadow
        rightBottomShadow = CALayer()
        rightBottomShadow?.frame = bounds
        rightBottomShadow?.cornerRadius = layer.cornerRadius
        rightBottomShadow?.shadowColor = UIColor.lightBlue.cgColor
        rightBottomShadow?.shadowOffset = CGSize(width: 4.0, height: 4.0)
        rightBottomShadow?.shadowOpacity = 1
        rightBottomShadow?.shadowRadius = 5
        rightBottomShadow?.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        
        layer.insertSublayer(leftTopShadow!, below: backgroundLayer)
        layer.insertSublayer(rightBottomShadow!, below: backgroundLayer)
    }
    
    func removeShadows() {
        leftTopShadow?.removeFromSuperlayer()
        rightBottomShadow?.removeFromSuperlayer()
    }
}
