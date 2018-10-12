### Introduction

A library that defines 1500+ names of colors. The naming has been taken from http://chir.ag/projects/ntc/). However, euclidean distance is used instead to find the color closest.


### Usage 

```swift
let myColor = UIColor.red

myColor.name // "Red"

let anotherColor = UIColor(red: 0xEE/0xFF, green: 0xD9/0xFF, blue: 0xC4/0xFF, alpha: 1.0)

anotherColor.name //  "Almond"
```

### Installation

**CocoaPods:**

Add the line `pod "NameThatColor"` to your `Podfile`

**Carthage:**

Add the line `github "everlof/NameThatColor"` to your `Cartfile`
