//
//  PlayerViewController.swift
//  MobilProgramlamaOdev
//
//  Created by Macbook Pro on 5.05.2017.
//  Copyright © 2017 Burak ERARSLAN. All rights reserved.
//

class MyCell:UICollectionViewCell {
    @IBOutlet weak var markLabel:UILabel!
}

enum Players:Int {
    case twoPlayer = 2
    case treePlayer = 3
}

enum MarkType:String {
    case X = "X"
    case O = "O"
    case Y = "Y"
    case none = ""
}

struct Item {
    var mark:MarkType
    var color:UIColor
}

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
  
    @IBOutlet weak var collectionView:UICollectionView!
    
    var player = AVAudioPlayer()
    var players:Players!
    var rightButton:UIButton!

    var itemSectionList:[[Item]] = [[],[],[],[],[],[],[],[],[]]
    var isMuted = true
    var counter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        addNavigationItemButtons()

        reload()
        effect()
    }
    
    func reload() {
        counter = 0
        for i in 0..<9 {
            itemSectionList[i].removeAll()
            for _ in 0..<6 {
                itemSectionList[i].append(Item(mark: .none, color: .red))
            }
        }
        collectionView.isUserInteractionEnabled = true
        collectionView.reloadData()
    }
    
    func effect(){
        do{
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "ring", ofType: "mp3")!) as URL)
        }
        catch let error {
            print(error)
        }
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSession.Category.playback)
        }
        catch let error {
            print(error)
        }
    }
    
    func addNavigationItemButtons() {
        let leftButtonContainer = UIView(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        let leftButton = UIButton(frame: CGRect.init(x: 4, y: 4, width: 32, height: 32))
        leftButton.setImage(#imageLiteral(resourceName: "home"), for: .normal)


        leftButton.addTarget(self, action: #selector(self.popToRootVC), for: .touchUpInside)
        leftButtonContainer.addSubview(leftButton)
        
        let rightButtonContainer = UIView(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        rightButton = UIButton(frame: CGRect.init(x: 4, y: 4, width: 32, height: 32))
        rightButton.setImage(#imageLiteral(resourceName: "speaker"), for: .normal)


        rightButton.addTarget(self, action: #selector(self.mutedUnMuted), for: .touchUpInside)
        rightButtonContainer.addSubview(rightButton)
        
        self.title = "tictactoe"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButtonContainer)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButtonContainer)
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        reload()
    }
    
    @objc func popToRootVC() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func mutedUnMuted() {
        if(isMuted){
            isMuted = !isMuted
            rightButton.setImage(#imageLiteral(resourceName: "muted"), for: .normal)
        }else{
            isMuted = !isMuted
            rightButton.setImage(#imageLiteral(resourceName: "speaker"), for: .normal)
        }
    }
    
    func play() {
        if isMuted {
            player.currentTime = 0
            self.player.play()
        }
    }
    
    func checkWin(mark:MarkType) {
        
        for row in 0 ..< itemSectionList.count {
            for col in 0 ..< itemSectionList[row].count {
                
                //Vertical Check
                if row + 2 < itemSectionList.count {
                    if itemSectionList[row][col].mark == mark && itemSectionList[row+1][col].mark == mark && itemSectionList[row+2][col].mark == mark {
                        
                        itemSectionList[row][col].color = .green
                        itemSectionList[row+1][col].color = .green
                        itemSectionList[row+2][col].color = .green
                        
                        Win(player: mark)
                        
                    }
                }
                
                //Horizontal Check
                if col+2 < itemSectionList[row].count {
                    if itemSectionList[row][col].mark == mark && itemSectionList[row][col+1].mark == mark && itemSectionList[row][col+2].mark == mark {
                        
                        itemSectionList[row][col].color = .green
                        itemSectionList[row][col+1].color = .green
                        itemSectionList[row][col+2].color = .green
                        
                        Win(player: mark)
                        
                    }
                }
                
                //Diagonal Right Check
                if row + 2 < itemSectionList.count, col+2 < itemSectionList[row+2].count {
                    
                    if itemSectionList[row][col].mark == mark && itemSectionList[row+1][col+1].mark == mark && itemSectionList[row+2][col+2].mark == mark {
                        itemSectionList[row][col].color = .green
                        itemSectionList[row+1][col+1].color = .green
                        itemSectionList[row+2][col+2].color = .green
                        
                        Win(player: mark)
                    }
                }
                
                //Diagonal Left Check
                if row + 2 < itemSectionList.count && col-2 > 0 {
                    if itemSectionList[row][col].mark == mark && itemSectionList[row+1][col-1].mark == mark && itemSectionList[row+2][col-2].mark == mark {
                        
                        itemSectionList[row][col].color = .green
                        itemSectionList[row+1][col-1].color = .green
                        itemSectionList[row+2][col-2].color = .green
                        
                        Win(player: mark)
                    }
                }
            }
        }
    }
    
    func Win(player:MarkType){
        self.title = "\(player.rawValue) Kazandı"
        collectionView.isUserInteractionEnabled = false
        collectionView.reloadData()
    }
}

extension PlayerViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemSectionList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemSectionList[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MyCell
        cell.markLabel.text = itemSectionList[indexPath.section][indexPath.row].mark.rawValue
        cell.backgroundColor = itemSectionList[indexPath.section][indexPath.row].color
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.collectionView.frame.width - 28)/6
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if section == itemSectionList.count - 1 {
            return .zero
        }
        
        return CGSize(width: self.collectionView.frame.width, height: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if itemSectionList[indexPath.section][indexPath.row].mark == .none {
            let cell = collectionView.cellForItem(at: indexPath) as! MyCell
            if counter % self.players.rawValue == 0 {
                self.itemSectionList[indexPath.section][indexPath.row].mark = .X
            }else if counter % self.players.rawValue == 1 {
                self.itemSectionList[indexPath.section][indexPath.row].mark = .O
            }else if counter % self.players.rawValue == 2 {
                self.itemSectionList[indexPath.section][indexPath.row].mark = .Y
            }
            cell.markLabel.text = self.itemSectionList[indexPath.section][indexPath.row].mark.rawValue
            checkWin(mark: self.itemSectionList[indexPath.section][indexPath.row].mark)
            play()
            counter += 1
        }
    }
}
