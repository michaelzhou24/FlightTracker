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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewFlightTapped(_ sender: Any) {
        performSegue(withIdentifier: "plotPathSegue", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
    

}
