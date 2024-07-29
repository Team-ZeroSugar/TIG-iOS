//
//  Int+Ext.swift
//  TIG
//
//  Created by 이정동 on 7/29/24.
//

import Foundation

extension Int {
    var minutesFormat: String {
        self / 10 == 0 ? "0\(self)" : "\(self)"
    }
}
