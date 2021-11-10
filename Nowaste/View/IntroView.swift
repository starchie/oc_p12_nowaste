//
//  IntroView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 03/11/2021.
//

import UIKit



class IntroView: UIView {
    
    //var animator = UIDynamicAnimator()
    //var gravity = UIGravityBehavior()
    //var collision = UICollisionBehavior()
    //var fruits = ["🍎","🍏","🍐","🍋","🍊"]

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        /*
        let fruit = UILabel()
        fruit.frame = CGRect(x: 100, y: 0, width: 50, height: 50)
        let size = Int.random(in: Range(30...60))
        fruit.text = "🍎"
        fruit.font = UIFont(name: "Helvetica", size: CGFloat(size))
        fruit.sizeToFit()
        
        self.addSubview(fruit)
        
        
        let wall = UIView()
        wall.frame = CGRect(x: 50, y: self.frame.midY - 5, width: self.frame.width - 120, height: 100)
        wall.backgroundColor = .blue
        
        
        
        animator = UIDynamicAnimator(referenceView: self)
        gravity = UIGravityBehavior(items: [fruit])
        collision = UICollisionBehavior(items: [fruit])
        collision.addBoundary(withIdentifier:"textView" as NSCopying , for: UIBezierPath(rect: wall.frame))
        collision.translatesReferenceBoundsIntoBoundary = true
        
        
        var delay = 0
        
        for _ in 0..<100 {
            Timer.scheduledTimer(withTimeInterval: TimeInterval(6 * delay), repeats: false) { (timer) in
                self.animator.removeAllBehaviors()
                let size = Int.random(in: Range(24...50))
                let index = Int.random(in: Range(0...4))
                fruit.text = self.fruits[index]
                fruit.font = UIFont(name: "Helvetica", size: CGFloat(size))
                fruit.sizeToFit()
                fruit.center.x = CGFloat( Int.random(in: Range(0...Int(self.frame.width) )  )    )
                fruit.center.y = 0
                self.animator.addBehavior(self.gravity)
                self.animator.addBehavior(self.collision)
                
            }
            delay += 1
            
        }
         */
         
        
        
    }
    
   
    
}
/*
class IntroView: UIView {
    
    var tree:UIImageView!
    var apples:[UILabel]!
    var wall:UIView!
    
    var animators = [UIDynamicAnimator]()
    var gravities = [UIGravityBehavior]()
    var collisions = [UICollisionBehavior]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tree = UIImageView()
        tree.image = UIImage(named: "tree")
        tree.sizeToFit()
        tree.center = self.center
        tree.center.y = 160
        self.addSubview(tree)
        print (tree.frame)
        
        apples = [UILabel]()
        for i in 0...10 {
            let apple = UILabel()
            apple.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            let x = Int.random(in: Range(0...80)) + 20
            let y = Int.random(in: Range(0...80)) + 20
            let size = Int.random(in: Range(3...12)) 
            apple.text = "🍎"
            apple.font = UIFont(name: "Helvetica", size: CGFloat(size))
            apple.sizeToFit()
            
            apple.center = CGPoint(x: x,
                                   y: y)
           // apple.frame.size = CGSize(width: x / 10, height: x / 10)
            
            apples.append(apple)
            self.tree.addSubview(apples[i])
           
        }
        
        wall = UIView()
        wall.frame = CGRect(x: 0, y: self.frame.midY - 5, width: self.frame.width, height: 100)
        
        for apple in apples {
            let animator = UIDynamicAnimator(referenceView: self)
            let gravity = UIGravityBehavior(items: [apple])
            let collision = UICollisionBehavior(items: [apple])
            collision.addBoundary(withIdentifier:"textView" as NSCopying , for: UIBezierPath(rect: wall.frame))
            collision.translatesReferenceBoundsIntoBoundary = true
            
            gravities.append(gravity)
            collisions.append(collision)
            animators.append(animator)
        }
        var delay = 1.0
        
        for i in 0..<apples.count {
            Timer.scheduledTimer(withTimeInterval: 3 * delay, repeats: false) { (timer) in
                self.animators[i].addBehavior(self.gravities[i])
                self.animators[i].addBehavior(self.collisions[i])
            }
            delay += 1
            
        }
        
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
        
    }
    
    

}
*/
