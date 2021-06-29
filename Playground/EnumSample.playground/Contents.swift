import UIKit

enum APIResultType{
    case Success(data: String)
    case Error(statusCode: Int, errorMessage: String)
}

enum SampleType{
    case One
    case Two
}

let one = SampleType.One
let two = SampleType.Two

if one == two{
    // ...
}else{
    // ...
}

let success = APIResultType.Success(data: "レスポンスデータです")
let error = APIResultType.Error(statusCode: 404, errorMessage: "エラーです")

extension APIResultType: Equatable{
    static func ==(lhs: APIResultType, rhs: APIResultType) -> Bool{
        switch (lhs, rhs) {
        case (let .Success(lhsData), let .Success(rhsData)):
            return true
        case (let .Error(statusCode: lhsStatusCode, errorMessage: lhsErrorMessage),
              let .Error(statusCode: rhsStatusCode, errorMessage: rhsErrorMessage)):
            return true
        default:
            return false
        }
    }
}


if success == error{
    print("同じ型です")
}
