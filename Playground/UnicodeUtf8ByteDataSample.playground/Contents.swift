import UIKit

var str = "Hello, playground"

/// バイト配列
var byteArray: [UInt8] = [0x33, 0x45, 0x55, 0x00]
print(byteArray)  // [51, 69, 85, 0]

/// バイト配列をData型（バイナリを扱う型）に変換
var data = Data(byteArray)
print(data) // 4 bytes

var convertByteArray = Array(data)
print(convertByteArray)     // [51, 69, 85, 0]

var convertStr = convertByteArray.map{ String(format: "%02x", $0) }.joined()
print(convertStr)  // 33455500

data = convertStr.data(using: .ascii)!
print(data)    // 8 bytes

/// unicode 文字列
/// memo: String は Unicode 文字のコレクション
/// https://developer.apple.com/documentation/swift/string
var utf8String = String(data: data, encoding: .utf8)
print(utf8String)  // Optional("3EU\0")

var sampleStr = "0006wwwwwwwwあ"
var sampleData = sampleStr.data(using: .ascii)
print(sampleData)   // nil
sampleData = sampleStr.data(using: .utf8)
print(sampleData)   // 15 bytes
sampleData = sampleStr.data(using: .utf16)
print(sampleData)   // 28 bytes

sampleStr = "0006wwwwwwww"
sampleData = sampleStr.data(using: .ascii)
var sampleArray: [UInt8] = Array(sampleData!)
print(sampleArray)  // [48, 48, 48, 54, 119, 119, 119, 119, 119, 119, 119, 119]
var utf8Str = String(data: sampleData!, encoding: .utf8)
print(utf8String)  // Optional("3EU\0")

var hexStr = sampleData?.map{ String(format: "%02x", $0) }.joined()
print(hexStr, hexStr?.count, sampleStr.count) // Optional("303030367777777777777777") Optional(24) 12
var asciiStr = String(data: sampleData!, encoding: .ascii)
print(asciiStr) // Optional("0006wwwwwwww")

var hogeData = Data(sampleArray)
print(hogeData) // 12 bytes

var hogeByteArray = [UInt8]()
var offset0Str = 0
for i in 0..<10{
    hogeByteArray.append(0)
}
var hogeHexStr = hogeByteArray.map{ String(format: "%02x", $0) }.joined()
print(hogeHexStr, hogeHexStr.count)  // 00000000000000000000 20

hogeData = hogeHexStr.data(using: .ascii)!
print(hogeData)  // 20 bytes
hogeByteArray = Array(hogeData)
print(hogeByteArray, hogeByteArray.count) // [48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48] 20

// 16進文字列を[Uint8]配列に変換する方法(memo: 16進文字列2桁 == 1 byte(UInt8 1桁))
// -> 16進文字列を2つずつ繰り返すUInt8配列に変換する。
// https://stackoverflow.com/questions/43360747/how-to-convert-hexadecimal-string-to-an-array-of-uint8-bytes-in-swift

// --------
var byteArray: [UInt8] = [0x54, 0x59, 0xff, 0xff]

var data = Data(byteArray)
print(data)  // 4 bytes

var sampleStr = data.map{ String(format: "%08X", $0) }.joined()
print(sampleStr)  // 0000005400000059000000FF000000FF
sampleStr = data.map{ String(format: "%08x", $0) }.joined()
print(sampleStr)  // 0000005400000059000000ff000000ff

sampleStr = data.map{ String(format: "%02X", $0) }.joined()
print(sampleStr)  // 5459FFFF
sampleStr = data.map{ String(format: "%02x", $0) }.joined()
print(sampleStr) // 5459ffff

var uint32: UInt32 = 0x100000
print(uint32)  // 1048576
var uint32Str = String(format: "%02X", uint32)
print(uint32Str) // 100000

var hogeDataArray = Array(data)
//var hogehogeDataArray = [hogeDataArray[2], hogeDataArray[3]]


var hogehogeDataArray: [UInt8] = [0x00, 0xff]
var hoge = hogehogeDataArray.withUnsafeBytes{ $0.load(as: UInt16.self) }
print(hoge) // 65280
print(Int(hoge.bigEndian)) // 255
print(hoge.bigEndian) // 255
print(hoge.littleEndian) // 65280

var int32: Int32 = 0x300
print(int32, int32.littleEndian, int32.bigEndian, int32 == 0x300)  // 768 768 196608 true


