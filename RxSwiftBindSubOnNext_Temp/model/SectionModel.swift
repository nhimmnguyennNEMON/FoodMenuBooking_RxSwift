//
//  SectionModel.swift
//  RxSwiftBindSubOnNext
//
//  Created by V000273 on 09/09/2022.
//

import Foundation
import RxDataSources

struct SectionModel {
    var header: String
    var items: [Food]
}

extension SectionModel: SectionModelType {
    init(original: SectionModel, items: [Food]) {
        self = original
        self.items = items
    }
}
