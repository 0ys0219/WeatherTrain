//
//  TrainManager.swift
//  WeatherTrain
//
//  Created by 林育生 on 2023/9/11.
//

import Foundation

struct TrainManager {
    
    
    func searchTrainTime(with token: String)  {
        
       
        let urlString = URL(string: "https://tdx.transportdata.tw/api/basic/v3/Rail/TRA/DailyTrainTimetable/OD/1120/to/1000/2023-09-11?%24select=StopTimes&%24top=2&%24format=JSON")
        guard let url = urlString else {
            print("url失敗")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, response, error in
            if  let e = error {
                print("session失敗",e)
                
            }
            
            guard let safeData = data else {
                print("沒有data")
                return
            }
            

            
            let decoder = JSONDecoder()
            do {
                
                let trainData = try decoder.decode(TrainData.self, from: safeData)
                print(trainData)
//                var trainModel = TrainModel()
//                trainModel.startTime = trainData.TrainTimetables[0].StopTimes[0].DepartureTime
//                trainModel.endTime = trainData.TrainTimetables[0].StopTimes[1].ArrivalTime
//                print(trainModel.startTime,trainModel.endTime)
                
                
            } catch {
                print("Json有問題：\(error)")
            }
            
            
        }
        task.resume()
    }
    
    
    
     func getToken()  {
        
        let headers = ["content-type": "application/x-www-form-urlencoded"]

        let postData = NSMutableData(data: "grant_type=client_credentials".data(using: String.Encoding.utf8)!)
        postData.append("&client_id=lmt860219-1225f581-083c-4001".data(using: String.Encoding.utf8)!)
        postData.append("&client_secret=186934af-15df-40d1-86f8-5be32263e9a5".data(using: String.Encoding.utf8)!)
//        postData.append("&audience=YOUR_API_IDENTIFIER".data(using: String.Encoding.utf8)!)

        let request = NSMutableURLRequest(url: NSURL(string: "https://tdx.transportdata.tw/auth/realms/TDXConnect/protocol/openid-connect/token")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error)  in
          if let e = error  {
            print(e)
          } else {
              if let safeData = data {
                  let deocder = JSONDecoder()
                  do {
                      let token = try deocder.decode(Token.self, from: safeData)
                      
                      searchTrainTime(with: token.access_token)
                      
                  } catch {
                      print(error)
                  }
              }
              
          }
        })
         
        dataTask.resume()
      
    }
}


struct Token: Codable {
    var access_token: String
}


struct TrainModel {
    var stationID: String = ""
    var stationName: String = ""
    var startStation: String = ""
    var endStation: String = ""
    var startTime: String = ""
    var endTime: String = ""
}
