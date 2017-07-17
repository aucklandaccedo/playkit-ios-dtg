//
//  DTGItemRealm.swift
//  Pods
//
//  Created by Gal Orlanczyk on 16/07/2017.
//
//

import Foundation
import RealmSwift

class DTGItemRealm: Object, RealmObjectProtocol {
    
    dynamic var id: String = ""
    /// The items's remote URL.
    dynamic var remoteUrl: String = ""
    /// The item's current state.
    dynamic var state: String = ""
    /// Estimated size of the item.
    var estimatedSize = RealmOptional<Int64>()
    /// Downloaded size in bytes.
    dynamic var downloadedSize: Int64 = 0
    
    let downloadItemTasks = List<DownloadItemTaskRealm>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(object: DTGItem) {
        self.init()
        self.id = object.id
        self.remoteUrl = object.remoteUrl.absoluteString.substring(to: DTGSharedContentManager.storagePath.absoluteString.endIndex) // FIXME: make sure it works
        self.state = object.state.asString()
        self.estimatedSize = RealmOptional<Int64>(object.estimatedSize)
        self.downloadedSize = object.downloadedSize
    }
    
    static func initialize(with object: DTGItem) -> DTGItemRealm {
        return DTGItemRealm(object: object)
    }
    
    func asObject() -> DTGItem {
        let id = self.id
        let remoteUrl = URL(string: self.remoteUrl, relativeTo: DTGSharedContentManager.storagePath)! // FIXME: make sure it works
        var item = MockItem(id: id, url: remoteUrl)
        item.state = DTGItemState(value: self.state)!
        item.estimatedSize = self.estimatedSize.value
        item.downloadedSize = self.downloadedSize

        return item
    }
}
