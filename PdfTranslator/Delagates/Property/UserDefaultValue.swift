//
//  UserDefaultValue.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/13/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
  let key: String
  let defaultValue: T
  
  var wrappedValue: T {
    get {
      return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}
