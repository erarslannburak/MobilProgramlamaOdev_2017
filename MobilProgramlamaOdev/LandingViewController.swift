//
//  LandingViewController.swift
//  MobilProgramlamaOdev
//
//  Created by Burak Erarslan on 14.09.2020.
//  Copyright © 2020 Burak ERARSLAN. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func twoPersonAction(_ sender: Any) {
        showPlayerVC(players: .twoPlayer)
    }
    
    @IBAction func threePersonAction(_ sender: Any) {
        showPlayerVC(players: .treePlayer)
    }
    
    func showPlayerVC(players:Players) {
        let VC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "gamingVC") as? PlayerViewController
        VC?.players = players
        self.navigationController?.pushViewController(VC!, animated: true)
    }
}
