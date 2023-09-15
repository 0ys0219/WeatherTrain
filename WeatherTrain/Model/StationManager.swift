//
//  Station.swift
//  WeatherTrain
//
//  Created by 林育生 on 2023/9/15.
//

import Foundation

struct StationManager {
    
    var delegate: Station?

    
    let urlStr = "https://tdx.transportdata.tw/api/basic/v3/Rail/TRA/Station?%24select=StationID%2CStationName%2C%20StationAddress&%24format=JSON"
    
    func getAllStationInfo()  {
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
                     let token = try deocder.decode(TokenData.self, from: safeData)
                     fetchAllStation(token: token.access_token)
                 } catch {
                     print(error)
                 }
             }
         }
       })
       dataTask.resume()
   }
    
    
    func fetchAllStation(token: String) {
        guard let url = URL(string: urlStr) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, response, error in
            if  let e = error { print(e) }
            guard let safeData = data else { return }
 
            let decoder = JSONDecoder()
            do {
                let stationData = try decoder.decode(StationData.self, from: safeData)
                delegate?.updateAllStationToArray(stationData)
                
            } catch {
                print("StationManager Json有問題：\(error)")
            }
        }
        task.resume()
    }
}

protocol Station {
    func updateAllStationToArray(_ stationData: StationData)
}
