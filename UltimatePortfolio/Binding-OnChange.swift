//
//  Binding-OnChange.swift
//  UltimatePortfolio
//
//  Created by Simon Shen on 1/14/22.
//

import SwiftUI

extension Binding {
  func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
    Binding {
      self.wrappedValue
    } set: { newValue in
      self.wrappedValue = newValue
      handler()
    }
  }
}
