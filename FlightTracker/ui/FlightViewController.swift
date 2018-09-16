//
//  FlightViewController.swift
//  FlightTracker
//
//  Created by Michael Zhou on 2018-08-03.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import UIKit

class FlightViewController: UIViewController {
    
    var flight : Flight?
    @IBOutlet weak var flightNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flightNameLabel.text = flight?.name
        // Do any additional setup after loading the view.
    }
    
    @IBAction func viewFlightTapped(_ sender: Any) {
        performSegue(withIdentifier: "showPathSegue", sender: flight)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPathSegue" {
            let nextVC = segue.destination as! PathViewController
            nextVC.flight = sender as! Flight
        }
    }
}
