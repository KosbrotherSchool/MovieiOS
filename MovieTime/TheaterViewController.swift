//
//  TheaterViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/13/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class TheaterViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    var areas = [Area]()
    
    let pickerView = UIPickerView()
    var pickOption1 = ["08:00", "09:00", "10:00", "11:00", "12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00","00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00"]
    var pickOption2 = ["台北東區", "台北東區", "台北東區", "台北東區", "台北東區", "台北東區", "台北東區"]
    var pickOption3 = ["國賓影城微風廣場", "國賓影城微風廣場", "國賓影城微風廣場", "國賓影城微風廣場", "國賓影城微風廣場", "國賓影城微風廣場", "國賓影城微風廣場", "國賓影城微風廣場", "國賓影城微風廣場"]
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pickerTextField: NoCursorTextField!
    
    override func viewDidLoad() {
        areas = Area.getAreas()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1) // button color
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPicker")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        pickerTextField.inputAccessoryView = toolBar
        pickerTextField.inputView = pickerView

    }
    
    
    // MARK Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AreaTheaterSegue" {
            let areaTheaterViewController = segue.destinationViewController as! AreaTheaterViewController
            if let selecteCell = sender as? AreaCell {
                let indexPath = collectionView.indexPathForCell(selecteCell)!
                let selectedArea = areas[indexPath.row]
                areaTheaterViewController.area_id = selectedArea.area_id!
            }
            
        }
    }
    
    
    // MARK spacing of collectionview
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let cell_width = (collectionView.frame.size.width-20)/3
            let cell_height = cell_width
            return CGSize(width: cell_width, height: cell_height)
            
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    
    // Mark Collection Data
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return areas.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AreaCell", forIndexPath: indexPath) as! AreaCell
        let area = areas[indexPath.row]
        cell.areaLabel.text = area.name
    
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
            return pickOption3.count
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
            self.pick_row_2 = row
        case 2:
            self.pick_row_3 = row
        default:
            break
        }
        pickerTextField.text = self.pickOption1[pick_row_1]+" "+self.pickOption2[pick_row_2]+" "+self.pickOption3[pick_row_3]
    }
    
    func donePicker(){
        print("Done Picker")
        pickerTextField.endEditing(true)
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
            pickerLabel.text = pickOption2[row]
        case 2:
            pickerLabel.text = pickOption3[row]
        default:
            break
        }
        pickerLabel.font = UIFont.systemFontOfSize(15)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
}
