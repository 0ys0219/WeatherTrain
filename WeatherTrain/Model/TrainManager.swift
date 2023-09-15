//
//  TrainManager.swift
//  WeatherTrain
//
//  Created by 林育生 on 2023/9/11.
//

import Foundation

struct TrainManager {
    
    
    var delegate: Train?
    
    func searchTrainTimeFromtoken(with token: String)  {
        
       
        let urlString = URL(string: "https://tdx.transportdata.tw/api/basic/v3/Rail/TRA/DailyTrainTimetable/OD/1120/to/1000/2023-09-20?%24select=StopTimes&%24top=2&%24format=JSON")
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
                delegate?.searchTime(trainData)

                
                
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
                      
                      searchTrainTimeFromtoken(with: token.access_token)
                      
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





protocol Train {
    func searchTime(_ trainData: TrainData)
}

