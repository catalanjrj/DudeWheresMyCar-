//
//  PopoverlocationView.swift
//  Dude,WheresMyCar?
//
//  Created by Jorge Catalan on 5/23/16.
//  Copyright © 2016 Jorge Catalan. All rights reserved.
//

import Foundation
import UIKit

protocol PopoverLocationViewControllerDelegate: class {
    func setCarLocationName(carLocationName: String)
}

class PopoverLocationViewController: UIViewController {
    
    @IBOutlet weak var carLocation: UITextField!

    
    var delegate: PopoverLocationViewControllerDelegate?
    
    var carLocationName: String = ""
    


    @IBAction func carLocationSaveButton(sender: UIButton) {
        carLocationName = carLocation.text!
        delegate?.setCarLocationName(carLocationName)
    }
    
    
}