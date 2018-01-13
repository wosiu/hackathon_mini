import Foundation
import IndoorwaySdk


fileprivate let idToFloor: [String: Int] = [
  "7-QLYjkafkE": 0,
  "gVI7XXuBFCQ": 1,
  "3-_M01M3r5w": 2,
]


extension IndoorwayMapDescription {
  var floor: Int? {
    return idToFloor[mapUuid]
  }
}
