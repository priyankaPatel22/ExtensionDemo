//
//  ViewController.swift
//  LocalizationDemo
//
//  Created by ispl Mac Mini on 8/19/17.
//  Copyright © 2017 infinium. All rights reserved.
//

import UIKit

let APPLE_LANGUAGE_KEY = "AppleLanguages"

class ViewController: UIViewController {

    
    
    @IBOutlet var lblName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        lblName.text=NSLocalizedString("myName", comment: "msg")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switchLanguage(_ sender: UIButton) {
        if L102Language.currentAppleLanguage() == "en" {
            L102Language.setAppleLAnguageTo(lang: "hi-IN")
        } else {
            L102Language.setAppleLAnguageTo(lang: "en")
        }
        
        lblName.text=NSLocalizedString("myName", comment: "msg")
    }
}

// constants

/// L102Language
class L102Language {
    /// get current Apple language
    class func currentAppleLanguage() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
}
