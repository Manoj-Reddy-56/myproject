

import UIKit

class Message {
    
    private init() {}
    
    static func Alert(Title:String,Message:String, TitleAlign:AlertTextAllignment, MessageAlign:AlertTextAllignment,Actions:[UIAlertAction],Controller:UIViewController)
    {
        
        let Alert = UIAlertController.init(title: TitleAlign == .normal ? Title : nil, message: MessageAlign == .normal ? Message : nil, preferredStyle: UIAlertController.Style.alert)

        let TitleStr:String? = Title == "" ? nil : Title
        let MsgStr:String? = Message == "" ? nil : Message

        var AttributedTitle = NSAttributedString()
        var AttributedMessage = NSAttributedString()
        
        
        if (TitleStr != nil) {
            if TitleAlign != .normal {
                let TitleParaStyle = NSMutableParagraphStyle()
                TitleParaStyle.alignment = TitleAlign == .left ? .left : .right
                AttributedTitle = NSAttributedString.init(string: TitleStr!, attributes: [NSAttributedString.Key.paragraphStyle:TitleParaStyle,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.black])
                Alert.setValue(AttributedTitle, forKey: "attributedTitle")
            }
        }
        
        if (MsgStr != nil) {
            if MessageAlign != .normal {
                let MessageParaStyle = NSMutableParagraphStyle()
                MessageParaStyle.alignment = MessageAlign == .left ? .left : .right
                AttributedMessage = NSAttributedString.init(string: MsgStr!, attributes: [NSAttributedString.Key.paragraphStyle:MessageParaStyle,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
                Alert.setValue(AttributedMessage, forKey: "attributedMessage")
            }
        }
        
        for Action in Actions {
            Alert.addAction(Action)
        }
        
        Controller.present(Alert, animated: true, completion: nil)
        
    }
    
    static func AlertActionWithSelector(Title:NSString,Selector:Selector,Controller:UIViewController) -> UIAlertAction
    {
        return UIAlertAction.init(title: Title as String, style: UIAlertAction.Style.default, handler: { (AlertAction:UIAlertAction) in
            Controller.perform(Selector)
        })
    }
    
    static func AlertActionWithSelector(Title:NSString,_ Block:((UIAlertAction) -> Swift.Void)? = nil) -> UIAlertAction
    {
        return UIAlertAction.init(title: Title as String, style: UIAlertAction.Style.default, handler: Block)
    }
    
    static func AlertActionWithOutSelector(Title:NSString) -> UIAlertAction
    {
        return UIAlertAction.init(title: Title as String, style: UIAlertAction.Style.default, handler: nil)
    }
    
    static func AlertWithOk() -> UIAlertAction
    {
        return UIAlertAction.init(title: "Ok" as String, style: UIAlertAction.Style.default, handler: nil)
    }
    
    static func AlertWithCancel() -> UIAlertAction
    {
        return UIAlertAction.init(title: "Cancel" as String, style: UIAlertAction.Style.default, handler: nil)
    }
    
    
    static func NoInternetAlert(_ Controller:UIViewController)
    {
        
        let Alert = UIAlertController.init(title: nil, message: "No internet connection is available. Try to connection active internet connection and try again", preferredStyle: UIAlertController.Style.alert)
        
        Alert.addAction(Message.AlertWithOk())
        
        Controller.present(Alert, animated: true, completion: nil)
        
    }
    
    static func SomethingWrongAlert(_ Controller:UIViewController)
    {
        
        let Alert = UIAlertController.init(title: nil, message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
        
        Alert.addAction(Message.AlertWithOk())
        
        Controller.present(Alert, animated: true, completion: nil)
        
    }
    
    enum AlertTextAllignment {
        case left, right, normal
    }
}
