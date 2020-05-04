//
//  DatePickerViewController.swift
//  CatchUp
//
//  Created by aplome on 23/08/2017.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit
import FSCalendar

protocol DatePickerViewDelegate {
    
    func datePickerView(_ datePickerView: DatePickerViewController, selectedDate date:Date?, stringDate: String?)
}

class DatePickerViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {

    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var btnSelect: UIButton!
    
    var delegate: DatePickerViewDelegate!
    
    
    fileprivate var selectedDate: Date = Date()
    fileprivate var calendar: FSCalendar!
    
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        let width = (self.view.frame.size.width * 0.9) - 2
        
        let frame: CGRect = CGRect(x: 1, y: 1, width: width, height: width)
        
        let calendar: FSCalendar = FSCalendar(frame: frame)
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = false
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.backgroundColor = UIColor.white
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        
        calendar.appearance.headerTitleColor = constants.getThemeTextColor()
        calendar.appearance.weekdayTextColor = constants.getThemeTextColor()
        calendar.appearance.selectionColor = constants.getThemeTextColor()
        calendar.firstWeekday = 2
        
        calendar.setCornerRadius()
        self.calendarView.setCornerRadius()
        self.bottomView.setCornerRadius()
        
        self.calendarView.backgroundColor = UIColor.white
        
        self.calendarView.addSubview(calendar)
        self.calendar = calendar
        calendar.select(Date())
        
        self.selectedDate = Date()
        self.btnSelect.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.0) {
            
            self.calendarView.alpha = 1.0;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func didTodayButtonPressed(_ sender: UIButton) {
    
        self.selectedDate = Date()
        self.setSelectedDateFromCalendar()
    }
    
    @IBAction func didSelectButtonPressed(_ sender: UIButton) {
    
        self.setSelectedDateFromCalendar()
    }
    
    private func setSelectedDateFromCalendar() {
    
        if let delegate = self.delegate {
            
            let stringDate: String = self.selectedDate.toString()
            
            delegate.datePickerView(self, selectedDate: Date(), stringDate: stringDate)
        }
        
        UIView.animate(withDuration: 0.3) { 
            
            self.calendarView.alpha = 0.0;
        }
        
        self.dismiss(animated: true) { 
            
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        self.selectedDate = date
        self.btnSelect.isHidden = false
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
