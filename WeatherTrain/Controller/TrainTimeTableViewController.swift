//
//  TrainTimeTableViewController.swift
//  WeatherTrain
//
//  Created by 林育生 on 2023/9/9.
//

import UIKit

class TrainTimeTableViewController: UITableViewController {

    
    
    var trainManager = TrainManager()
    var trainDetails = [TrainModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trainManager.delegate = self
        trainManager.getToken()
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trainDetails.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainTimeCell", for: indexPath)

        cell.textLabel?.text = trainDetails[indexPath.row].startStation
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TrainTimeTableViewController: Train {
    func searchTime(_ trainData: TrainData) {
        DispatchQueue.main.async {
            for train in trainData.TrainTimetables {
                let startStation = train.StopTimes[0].StationName.Zh_tw
                let startTime = train.StopTimes[0].DepartureTime
                let endStation = train.StopTimes[1].StationName.Zh_tw
                let endTime = train.StopTimes[1].ArrivalTime
                self.trainDetails.append(TrainModel(startStation: startStation, endStation: endStation, startTime: startTime, endTime: endTime))
            }
            self.tableView.reloadData()
        }
        
    }
}
