import Foundation


extension R {
  static let musles: MusleDictionary = .instance
  
  enum MusleDictionary {
    case instance
    subscript(id: Int) -> String {
      return NSLocalizedString("muscle_\(id)", comment: "")
    }
  }
}


extension R.string {
  subscript(_ arguments: CVarArg...) -> String {
    return String(format: self^, arguments: arguments)
  }
}


postfix operator ^

postfix func ^ (key: R.string) -> String {
  return NSLocalizedString(key.rawValue, comment: "")
}
