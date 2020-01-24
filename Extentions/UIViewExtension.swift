
import UIKit

extension UIView {
    
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    // MARK: - Loader {
    
    func StartLoading() {
        
        if let _ = viewWithTag(10000) {
            //View is already Loading
        }
        else {
            
            let lockView = UIView(frame: bounds)
            lockView.backgroundColor = UIColor.clear
            lockView.tag = 10000
            
            addSubview(lockView)
            
            let container = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            container.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
            container.layer.cornerRadius = 15
            container.clipsToBounds = true
            container.center =  lockView.center
            lockView.addSubview(container)
            
            let activity = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
            activity.style = .white
            activity.hidesWhenStopped = true
            activity.center = container.center
            
            lockView.addSubview(activity)
            lockView.bringSubviewToFront(activity)
            
            activity.startAnimating()
        }
    }
    
    func isLoading() -> Bool {
        if viewWithTag(10000) != nil {
            return true
        }
        return false
    }
    
    func StopLoading() {
        if let lockView = viewWithTag(10000) {
            UIView.animate(withDuration: 0.2, animations: {
                
            }) { finished in
                lockView.removeFromSuperview()
            }
        }
    }
    
    // MARK: - }
    
    // MARK: - Toast Make Black and White {
    
    func ShowBlackTostWithText(message:String!,Interval:TimeInterval) {
        
        DispatchQueue.main.async {
            var NowTag = 0
            
            for Tag in 10000..<20000 {
                if self.viewWithTag(Tag) == nil {
                    NowTag = Tag
                    break
                }
            }
            
            let TostView = UIView()
            TostView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            TostView.clipsToBounds = true
            TostView.layer.cornerRadius = 15
            TostView.tag = NowTag
            
            TostView.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(TostView)
            
            NSLayoutConstraint(item: TostView, attribute:.width, relatedBy:.lessThanOrEqual, toItem: self, attribute:.width, multiplier: 1, constant:-24).isActive = true
            NSLayoutConstraint(item: TostView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute:.bottom, multiplier: 1, constant:-20).isActive = true
            NSLayoutConstraint(item: TostView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute:.centerX, multiplier: 1, constant:0).isActive = true
            NSLayoutConstraint(item: TostView, attribute: .height, relatedBy:.greaterThanOrEqual, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant:30).isActive = true
            
            
            let TostLbl = UILabel.init()
            TostLbl.text = message!
            TostLbl.textColor = UIColor.white
            TostLbl.backgroundColor = UIColor.clear
            TostLbl.font = UIFont.systemFont(ofSize: 14.0)
            TostLbl.numberOfLines = 10
            TostLbl.textAlignment = .center
            
            TostLbl.translatesAutoresizingMaskIntoConstraints = false
            
            TostView.addSubview(TostLbl)
            
            let Info1 = ["TostView":TostView,"TostLbl":TostLbl]
            
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[TostLbl]-15-|", options: [], metrics: nil, views: Info1))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[TostLbl]-5-|", options: [], metrics: nil, views: Info1))
            
            
            let InfoDict = ["Tag":"\(NowTag)"]
            
            Timer.scheduledTimer(timeInterval: Interval, target: self, selector: #selector(self.StopAuto), userInfo: InfoDict, repeats: false)
        }
       
    }
    
    func ShowWhiteTostWithText(message:String!,Interval:TimeInterval) {
        
        DispatchQueue.main.async {
            var NowTag = 0
            
            for Tag in 20000..<30000 {
                if self.viewWithTag(Tag) == nil {
                    NowTag = Tag
                    break
                }
            }
            
            let TostView = UIView()
            TostView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            TostView.clipsToBounds = true
            TostView.layer.cornerRadius = 15
            TostView.tag = NowTag
            
            TostView.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(TostView)
            
            NSLayoutConstraint(item: TostView, attribute:.width, relatedBy:.lessThanOrEqual, toItem: self, attribute:.width, multiplier: 1, constant:-24).isActive = true
            NSLayoutConstraint(item: TostView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute:.bottom, multiplier: 1, constant:-20).isActive = true
            NSLayoutConstraint(item: TostView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute:.centerX, multiplier: 1, constant:0).isActive = true
            NSLayoutConstraint(item: TostView, attribute: .height, relatedBy:.greaterThanOrEqual, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant:30).isActive = true
            
            
            let TostLbl = UILabel.init()
            TostLbl.text = message!
            TostLbl.textColor = UIColor.black
            TostLbl.backgroundColor = UIColor.clear
            TostLbl.font = UIFont.systemFont(ofSize: 14.0)
            TostLbl.numberOfLines = 10
            TostLbl.textAlignment = .center
            
            TostLbl.translatesAutoresizingMaskIntoConstraints = false
            
            TostView.addSubview(TostLbl)
            
            let Info1 = ["TostView":TostView,"TostLbl":TostLbl]
            
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[TostLbl]-15-|", options: [], metrics: nil, views: Info1))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[TostLbl]-5-|", options: [], metrics: nil, views: Info1))
            
            let InfoDict = ["Tag":"\(NowTag)"]
            
            Timer.scheduledTimer(timeInterval: Interval, target: self, selector: #selector(self.StopAuto), userInfo: InfoDict, repeats: false)
        }
        
    }
    
    @objc func StopAuto(_ time:Timer) {
        
        let InfoDict:[String:String] = time.userInfo as! [String:String]
        
        if let TostView = viewWithTag(Int(InfoDict["Tag"]!)!) {
            
            UIView.animate(withDuration: 0.2, animations: {
            }) { finished in
                TostView.removeFromSuperview()
            }
        }
    }
    
    // MARK: - }
    
    // MARK: - View Fadeout {
    
    func fadeOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = 0.0
        }
    }
    
    func fadeIn(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = 1.0
        }
    }
    
    // MARK: - }
    
    // MARK: - ViewFromXib {
    
    class func viewFromNibName(name: String) -> UIView? {
        let views = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        return views?.first as? UIView
    }
    // MARK: - }
    
    func lock() {
        if let _ = viewWithTag(110) {
            //View is already locked
        }
        else {
            let lockView = UIView(frame: bounds)
            lockView.backgroundColor = UIColor.white
            lockView.tag = 110
            lockView.alpha = 0.7
            lockView.layer.cornerRadius = 2
            
            let activity = UIActivityIndicatorView.init(style: .gray)
            activity.hidesWhenStopped = true
            lockView.addSubview(activity)
            activity.startAnimating()
            addSubview(lockView)
            
            let Loading = UILabel()
            Loading.center = CGPoint.init(x: lockView.center.x - 85, y: lockView.center.y)
            Loading.textColor = UIColor.black
            Loading.text = "Loading..."
            Loading.font = UIFont.systemFont(ofSize: 13)
            lockView.addSubview(Loading)
            
            activity.translatesAutoresizingMaskIntoConstraints = false
            Loading.translatesAutoresizingMaskIntoConstraints = false
            
            let Info1 = ["activity":activity,"Loading":Loading]
            
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[activity(30)]-3-[Loading]-2-|", options: [], metrics: nil, views: Info1))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[activity]-0-|", options: [], metrics: nil, views: Info1))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[Loading]-0-|", options: [], metrics: nil, views: Info1))
            
            UIView.animate(withDuration: 0.2) {
                lockView.alpha = 1.0
            }
        }
    }
    
    func unlock() {
        if let lockView = viewWithTag(110) {
            UIView.animate(withDuration: 0.2, animations: {
                lockView.alpha = 0.7
            }) { finished in
                lockView.removeFromSuperview()
            }
        }
    }
    
    func ImageLoaderStart() {
        if let _ = viewWithTag(120) {
            //View is already locked
        }
        else {
            let lockView = UIView(frame: bounds)
            lockView.backgroundColor = UIColor.clear
            lockView.tag = 120
            //            lockView.alpha = 0.7
            lockView.layer.cornerRadius = 2
            
            let activity = UIActivityIndicatorView.init(style: .gray)
            activity.hidesWhenStopped = true
            lockView.addSubview(activity)
            activity.startAnimating()
            activity.color = UIColor.black
            activity.tintColor = UIColor.black
            addSubview(lockView)
            
            activity.translatesAutoresizingMaskIntoConstraints = false
            
            let Info1 = ["activity":activity]
            
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[activity]-2-|", options: [], metrics: nil, views: Info1))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[activity]-2-|", options: [], metrics: nil, views: Info1))
            
            UIView.animate(withDuration: 0.2) {
                lockView.alpha = 1.0
            }
        }
    }
    
    func ImageLoaderStop() {
        if let lockView = viewWithTag(120) {
            UIView.animate(withDuration: 0.2, animations: {
                //                lockView.alpha = 0.7
            }) { finished in
                lockView.removeFromSuperview()
            }
        }
    }
    
    
    func ShapeView(sides: Int, border:Bool = true, borderColor: UIColor = UIColor.white) {
        
        let lineWidth: CGFloat = 5.0;

        UIGraphicsBeginImageContext(self.frame.size);
        let path = UIBezierPath.init(polygonIn: self.bounds, sides: sides, lineWidth: lineWidth, cornerRadius: 8)
        
        let mask = CAShapeLayer()
        mask.path            = path.cgPath
        mask.lineWidth       = lineWidth
        mask.strokeColor     = UIColor.clear.cgColor
        mask.fillColor       = UIColor.groupTableViewBackground.cgColor
        self.layer.mask = mask
        
        if border {
            let borderShape = CAShapeLayer()
            borderShape.path          = path.cgPath
            borderShape.lineWidth     = lineWidth
            borderShape.strokeColor   = borderColor.cgColor
            borderShape.fillColor     = UIColor.clear.cgColor
            self.layer.addSublayer(borderShape)
        }
    }
    
}

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

extension UIBezierPath {
    
    /// Create UIBezierPath for regular polygon with rounded corners
    ///
    /// - parameter rect:            The CGRect of the square in which the path should be created.
    /// - parameter sides:           How many sides to the polygon (e.g. 6=hexagon; 8=octagon, etc.).
    /// - parameter lineWidth:       The width of the stroke around the polygon. The polygon will be inset such that the stroke stays within the above square. Default value 1.
    /// - parameter cornerRadius:    The radius to be applied when rounding the corners. Default value 0.
    
    convenience init(polygonIn rect: CGRect, sides: Int, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 0) {
        self.init()
        
        let theta = 2 * CGFloat.pi / CGFloat(sides)                        // how much to turn at every corner
        let offset = cornerRadius * tan(theta / 2)                  // offset from which to start rounding corners
        let squareWidth = min(rect.size.width, rect.size.height)    // width of the square
        
        // calculate the length of the sides of the polygon
        
        var length = squareWidth - lineWidth
        if sides % 4 != 0 {                                         // if not dealing with polygon which will be square with all sides ...
            length = length * cos(theta / 2) + offset / 2           // ... offset it inside a circle inside the square
        }
        let sideLength = length * tan(theta / 2)
        
        // start drawing at `point` in lower right corner, but center it
        
        var point = CGPoint(x: rect.origin.x + rect.size.width / 2 + sideLength / 2 - offset, y: rect.origin.y + rect.size.height / 2 + length / 2)
        var angle = CGFloat.pi
        move(to: point)
        
        // draw the sides and rounded corners of the polygon
        
        for _ in 0 ..< sides {
            point = CGPoint(x: point.x + (sideLength - offset * 2) * cos(angle), y: point.y + (sideLength - offset * 2) * sin(angle))
            addLine(to: point)
            
            let center = CGPoint(x: point.x + cornerRadius * cos(angle + .pi / 2), y: point.y + cornerRadius * sin(angle + .pi / 2))
            addArc(withCenter: center, radius: cornerRadius, startAngle: angle - .pi / 2, endAngle: angle + theta - .pi / 2, clockwise: true)
            
            point = currentPoint
            angle += theta
        }
        
        close()
        
        self.lineWidth = lineWidth           // in case we're going to use CoreGraphics to stroke path, rather than CAShapeLayer
        lineJoinStyle = .round
    }
    
}


@IBDesignable extension UIView {
    
    @IBInspectable var BorderColor: UIColor? {
        set {
            layer.borderColor = (newValue?.cgColor)!
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var BorderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            let width = layer.borderWidth
            if width != 0 {
                return width
            }
            else {
                return 0
            }
        }
    }
    
    @IBInspectable var ShadowColor: UIColor? {
        set {
            layer.shadowColor = (newValue?.cgColor)!
            layer.shadowRadius = layer.shadowRadius == 0 ? 2 : layer.shadowRadius
            layer.shadowOffset = CGSize.zero
            layer.shadowOpacity = 0.5
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var ShadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
            layer.shadowOffset = CGSize.zero
            if (layer.shadowColor == nil) {
                layer.shadowColor = UIColor.black.cgColor
            }
            layer.shadowOpacity = 0.5
        }
        get {
            return layer.shadowRadius
        }
    }
    
    @IBInspectable var CornerRadiusMulti: CGFloat {
        set {
            layer.cornerRadius = frame.height / newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var CornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}

