//
//  AssetTest.swift
//  UltimatePortfolioTests
//
//  Created by Simon Shen on 1/26/22.
//

import XCTest
@testable import UltimatePortfolio

class AssetTest: XCTestCase {
  func testColorsExist() {
    for color in Project.colors {
      // use SwiftUI method to load color string will always work, so use UIColor method instead
      XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
    }
  }

  func testJSONLoadsCorrectly() {
    XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from JSON.")
  }
}
