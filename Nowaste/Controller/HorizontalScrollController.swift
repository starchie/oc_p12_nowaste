//
//  DetailController.swift
//  Testing
//
//  Created by Gilles Sagot on 23/10/2021.
//

import UIKit

class HorizontalScrollController: UIViewController {
    
    var backgroundView = UIImageView()
    var dynamicView:DynamicView!
    var listView: UIScrollView!
    
    var detailview: DetailView!
    
    var backButton: UIButton!
    var profileButton: UIButton!
    var stars: StarView!
    
    var topBarHeight:CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let frameWindow = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let frameNavigationBar = self.navigationController?.navigationBar.frame.height ?? 0
        return frameWindow + frameNavigationBar
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor =  UIColor(red: 85/255,green: 85/255,blue: 192/255,alpha: 1.0)
        navigationController?.navigationBar.tintColor =  UIColor(red: 85/255,green: 85/255,blue: 192/255,alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        // BACKGROUND (COPY OF PREVIOUS CONTROLLER)
        view.addSubview(backgroundView)
        
        // VIEW
        let width: CGFloat = view.frame.width
        let height: CGFloat = view.frame.height - topBarHeight - 200
        
        dynamicView = DynamicView(frame: CGRect(x: 0, y: 200, width: width, height: height) )
        dynamicView.alpha = 0.8
       
        view.addSubview(dynamicView)
        
        // DETAILVIEW
        detailview = DetailView(frame: view.frame)
        self.view.addSubview(detailview)
        detailview.isHidden = true

    
        // LIST
        listView = UIScrollView()
        listView.isPagingEnabled = true
        listView.frame = CGRect(x: 0,
                                y: (view.frame.maxY - topBarHeight) - 150,
                                width: width,
                                height: 130)
        //listView.backgroundColor = .blue
        view.addSubview(self.listView)
        
        // CREATE LIST SUBVIEWS
        if listView.subviews.count < FirebaseService.shared.ads.count {
            while let view = listView.viewWithTag(0) {
                view.tag = 1000
            }
            setupList()
        }
        
        // BACK BUTTON
        backButton = UIButton()
        self.view.addSubview(backButton)
        backButton.setBackgroundImage(UIImage(systemName: "arrowtriangle.down.circle.fill"), for: .normal)
        backButton.tintColor = .black
        backButton.frame = CGRect(x: view.frame.midX - 10,
                                  y: (view.frame.maxY - topBarHeight) - 150 - 20,
                                  width: 20,
                                  height: 20)
        
        backButton.addTarget(self, action:#selector(backFunction), for: .touchUpInside)
        
        
        // PROFILE BUTTON
        profileButton = UIButton()
        view.addSubview(profileButton)
        profileButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        //profileButton.addTarget(self, action:#selector(searchFunction), for: .touchUpInside)
        profileButton.tintColor = .darkGray
        profileButton.frame = CGRect(x: view.frame.midX - 20,
                                     y: view.frame.maxY -  topBarHeight - 40 - 20,
                                     width: 40,
                                     height: 40)
        // STAR
        stars = StarView(frame: CGRect(x: view.frame.midX - 37.5, y: profileButton.frame.minY - 15, width: 75, height: 30))
        view.addSubview(stars)

    }
    
    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: - ACTIONS
    
    @objc func backFunction() {
        
        if backButton.center.y < self.view.center.y {
            detailview.isHidden = true
            dynamicView.animReversse()
            listView.isHidden = false
            backButton.frame = CGRect(x: view.frame.midX - 10,
                                      y: (view.frame.maxY - topBarHeight) - 150 - 20,
                                      width: 20,
                                      height: 20)
            
        }else {
            navigationController?.popViewController(animated: false)
        }

        
      
        
    }
    
    @objc func didTapImageView(_ tap: UITapGestureRecognizer) {
        let index = tap.view!.tag
        let selectedItem = FirebaseService.shared.ads[index]
        detailview.isHidden = false
        detailview.itemTitle.text = selectedItem.title
        detailview.itemDescription.text = selectedItem.description
        detailview.countView.text = "+ " + String(selectedItem.likes)
        FirebaseService.shared.loadImage(selectedItem.imageURL) { success,error,image in
            if success {
                self.detailview.itemImage.image = UIImage(data: image!)
                
            }else {
                self.presentUIAlertController(title: "erreur", message: error!)
            }
            
        }
        backButton.center.y = 30 + 180
        dynamicView.animPlay()
        listView.isHidden = true
    }
    
    func getDate(dt: Double) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM YYYY - HH:mm"
        let result = dateFormatter.string(from: date)
        return result
    }
    
}

// MARK: - CONTROLLER EXTENSION SCROLL LIST

extension HorizontalScrollController{
    
    // PREPARE VIEWS
    
    func setupList() {
        
        for i in FirebaseService.shared.ads.indices {
            
            // CREATE VIEW
            let scrollView = HorizontalScrollView(frame: listView.bounds)
            let ad = FirebaseService.shared.ads[i]
            scrollView.itemTitle.text = ad.title
            scrollView.itemDate.text = getDate(dt:ad.dateField)
            scrollView.tag = i
            scrollView.contentMode = .scaleAspectFill
            scrollView.isUserInteractionEnabled = true
            scrollView.layer.cornerRadius = 0
            scrollView.layer.masksToBounds = true
            listView.addSubview(scrollView)
            
            scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView)))
        }
        
        listView.backgroundColor = UIColor.clear
        positionListItems()
    }
    
    // VIEWS POSITION IN LIST
    
    func positionListItems() {
        let listHeight = listView.frame.height
        let itemHeight: CGFloat = listHeight - 40
        let itemWidth: CGFloat = view.frame.width - 40
        
        let horizontalPadding: CGFloat = 40
        
        for i in FirebaseService.shared.ads.indices {
            let imageView = listView.viewWithTag(i) as! HorizontalScrollView
            imageView.frame = CGRect(
                x: CGFloat(i) * itemWidth + CGFloat(i+1) * horizontalPadding - 20,
                y: 0.0,
                width: itemWidth,
                height: itemHeight)
        }
        
        listView.contentSize = CGSize(width: CGFloat(FirebaseService.shared.ads.count) * (itemWidth + horizontalPadding) + horizontalPadding, height:  0)
        
    }
    
}
