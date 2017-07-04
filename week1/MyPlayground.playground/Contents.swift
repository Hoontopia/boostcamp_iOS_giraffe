//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
str = "Hello, Swift"
let constStr = str

/// constStr = "Hello, world" => 상수에 값을 넣으려 했기 때문에 에러

var nextYear: Int
var bodyTemp: Float
var hasPet: Bool

var arrayOfInts: Array<Int>
/// var arrayOfInts: [Array] => 축약형

var dictionarayOfCapitalsByCountry: Dictionary<String, String>
/// var dictionarayOfCapitalsByCountry: [String: String] => 축약형
var winningLotteryNumbers: Set<Int>

let number = 42
let fmStation = 91.1

var countingUp = ["one", "two"]
/// 서브스크립팅
let secondElement = countingUp[1]
countingUp.count
/// 배열의 인스턴스 메서드 사용
countingUp.append("three")

let nameByParkingSpace = [13: "Alice", 27: "Bob"]
/// 딕셔너리 서브스크립팅의 결과는 옵셔널
/// let space13Assignee: String? = nameByParkingSpace[13]
if let space13Assignee = nameByParkingSpace[13] {
    print("Key 13 is assigned in the dictionary!")
}
let space42Assignee: String? = nameByParkingSpace[42]


/// 빈 리터럴 반환하는 이니셜라이저 호출
let emptyString = String()
let emptyArrayOfInts = [Int]()
let emptySetOfFloats = Set<Float>()
emptyString.isEmpty

/// 기본 값을 가지는 타입들
let defaultNumber = Int()
let defaultBool = Bool()

let meaningOfLife = String(number)
/// 배열 리터럴을 허용하는 Set 이니셜라이저
let availableRooms = Set([205, 411, 412])

let defaultFloat = Float()
let floatFromLiteral = Float(3.14)

/// 부동 소수점 리터럴은 타입 추론을 사용하면 Double이 기본 타입
let easyPi = 3.14
let floatFromDouble = Float(easyPi)
let floatingPi: Float = 3.14

/// 옵셔널 타입 선언
var anOptionalFloat: Float?
var anOptionalArrayOfStrings: [String]?
var anOptionalArrayOfOptionalStrings: [String?]?

var reading1: Float?
var reading2: Float?
var reading3: Float?

reading1 = 9.8
reading2 = 9.2
reading3 = 9.7
/// let avgReading = (reading1 + reading2 + reading3) / 3
/// 옵셔널 언랩핑을 해주지 않았기 때문에 값을 사용할 수 없다

/// 옵셔널 강제 언랩핑 사용 (트랩이 발생할 위험이 있으니 지양해야한다)
/// let avgReading = (reading1! + reading2! + reading3!) / 3
if let r1 = reading1,
    let r2 = reading2,
    let r3 = reading3 {
    let avgReading = (r1 + r2 + r3) / 3
} else {
    let errorString = "Instrument reported a reading that was nil."
}

/// 전통적인 C스타일의 루프문은 스위프트에서 불가능
let range = 0..<countingUp.count
for i in range {
    let string = countingUp[i]
}

/// 배열 자체에서 항목들 열거
for string in countingUp {
}

/// enumerate() 함수는 해당 인자의 정수와 값을 차례로 반환
for (i, string) in countingUp.enumerated() {
}

for (space, name) in nameByParkingSpace {
    let permit = "Space \(space): \(name)"
}

/// 열거형은 값의 집합으로 이루어진 타입! 원시 값을 가질 수 있다.
enum PieType: Int {
    case apple = 0
    case cherry
    case pecan
}

/// 열거형의 원시값은 옵셔널
let pieRawValue = PieType.pecan.rawValue

if let pieType = PieType(rawValue: pieRawValue) {
}

let favoritePie = PieType.apple
let name: String

switch favoritePie {
case .apple:
    name = "Apple"
case .cherry:
    name = "Cherry"
case .pecan:
    name = "Pecan"
}

let osxVersion: Int = 10
switch osxVersion {
case 0...8:
    print("A big cat")
case 9:
    print("Mavericks")
case 10:
    print("Yosemite")
default:
    print("Greetings, people of the future! What's new in 10. \(osxVersion)?")
}

