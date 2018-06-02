//
//  BuzzlerComment.swift
//  Buzzler
//
//  Created by 진형탁 on 01/06/2018.
//  Copyright © 2018 Maru. All rights reserved.
//

import Foundation
import RxDataSources
import ObjectMapper

public struct BuzzlerComment: Equatable, Mappable {
    
    var id: Int = 0
    var authorId: Int = 0
    var postId: Int = 0
    var parentId: Int?
    var content: String = ""
    var createdAt: Date = Date()

    public static func == (lhs: BuzzlerComment, rhs: BuzzlerComment) -> Bool {
        return lhs.id == rhs.id ? true : false
    }
    
    public init?(map: Map) { }
    
    init() { }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        authorId <- map["authorId"]
        postId <- map["postId"]
        parentId <- map["parentId"]
        content <- map["content"]
        createdAt <- map["createdAt"]
    }
    
}

extension BuzzlerComment {
    
    func idCompare(e2: BuzzlerComment) -> ComparisonResult {
        return id.toString.compare(e2.id.toString)
    }
    
    func parentIdCompare(e2: BuzzlerComment) -> ComparisonResult {
        if let selfParentId = parentId?.toString, let e2ParentId = e2.parentId?.toString {
            return selfParentId.compare(e2ParentId)
        } else {
            return .orderedSame
        }
    }
    
    func createdAtCompare(e2: BuzzlerComment) -> ComparisonResult {
        return createdAt.toString().compare(e2.createdAt.toString())
    }
    
}


struct BuzzlerCommentSection {
    
    var items: [BuzzlerComment]
}

extension BuzzlerCommentSection: SectionModelType {

    typealias Item = BuzzlerComment
    
    init(original: BuzzlerCommentSection, items: [BuzzlerCommentSection.Item]) {
        self = original
        self.items = items
    }
}
