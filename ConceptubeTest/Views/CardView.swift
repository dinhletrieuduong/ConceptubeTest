//
//  CardView.swift
//  ConceptubeTest
//
//  Created by blue on 16/12/2021.
//

import UIKit

class CardView: UIView {
    
    @IBOutlet private var imageView: UIImageView!
    
    private var containerView: UIView?
    private var defaultPos: CGPoint = CGPoint(x: 0, y: 0)
    private var index = 0
    private var isDragging = false
    private var tempImageView: UIImageView?
    var viewCenter: CGPoint!
    
    static let identifier = "CardView"
    
    static func nib() -> UINib {
        return UINib(nibName: CardView.identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
//    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
//        guard subviews.isEmpty else { return self }
//        return Bundle.main.loadNibNamed(identifier, owner: nil, options: nil)?[0]
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultPos = frame.origin
        loadXib()
    }
    
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    
    fileprivate func loadXib() {
        let viewFromXib = Bundle.main.loadNibNamed(CardView.identifier, owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        containerView = viewFromXib
        addSubview(viewFromXib)
        
        addGestureRecognizer(InstantPanGestureRecognizer(target: self, action: #selector(dragView)))
        
        backgroundColor = UIColor(white: 1, alpha: 0)
        
    }
    
    func setCard(_ index: Int) {
        self.index = index
    }
    
    func showCard() {
        let path = "c" + String(format: "%02d", index + 1)
        print("SHOW CARDD \(path)")
        if imageView == nil {
            if tempImageView == nil {
                tempImageView = UIImageView(image: UIImage(named: path))
                tempImageView!.frame = CGRect(x: 0, y: 0, width: 175, height: 270)
                containerView?.addSubview(tempImageView!)
            } else {
                tempImageView?.isHidden = false
                tempImageView?.image = UIImage(named: path)
            }
        }
    }
    
    func resetState(_ index: Int) {
        let tempPos = CGPoint(x: defaultPos.x, y: defaultPos.y + CGFloat(index))
        center = tempPos
        
        tempImageView?.isHidden = true
    }
    
    // records the view's center for use as an offset while dragging
    @objc func dragView(gesture: InstantPanGestureRecognizer) {
        let target = gesture.view!
        switch gesture.state {
        case UIGestureRecognizer.State.began:
            viewCenter = target.center
            target.superview?.bringSubviewToFront(target)
            isDragging = false
            break
        case .ended:
            viewCenter = target.center
            if !isDragging {
                (target as? CardView)?.showCard()
            }
            isDragging = false
            break
        case .changed: // heavy tap/hold -> dragging = true
            let translation = gesture.translation(in: self)
            target.center = CGPoint(x: viewCenter!.x + translation.x, y: viewCenter!.y + translation.y)
            isDragging = true
        default:
            isDragging = false
            break
        }
    }
}
class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .began { return }
        super.touchesBegan(touches, with: event)
        self.state = .began
    }
    
}
