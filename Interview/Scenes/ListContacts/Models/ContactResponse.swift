import Foundation

/*
 Json Contract
[
  {
    "id": 1,
    "name": "Shakira",
    "photoURL": "https://picsum.photos/id/237/200/"
  }
]
*/

/* From class to struct:
 - simple and lightweight
 - no need inheritance
 
 Cleaning:
 - No need to have define the CodingKeys if the interface is the same as in the JSON
 */
struct ContactResponse: Codable, Equatable {
    var id: Int
    var name: String
    var photoURL: String
}
