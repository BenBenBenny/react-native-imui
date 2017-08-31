//
//  IMUITextMessageCell.swift
//  IMUIChat
//
//  Created by oshumini on 2017/4/1.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

open class IMUITextMessageCell: IMUIBaseMessageCell {

  open static var outGoingTextColor = UIColor(netHex: 0x7587A8)
  open static var inComingTextColor = UIColor.white
  open static let screenW = UIScreen.main.bounds.size.width
  
    open static var outGoingTextFont = screenW<375 ? UIFont.systemFont(ofSize:15) : UIFont.systemFont(ofSize: (screenW * 16 / 375))
  open static var inComingTextFont = screenW<375 ? UIFont.systemFont(ofSize:15) : UIFont.systemFont(ofSize: (screenW * 16 / 375))
  
//  var textMessageLable = IMUITextView()
    var textMessageLable = M80AttributedLabel()

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.bubbleView.addSubview(textMessageLable)
    textMessageLable.numberOfLines = 0
    textMessageLable.lineBreakMode = CTLineBreakMode.byWordWrapping
    textMessageLable.linkColor = UIColor.init(red: 173/255, green: 0, blue: 151/255, alpha: 1)
    textMessageLable.backgroundColor = UIColor.clear
    textMessageLable.underLineForLink = true
    textMessageLable.autoDetectLinks = true
    textMessageLable.font = IMUITextMessageCell.inComingTextFont
    NotificationCenter.default.addObserver(self, selector: #selector(clickOpenLink(notification:)), name: NSNotification.Name(rawValue: "OpenUrlNotification"), object: nil)

  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    
  override open func layoutSubviews() {
    super.layoutSubviews()
  }
  
  override func presentCell(with message: IMUIMessageModelProtocol, viewCache: IMUIReuseViewCache, delegate: IMUIMessageMessageCollectionViewDelegate?) {
    super.presentCell(with: message, viewCache: viewCache, delegate: delegate)

    let layout = message.layout
    self.layoutToText(with: message.text(), isOutGoing: message.isOutGoing)
    if (layout.bubbleFrame.size.height/21) > 1 {
        self.textMessageLable.textAlignment = CTTextAlignment.left
    }else{
        self.textMessageLable.textAlignment = CTTextAlignment.center
    }
    let textX = layout.bubbleContentInset.left
    let textY = layout.bubbleContentInset.top
    let textSize = self.textMessageLable.getTheLabel(CGSize(width: IMUIMessageCellLayout.bubbleMaxWidth, height: CGFloat(MAXFLOAT)))
    self.textMessageLable.frame = CGRect(origin: CGPoint(x:textX, y:textY), size: textSize)
    
  }
  

    
  func layoutToText(with text: String, isOutGoing: Bool) {
//    textMessageLable.text = text
    textMessageLable.nim_setText(text);
    if isOutGoing {
      textMessageLable.textColor = UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
//      textMessageLable.font = IMUITextMessageCell.outGoingTextFont
    } else {
      textMessageLable.textColor = UIColor.white
//      textMessageLable.font = IMUITextMessageCell.inComingTextFont
    }
  }
    
    func clickOpenLink(notification: Notification){
        print("clickOpenLink")
        let dict = notification.object as! NSDictionary
        let tmpLabel = dict.object(forKey: "label") as! M80AttributedLabel
        if tmpLabel == self.textMessageLable {
            let tmpUrl = dict.object(forKey: "url") as! String
            self.delegate?.messageCollectionView?(openMessageBubbleUrl:tmpUrl )
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
