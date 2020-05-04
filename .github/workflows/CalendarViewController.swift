//
//  CalendarViewController.swift
//  CatchUp
//
//  Created by Macbook on 12/27/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit
import FSCalendar


class CalendarViewController: UIViewController , FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, SWRevealViewControllerDelegate {
    
    fileprivate weak var calendar: FSCalendar!
    
    
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter
    }()
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.calendar.isUserInteractionEnabled = true
    }

//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
////        self.calendar.isUserInteractionEnabled = false
//    }

    
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.groupTableViewBackground
        self.view = view
        
        let height: CGFloat = 400
        let calendar = FSCalendar(frame: CGRect(x:0, y:65, width:self.view.frame.size.width, height:height))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.backgroundColor = UIColor.white
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        calendar.appearance.headerTitleColor = constants.getThemeTextColor()
        calendar.appearance.weekdayTextColor = constants.getThemeTextColor()
        calendar.appearance.selectionColor = constants.getThemeTextColor()
        calendar.firstWeekday = 2
        self.view.addSubview(calendar)
        self.calendar = calendar
        calendar.select(Date())
        //        calendar.select(self.dateFormatter1.date(from: "2015/10/03"))
        let todayItem = UIBarButtonItem(title: "TODAY", style: .plain, target: self, action: #selector(self.todayItemClicked(_:)))
        self.navigationItem.rightBarButtonItem = todayItem
    }
    
    
    @IBOutlet weak var menuButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //Side bar menu setting
        if self.revealViewController() != nil {
            menuButton.addTarget(self, action: #selector(menuClicked(_:)), for: .touchUpInside)

            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func menuClicked(_ sender: AnyObject) {
        self.calendar.isUserInteractionEnabled = false
        self.revealViewController().revealToggle(sender)
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    deinit {
        print("\(#function)")
    }
    
    /*
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {

        Log
//        if(position == ){
//            self.revealController.frontViewController.view.setUserInteractionEnabled = true
//          //  [revealController.frontViewController.revealViewController tapGestureRecognizer];
//        }else{
//            revealController.frontViewController.view setUserInteractionEnabled = true
//           // [revealController.frontViewController.view setUserInteractionEnabled:NO];
//        }
    }
 */
    
    
    
    @objc
    
    
    func todayItemClicked(_ sender: AnyObject) {
        self.calendar.setCurrentPage(Date(), animated: false)
        
        var today:Date = Date();
        let historyVC = self.storyboard?.instantiateViewController(withIdentifier: "historyVc") as! HistoryViewController
        historyVC.selected_Date = today.dateForEventDeta()
        historyVC.isFromCalender = true
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let historyVC = self.storyboard?.instantiateViewController(withIdentifier: "historyVc") as! HistoryViewController
        historyVC.selected_Date = date.dateForEventDeta()
        historyVC.isFromCalender = true
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        var count = 0
        for var e:Event in appdelegate.eventsListArray{
            
          //  let thisString = self.dateFormatter2.string(from: date)
           // self.dateFormatter2.dateFormat
            
            print(e.event_date)
            print(self.dateFormatter2.string(from: date))
            
            if(e.event_date == self.dateFormatter2.string(from: date)){
                count += 1
            }
            
           // e.event_date
        }
        
        return count
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        //        let dateString = self.dateFormatter2.string(from: date)
        //        if self.datesWithEvent.contains(dateString) {
        //            return UIColor.purple
        //        }
        return UIColor.purple
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        //        let key = self.dateFormatter2.string(from: date)
        //        if self.datesWithMultipleEvents.contains(key) {
        
        //        }
        return [UIColor.magenta, appearance.eventDefaultColor, UIColor.black]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        //        let key = self.dateFormatter1.string(from: date)
        //        if let color = self.fillDefaultColors[key] {
        //            return color
        //        }
        return appearance.selectionColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        //        let key = self.dateFormatter1.string(from: date)
        //        if let color = self.fillDefaultColors[key] {
        //            return color
        //        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        //        let key = self.dateFormatter1.string(from: date)
        //        if let color = self.borderDefaultColors[key] {
        //            return color
        //        }
        return appearance.borderDefaultColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        //        let key = self.dateFormatter1.string(from: date)
        //        if let color = self.borderSelectionColors[key] {
        //            return color
        //        }
        return appearance.borderSelectionColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        //        if [8, 17, 21, 25].contains((self.gregorian.component(.day, from: date))) {
        //            return 0.0
        //        }
        return 10.0
    }

    
}
