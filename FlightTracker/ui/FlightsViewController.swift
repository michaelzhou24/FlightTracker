//
//  FlightsViewController.swift
//  FlightTracker
//
//  Created by Michael Zhou on 2018-07-17.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import UIKit

class FlightsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tableView: UITableView!
    var flights : [Flight] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        do {
            flights = try context.fetch(Flight.fetchRequest()) as! [Flight]
        } catch {
            print(error)
        }
        print(flights)
    }
    
    @IBAction func deleteAllFlights(_ sender: Any) {
        for flight in flights {
            context.delete(flight)
        }
        flights = []
        appDelegate.saveContext()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            flights = try context.fetch(Flight.fetchRequest()) as! [Flight]
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let flight = flights[indexPath.row]
        cell.textLabel?.text = flight.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "flightInfoSegue", sender: flights[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? FlightViewController {
            nextVC.flight = sender as? Flight
        }
        
    }

}
