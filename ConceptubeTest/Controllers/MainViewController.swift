//
//  ViewController.swift
//  ConceptubeTest
//
//  Created by blue on 15/12/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var deskView: UIView!
    
    let NUMBER_CARDS: Int = 78
    
    private var desks: [CardView] = [CardView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        desks = generateDeskOfCards()
        shuffleCards()
        
        
    }
    
    func generateDeskOfCards() -> [CardView] {
        var myDesk: [CardView] = [CardView]()

        for i in 0..<NUMBER_CARDS {
            let cardView = CardView(frame: CGRect(x: deskView.frame.size.width/2 - 175/2, y: deskView.frame.size.height/2 - 270/2, width: 175, height: 270))
            cardView.setCard(i)
            myDesk.append(cardView)
            deskView.addSubview(cardView)
        }
        
        return myDesk
    }
    
    @IBAction func shuffleCards() {
        desks.shuffle()
        
        for i in 0..<desks.count {
            desks[i].resetState(i) // pass index to set z offset of card
            deskView.bringSubviewToFront(desks[i])
        }
        
    }
    
}

