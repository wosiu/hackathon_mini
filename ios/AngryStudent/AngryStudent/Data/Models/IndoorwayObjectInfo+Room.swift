import Foundation
import IndoorwaySdk



fileprivate let idToNumber: [String: String] = [
  "3-_M01M3r5w_36a38": "211",
  "3-_M01M3r5w_76b29": "212",
  "3-_M01M3r5w_fe9c8": "213",
  "3-_M01M3r5w_c1a68": "214",
  "3-_M01M3r5w_ca808": "216",
  "gVI7XXuBFCQ_c0b28": "103",
  "gVI7XXuBFCQ_a18d9": "107",
]



extension IndoorwayObjectInfo {
  var roomName: String? {
    guard let number: String = idToNumber[self.objectId] else {
      return nil
    }
    return R.string.common_room_name[number]
  }
  
  static func isRoom(_ obj: IndoorwayObjectInfo) -> Bool {
    return idToNumber[obj.objectId] != nil
  }
}


