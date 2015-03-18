//
//  Detail.swift
//  WashingtonSwiftMeetup
//
//  Created by Cameron Conway on 3/17/15.
//  Copyright (c) 2015 Cam-Built Programming Plus. All rights reserved.
//

import UIKit

class Detail:UIViewController
{
    @IBOutlet weak var labelName: UILabel!
    
    var delegate:TableViewController?
    var address:[String:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelName.text = address["Name"]
    }
    
}
