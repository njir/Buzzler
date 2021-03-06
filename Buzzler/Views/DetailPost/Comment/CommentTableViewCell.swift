//
//  CommentTableViewCell.swift
//  Buzzler
//
//  Created by 진형탁 on 2018. 4. 29..
//  Copyright © 2018년 Maru. All rights reserved.
//

import UIKit
import RxSwift
import Reusable

final class CommentTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var vw_shadow: UIView!
    @IBOutlet weak var vw_commentContainer: UIView!
    @IBOutlet weak var lbl_comment: UILabel!
    @IBOutlet weak var btn_writeRecomment: UIButton!
    @IBOutlet weak var btn_like: UIButton!
    @IBOutlet weak var lbl_author: UILabel!
    @IBOutlet weak var lbl_createdAt: UILabel!
    
    var bag = DisposeBag()
    static let height: CGFloat = UITableViewAutomaticDimension
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vw_commentContainer.setCornerRadius(radius: 25)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
