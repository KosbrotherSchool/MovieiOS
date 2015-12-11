//
//  TheaterViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/13/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import SwiftyJSON
import JLToast

class TheaterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    enum defaultsKeys {
        static let keyAreaPick = "keyAreaPick"
        static let keyTheaterPick = "keyTheaterPick"
    }
    
    let pickerView = UIPickerView()
    var pickOption1 = ["08：00", "09：00", "10：00", "11：00", "12：00","13：00","14：00","15：00","16：00","17：00","18：00","19:00","20：00","21：00","22：00","23：00","00：00","01：00","02：00","03：00","04：00","05：00","06：00","07：00"]
    var pickOption2 = Area.getAreas()
    var pickOption3:[Theater]!
    
    var movieTimes = [MovieTime]()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
  
    @IBOutlet weak var pickerTextField: NoCursorTextField!
    @IBOutlet weak var quickSearchView: UIView!
    @IBOutlet weak var areaCollectionView: AreaCollectionView!
    @IBOutlet weak var quickTimeCollectionView: UICollectionView!
    
    
    @IBAction func switchSeg(sender: UISegmentedControl) {
        self.resetViewBySegmentControl()
    }
    
    func resetViewBySegmentControl(){
        switch segmentControl.selectedSegmentIndex{
        case 0:
            areaCollectionView.hidden = false
            quickSearchView.hidden = true
        case 1:
            areaCollectionView.hidden = true
            quickSearchView.hidden = false
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        quickSearchView.hidden = true
        
        areaCollectionView.delegate = areaCollectionView.self
        areaCollectionView.dataSource = areaCollectionView.self
        
        quickTimeCollectionView.delegate = self
        quickTimeCollectionView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "確定", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPicker")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        pickerTextField.inputAccessoryView = toolBar
        pickerTextField.inputView = pickerView
        
        // restore pick
        let defaults = NSUserDefaults.standardUserDefaults()
        pick_row_2 = defaults.integerForKey(defaultsKeys.keyAreaPick)
        pick_row_3 = defaults.integerForKey(defaultsKeys.keyTheaterPick)
        
        self.pickOption3 = Theater.getTheaters(self.pickOption2[pick_row_2].area_id!)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        
        if hour >= 8{
            pick_row_1 = hour - 8
        }else{
            pick_row_1 = hour + 16
        }
        
        self.pickerView.selectRow(pick_row_1, inComponent: 0, animated: true)
        self.pickerView.selectRow(pick_row_2, inComponent: 1, animated: true)
        self.pickerView.selectRow(pick_row_3, inComponent: 2, animated: true)
        
        if self.pick_row_3 == 0{
            pickerTextField.text = self.pickOption1[pick_row_1]+" "+self.pickOption2[pick_row_2].name!+" 全部戲院"
        }else{
            pickerTextField.text = self.pickOption1[pick_row_1]+" "+self.pickOption2[pick_row_2].name!+" "+self.pickOption3[pick_row_3-1].name!
        }
        
        let index2 = self.pickOption1[self.pick_row_1].startIndex.advancedBy(2)
        let timeString = self.pickOption1[self.pick_row_1].substringToIndex(index2)
        
        let area_id = self.pickOption2[self.pick_row_2].area_id!
        var theater_id:Int!
        if self.pick_row_3 == 0{
            theater_id = 0
        }else{
            theater_id = self.pickOption3[self.pick_row_3-1].theater_id!
        }
        self.getMovieTimesByTime(timeString, area_id: area_id, theater_id: theater_id)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        self.quickTimeCollectionView.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        self.areaCollectionView.addGestureRecognizer(swipeLeft)
        
    }
    
    func swipedRight(sender:UIGestureRecognizer){
        let currentIndex = segmentControl.selectedSegmentIndex
        if currentIndex > 0{
            segmentControl.selectedSegmentIndex = currentIndex - 1
        }
        self.resetViewBySegmentControl()
    }
    
    func swipedLeft(sender:UIGestureRecognizer){
        let currentIndex = segmentControl.selectedSegmentIndex
        if currentIndex < 1{
            segmentControl.selectedSegmentIndex = currentIndex + 1
        }
        self.resetViewBySegmentControl()
    }
    
    // MARK Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AreaTheaterSegue" {
            let areaTheaterViewController = segue.destinationViewController as! AreaTheaterViewController
            if let selecteCell = sender as? AreaCell {
                let indexPath = areaCollectionView.indexPathForCell(selecteCell)!
                let selectedArea = self.areaCollectionView.areas[indexPath.row]
                areaTheaterViewController.area_id = selectedArea.area_id!
            }
            
        }
        
        if segue.identifier == "QuickTimeMovieSegue"{
            
            let movieDetailViewController = segue.destinationViewController as! MovieDetailViewController
            if let selectedTimeCell = sender as? QuickTimeCell {
                let indexPath = quickTimeCollectionView.indexPathForCell(selectedTimeCell)!
                let movieTime = movieTimes[indexPath.row]
                let movie = Movie.init(movie_id: movieTime.movie_id!, title: movieTime.movie_title!, small_pic: "", large_pic: "", points: 0.0, review_size: 0, publish_date: "")
                movieDetailViewController.theMovie = movie
            }
        
        }
    }
    
    
    // MARK collection view
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let cell_width = collectionView.frame.size.width-16
            return CGSize(width: cell_width, height: 60)
            
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    
    
    // Mark Collection Data
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieTimes.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("QuickTimeCell", forIndexPath: indexPath) as! QuickTimeCell
        let movieTime = movieTimes[indexPath.row]
        cell.theaterLabel.text = Theater.getTheaterByID(movieTime.theater_id!)?.name!
        cell.movieLabel.text = movieTime.movie_title!
        cell.timeLabel.text = movieTime.the_time
        
        return cell
    }
    
    // MARK picker view
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component{
        case 0:
            return pickOption1.count
        case 1:
            return pickOption2.count
        case 2:
            return pickOption3.count + 1
        default:
            return 0
        }
    }
    
    var pick_row_1 = 0
    var pick_row_2 = 0
    var pick_row_3 = 0
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component{
        case 0:
            self.pick_row_1 = row
        case 1:
            if self.pick_row_2 != row{
                self.pick_row_2 = row
                // change pickOption3
                self.pickOption3 = Theater.getTheaters(self.pickOption2[row].area_id!)
                self.pick_row_3 = 0
                self.pickerView.reloadComponent(2)
                self.pickerView.selectRow(0, inComponent: 2, animated: true)
            }
        case 2:
            self.pick_row_3 = row
        default:
            break
        }
        if self.pick_row_3 == 0{
            pickerTextField.text = self.pickOption1[pick_row_1]+" "+self.pickOption2[pick_row_2].name!+" 全部戲院"
        }else{
            pickerTextField.text = self.pickOption1[pick_row_1]+" "+self.pickOption2[pick_row_2].name!+" "+self.pickOption3[pick_row_3-1].name!
        }
        
    }
    
    func donePicker(){
        print("Done Picker")
        pickerTextField.endEditing(true)
        // Mark get movie times
        movieTimes.removeAll()
        quickTimeCollectionView.reloadData()
        
        let index2 = self.pickOption1[self.pick_row_1].startIndex.advancedBy(2)
        let timeString = self.pickOption1[self.pick_row_1].substringToIndex(index2)
        
        let area_id = self.pickOption2[self.pick_row_2].area_id!
        var theater_id:Int!
        if self.pick_row_3 == 0{
           theater_id = 0
        }else{
            theater_id = self.pickOption3[self.pick_row_3-1].theater_id!
        }
        self.getMovieTimesByTime(timeString, area_id: area_id, theater_id: theater_id)
        
        
        // Save Pick Row Position
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(pick_row_2, forKey: defaultsKeys.keyAreaPick)
        defaults.setValue(pick_row_3, forKey: defaultsKeys.keyTheaterPick)
        defaults.synchronize()
    }
    
    func cancelPicker(){
        print("Cancel Picker")
        pickerTextField.endEditing(true)
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        
        switch component{
        case 0:
            pickerLabel.text = pickOption1[row]
        case 1:
            pickerLabel.text = pickOption2[row].name!
        case 2:
            if row == 0{
                 pickerLabel.text = "全部戲院"
            }else{
                pickerLabel.text = pickOption3[row-1].name!
            }
        default:
            break
        }
        pickerLabel.font = UIFont.systemFontOfSize(15)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    let host = "http://139.162.10.76"
    
    // query_hour is like "08" or "12"
    func getMovieTimesByTime(query_hour: String,area_id: Int, theater_id: Int)
    {
        if !Reachability.isConnectedToNetwork(){
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.movieTimes.removeAll()
        
        var url:NSURL!
        if( theater_id != 0){
            url = NSURL(string: host+"/api/movie/movie_by_time?time="+query_hour+":"+"&area_id="+String(area_id)+"&theater_id="+String(theater_id))
        }else{
            url = NSURL(string: host+"/api/movie/movie_by_time?time=" + query_hour+":" + "&area_id=" + String(area_id) )
        }
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            // Do Something after got data
            let jsonData = JSON(data: data!)
            
            var times_array = [MovieTime]()
            for movie in jsonData.arrayValue{
                let remark = movie["remark"].stringValue
                let movie_title = movie["movie_title"].stringValue
                let movie_time = movie["movie_time"].stringValue
                let movie_id = movie["movie_id"].int!
                let theater_id = movie["theater_id"].int!
                let movie_photo = movie["movie_photo"].stringValue
                
                let index3 = self.pickOption1[self.pick_row_1].startIndex.advancedBy(3)
                let timeString = self.pickOption1[self.pick_row_1].substringToIndex(index3)
                let range = movie_time.rangeOfString(timeString)
                let the_time = movie_time[range!.startIndex...range!.endIndex.advancedBy(1)]
                
                let newMovieTime = MovieTime.init(remark: remark, movie_title: movie_title, movie_time: movie_time, movie_id: movie_id, theater_id: theater_id, movie_photo: movie_photo,the_time: the_time)
                // add BlogPost to blogPosts
                times_array.append(newMovieTime)
            }
            
            self.movieTimes = times_array.sort({ (time1, time2) -> Bool in
                time1.the_time < time2.the_time
            })
            
            // update UI
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.quickTimeCollectionView.reloadData()
                    
                }
                
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
        
        task.resume()
        print(NSDate())
    }

    func tint(image: UIImage, color: UIColor) -> UIImage
    {
        let ciImage = CIImage(image: image)
        let filter = CIFilter(name: "CIMultiplyCompositing")!
        
        let colorFilter = CIFilter(name: "CIConstantColorGenerator")!
        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage
        
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(ciImage, forKey: kCIInputBackgroundImageKey)
        
        return UIImage(CIImage: filter.outputImage!)
    }
}
