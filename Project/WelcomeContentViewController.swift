//
//  WelcomeContentViewController.swift
//  iosCard
//
//  Created by Tony Ren on 2021-11-02.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

class WelcomeContentViewController: UIViewController {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    var index = 0
    var heading = ""
    var content = ""
    var imageFile = ""
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var forwardButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Initialize
        self.headingLabel.text = self.heading
        
        self.contentImageView.image = UIImage(named: self.imageFile)
        contentImageView.layer.masksToBounds = true
        contentImageView.layer.borderWidth = 1.5
        contentImageView.layer.borderColor = UIColor.black.cgColor
//        contentImageView.layer.cornerRadius = contentImageView.bounds.width / 5
        
        self.pageControl.currentPage = self.index
        
        switch index  {
        case 0...2: self.forwardButton.setTitle("Next", for: UIControl.State())
        case 3: self.forwardButton.setTitle("Done", for: UIControl.State())
        default: break
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        switch index {
            
        case 0...2:
            //On welcome view
            let pageViewController = parent as! WelcomePageViewController
            pageViewController.forward(index)
        case 3:
            //Confirm that user has viewed welcome screen
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "hasViewedWelcome")
            
            dismiss(animated: true, completion: nil)
            
        default: break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
