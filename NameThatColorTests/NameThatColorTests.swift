// MIT License
//
// Copyright (c) 2018 David Everlöf
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import XCTest

@testable import NameThatColor

class NameThatColorTests: XCTestCase {

    func testSimple() {
        XCTAssertEqual(UIColor.red.descriptiveName, "Red")
    }

    func testAllAgainstLiveWebsite() {
        let webView = TestWebView()

        let e = expectation(description: "Await fetching chir.ag website")
        let request = URLRequest(url: URL(string: "http://chir.ag/projects/name-that-color/")!)
        _ = webView.load(request) {
            for hexColor in Resource.hexToName.keys {
                let mask = 0x000000FF
                let r = CGFloat(Int(hexColor >> 16) & mask)
                let g = CGFloat(Int(hexColor >> 8) & mask)
                let b = CGFloat(Int(hexColor) & mask)

                let color = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)

                webView.evaluateJavaScript("ntc.name('\(color.hex)')", completionHandler: { (result, error) in
                    if let arrayResult = result as? [Any], let colorName = arrayResult[1] as? String {
                        XCTAssertEqual(color.descriptiveName, colorName)
                    } else {
                        XCTFail("Didn't get result from website.")
                    }
                })
            }

            e.fulfill()
        }

        wait(for: [e], timeout: 5.0)
    }

    func testSpecificHEX0xf9d4c3() {
        // This one is tested specifically due to the fact that I noticed
        // an error while testing names for random colors.
        //
        // For color => #f9d4c3, this app gave as a result Almond (#EED9C4),
        // while the website the list is taken from gave Givry (#F8E4BF).
        //
        // So, the question is, what should be considered the correct?
        // I didn't use the same algorithm as the javascript library,
        // but of course I want it to be as accurae as possible.
        //
        // Thus I went to the ΔE definition described in:
        // https://en.wikipedia.org/wiki/Color_difference
        //
        // And using the calculator at:
        // http://www.brucelindbloom.com/index.html?ColorDifferenceCalc.html
        // I campred both "Almond" and "Givry" to "#f9d4c3" using ΔE.
        //
        //
        // First we need to convert #EED9C4 (Almond) to Lab:
        // L=88.02 a=5.03 b=13.15
        //
        // and #F8E4BF (Givry) to Lab:
        // L=91.53 a=2.90 b=20.74
        //
        // And according to ΔE, "Almond" is more similar to "#f9d4c3" than "Givry".
        XCTAssertEqual(UIColor(hexString: "#f9d4c3")!.descriptiveName, "Almond")
    }

    func testColorForName() {
        print(UIColor.colorFor(name: "Yellow"))

        XCTAssertEqual(UIColor.colorFor(name: "Yellow"), UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0))
    }

    /* The Javascript library and this library produce different
       results, due to different color-comparing-algorithms.
       Therefore we can't do this random color test.
    */

//    func testRandomColorsGetSameResult() {
//        let webView = TestWebView()
//
//        let e = expectation(description: "Await fetching chir.ag website")
//        let request = URLRequest(url: URL(string: "http://chir.ag/projects/name-that-color/")!)
//        _ = webView.load(request) {
//            for _ in 0..<1000 {
//                let r = CGFloat(arc4random_uniform(255))
//                let g = CGFloat(arc4random_uniform(255))
//                let b = CGFloat(arc4random_uniform(255))
//
//                let color = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
//
//                webView.evaluateJavaScript("ntc.name('\(color.hex)')", completionHandler: { (result, error) in
//                    print("Testing: \(color.hex)")
//                    if let arrayResult = result as? [Any], let colorName = arrayResult[1] as? String {
//                        XCTAssertEqual(color.name, colorName)
//                        print("Both call it: \(color.name)")
//                    } else {
//                        XCTFail("Didn't get result from website.")
//                        print("uh?")
//                    }
//                })
//            }
//
//            e.fulfill()
//        }
//
//        wait(for: [e], timeout: 5.0)
//    }

    func testPerformanceExample() {
        self.measure {
            for _ in 0...1000 {
                XCTAssertEqual(UIColor.red.descriptiveName, "Red")
            }
        }
    }

}
