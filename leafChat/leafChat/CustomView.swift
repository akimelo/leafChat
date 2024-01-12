//
//  CustomView.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/01/03.
//

import Foundation
import UIKit

class InsetLabel: UILabel {
    var contentInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: contentInsets)
        super.drawText(in: insetRect)
    }
    
    override var intrinsicContentSize: CGSize {
        return addInsets(to: super.intrinsicContentSize)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return addInsets(to: super.sizeThatFits(size))
    }
    
    private func addInsets(to size: CGSize) -> CGSize {
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
}

class NativebrikView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        let uiview = nativebrik
            .experiment
            .embeddingUIView("TEST_2")
        uiview.frame = CGRect(x: 0, y: 500, width: 600, height: 100) // recommended: set the frmae
        self.addSubview(uiview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InputView :UIView {
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var delegate:InputViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setFromXib()
        autoresizingMask = .flexibleHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onSend(_ sender: Any) {
        delegate.sendTapped(text: chatTextField.text!)
        chatTextField.text = ""
    }
    
    func setFromXib() {
        let nib = UINib.init(nibName: "InputView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
}

protocol InputViewDelegate: AnyObject {
    func sendTapped(text: String)
}

extension UIImage {
    func resize(toWidth width: CGFloat) -> UIImage? {
        let resizedSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
