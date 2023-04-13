# ios-weather-manager

✍🏻 프로젝트 기간: `23.03.13` ~ `23.04.14`

---
# 🪧 Agenda

[Step 1 - 모델/네트워킹 타입 구현](#🚀Step-1-모델/네트워킹-타입-구현)   
[Step 2 - 위치정보 확인 및 날씨 API 호출](#🚀Step-2-위치정보-확인-및-날씨-API-호출)     
[Step 3 - UI 구현](#🚀Step-3-UI-구현)   
Step 4 - 수동 위치 설정 기능 추가   
Step 5 - 화면회전 및 꺾은선 그래프  
실행결과

---

---
# 🚀 Step 1 - 모델/네트워킹 타입 구현
- Open Weather Map에서 제공하는 날씨 API의 데이터 형식을 고려하여 모델 타입으로 구현
- API를 통해 전달받은 JSON 데이터를 활용할 수 있는 모델 타입으로 구현
## 🎯 API 사용 관련 스터디
### API 사용을 위해 API KEY 발급 및 쿼리 사용에 대한 숙지
<img src="https://i.imgur.com/tc1rM4Z.png" width="60%">

### Postman을 활용하여 실제 데이터를 확인
<img src="https://i.imgur.com/5vFqAwZ.png">

### JSON형식의 데이터를 Model로 변환
```swift=
struct CurrentWeather: WeatherModel {
    let coordinator: Coordinate?
    let weathers: [Weather]
    let main: Main
    let visibility: Double?
    let wind: Wind?
    let clouds: Clouds?
    let rain: Rain?
    let snow: Snow?
    let timeOfDataCalculation: Double?
    let weatherSystem: WeatherSystem?
    let timezone: Int?
    let id: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case coordinator = "coord"
        case weathers = "weather"
        case main
        case visibility
        case wind
        case clouds
        case rain
        case snow
        case timeOfDataCalculation = "dt"
        case weatherSystem = "sys"
        case timezone
        case id
        case name
    }
}
```
### APIKEY를 숨기기 위해 xcconfig 형식의 파일에 APIKEY를 저장
`.gitignore` 파일에 `*.xcconfig` 을 추적하지 못하도록 설정

---

---
# 🚀 Step 2 - 위치정보 확인 및 날씨 API 호출
- 현재 위치의 위도와 경도 확인
- 위도와 경도를 활용해 현재 위치의 주소 확인
- 현재 위치의 날씨와 현재 위치의 5일 예보를 날씨 API를 통해 데이터를 요청하고 받아오는 기능을 구현

## URLSession을 사용하여 JSON 데이터 받아오기
### 1️⃣ URLComponents
Open API로 `HTTPMethod`를 GET요청을 해야할 URL이 위치가 변경될 때마다 새로운 URL이 필요하게 되어 URLComponent를 사용하여 Path와 Query를 이용하여 URL을 만들도록 하였다.
```swift=
static func configureURL(of weatherCastType: URLPath,
                         with coordintate: CLLocationCoordinate2D) throws -> URL {
    let baseURL: String = "https://api.openweathermap.org/data/2.5/"
    let latitude = URLQueryItem(name: OpenWeatherParameter.latitude, value: coordintate.latitude.description)
    let longitude = URLQueryItem(name: OpenWeatherParameter.longitude, value: coordintate.longitude.description)
    let unitsOfMeasurement = URLQueryItem(name: OpenWeatherParameter.measurement, value: Measurement.celsius)

    guard let weatherAPIKEY = Bundle.main.object(forInfoDictionaryKey: "WeatherAPIKEY") as? String else {
        fatalError("Weather API KEY is E.M.P.T.Y !!")
    }

    guard var components = URLComponents(string: "\(baseURL)\(weatherCastType.path)") else {
        throw URLComponentsError.invalidComponent
    }

    let appid = URLQueryItem(name: OpenWeatherParameter.apiKey, value: weatherAPIKEY)
    components.queryItems = [latitude, longitude, appid, unitsOfMeasurement]

    guard let url = components.url else {
        throw URLComponentsError.invalidComponent
    }

    return url
}
```
### 2️⃣ JSON Decoder
URLRequest를 통해 받아오는 데이터는 타입이 Data(Byte)로 나오기 떄문에 프로젝트에서 직접 사용해야 하는 
타입으로 Decoding이 필요한 부분을 메서드로 분리하였다.  
추가적으로 프로젝트에서 Forecast(5일 예보)와 CurrentWeather(현재 날씨) 타입 모두를 받을 수 있도록
`WeatherModel`프로토콜 타입으로 묶어서 사용하였다.

```Swift=
private func loadJSON(weatherType: WeatherModel.Type, weatherData: Data) -> WeatherModel? {
    let decoder = JSONDecoder()

    do {
        let wishData = try decoder.decode(weatherType, from: weatherData)
        return wishData
    } catch {
        print("Unable to decode \(weatherData): (error)")
        return nil
    }
}
```
### 3️⃣ URL Request
위 `configureURL(of: with:)` 메서드를 통해 나온 URL을 URLRequest메서드에서 사용할 수 있다.   
HTTP Response Error에 대한 핸들링은 200에서 299번대의 Error에 대해서만 진행하였고 
Apple 공식문서에 의거하였다.
```Swift=
let url = try URLPath.configureURL(of: path, with: location)
var urlRequest = URLRequest(url: url)

urlRequest.httpMethod = "GET"
session.dataTask(with: urlRequest) { data, response, error in
    guard error == nil else {
        completion(nil, NetworkError.notConnected)
        return
    }

    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        let responseError = HTTPResponseError.error(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 404,
                                                    description: response.debugDescription)
        completion(nil, responseError)
        return
    }

    guard let data = data else {
        completion(nil, NetworkEntityLoadingError.networkFailure)
        return
    }

    guard let wishData = self.loadJSON(weatherType: path.weatherMetaType, weatherData: data) else {
        completion(nil, NetworkEntityLoadingError.invalidData)
        return
    }
    completion(wishData, nil)
}.resume()
```
---

---
# 🚀 Step 3 - UI 구현
- CollectionView의 구성요소를 `CollectionLayoutListConfiguration`에서 ReusableView와 ListCell로 구현
- CompositionalLayout을 활용하여 Collection View를 코드로 구현
- View와 Model간의 `Data Binding`은 Delegate를 사용하여 구현

## 🎯 Collection View 관련 스터디
### CollectionView DataSource
CollectionView가 처음 나왔을 때 같이 공개되었던 가장 기본이 되는 DataSource로서
CollectionView에 대한 Cell을 제공하는데 사용하는 개체로 ViewController에 채택하여 사용하였다.

### CollectionLayoutListConfiguration을 활용한 Layout 설정
iOS 14 이후에 생긴 `CollectionLayoutListConfiguration`를 활용하여 collectionView에 대한 
구성요소를 `grouped`으로 설정 및 headerView를 등록(Regist)하였고   
CompositionalLayout에서 UICollectionViewListCell으로 사용할 수 있는  `list(using:)` 메서드를 사용하여 구현하였다.

```swift=
private func configureCollectionView() -> UICollectionViewLayout {
    var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
    configuration.headerMode = .supplementary
    configuration.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.2)
    return UICollectionViewCompositionalLayout.list(using: configuration)
}
```


## 🧨 트러블 슈팅
### ListCell 등록하기
기존에는 CompositionalLayout을 사용하면 Section -> Group Size -> Group -> Item Size -> Item 순으로 Section의 속성을 정의하여   
Cell의 UI Components들을 사용하였는데 날씨앱에서는 TableViewCell처럼 사용하기 때문에 ListCell을 사용해보려고 하였다.   
처음에는 Section을 만들어 UICollectionViewCell을 사용하는 방법으로 진행하였는데 기존의 CustomCell을 ListCell로 Configuration을 바꿔서 사용하였다.

### AutoLayout 충돌 문제
<img src="https://user-images.githubusercontent.com/79438622/231670384-adabd34d-25ce-4321-983d-64f8db6a4e97.png">

 `CollectionLayoutListConfiguration`의 적용된 제약 조건이 아닌 Custom으로 만든 View의 제약 조건으로 변경되기 위해 priority를 주어 적용시켰다.
 
```swift=
extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
}
```