//
//  MasterView.swift
//  SampleDemo
//
//  Created by ispl Mac Mini on 8/11/17.
//  Copyright © 2017 infinium. All rights reserved.
//

import UIKit

class MasterView: UIViewController {

    @IBOutlet var tblView: UITableView!
    
    var discFinalData:NSMutableDictionary!
    var arrSection:NSArray!
    
    var selectionIndex:Int=0
    var rowIndex:Int=0
    
    //Mark:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        discFinalData=NSMutableDictionary()
        arrSection=discFinalData.allKeys as NSArray
        
//        let discData=UserDefaults.standard.object(forKey: "finalData") as! NSMutableDictionary
//        discFinalData=[arrSection[0]:discData.object(forKey: arrSection[0]) as! NSArray,arrSection[1]:discData.object(forKey: arrSection[1]) as! NSArray,arrSection[2]:discData.object(forKey: arrSection[2]) as! NSArray,arrSection[3]:discData.object(forKey: arrSection[3]) as! NSArray,arrSection[4]:discData.object(forKey: arrSection[4]) as! NSArray]
        
        print(discFinalData)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK : Button Tap
    @IBAction func btnAddTap(_ sender: UIButton) {
        selectionIndex=sender.tag
        
        let detailView=self.storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailView
        detailView.fierDelegate=self
        detailView.whichTask=false
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    @IBAction func btnAddSectionTap(_ sender: UIBarButtonItem) {
        let sectionView=self.storyboard?.instantiateViewController(withIdentifier: "SectionView") as! SectionView
        sectionView.fierDelegate=self
        self.navigationController?.pushViewController(sectionView, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MasterView:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr=discFinalData.object(forKey: arrSection[section]) as! NSArray
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MasterViewCell
        
        cell.lblName.text=((discFinalData.object(forKey: arrSection[indexPath.section]) as! NSArray).object(at: indexPath.row) as! NSArray).object(at: 0) as? String
        cell.lblCity.text=((discFinalData.object(forKey: arrSection[indexPath.section]) as! NSArray).object(at: indexPath.row) as! NSArray).object(at: 1) as? String
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let arrLast:NSMutableArray = NSMutableArray(array: discFinalData.object(forKey: arrSection[indexPath.section]) as! NSArray)
            arrLast.removeObject(at: indexPath.row)
            
            discFinalData.setValue(arrLast, forKey: arrSection.object(at: indexPath.section) as! String)
            
            UserDefaults.standard.set(discFinalData, forKey: "finalData")
            UserDefaults.standard.synchronize()
            
            tblView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate
extension MasterView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "headerView")!
        
        let lblTitle=headerView.viewWithTag(1) as! UILabel
        lblTitle.text=arrSection.object(at: section) as? String
        
        let btnAdd=headerView.viewWithTag(2) as! UIButton
        btnAdd.tag=section
        btnAdd.addTarget(self, action: #selector(MasterView.btnAddTap(_:)), for: .touchUpInside)
        
        return headerView.contentView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionIndex=indexPath.section
        rowIndex=indexPath.row
        
        let detailView=self.storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailView
        detailView.fierDelegate=self
        detailView.whichTask=true
        detailView.arrData=((discFinalData.object(forKey: arrSection[indexPath.section]) as! NSArray).object(at: indexPath.row)) as! NSArray
        
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
}

// MARK: - other Delegate
extension MasterView:DetailViewDelegate{
    func backDelegate(_ controler :DetailView)
    {
        let arrLast:NSMutableArray = NSMutableArray(array: discFinalData.object(forKey: arrSection[selectionIndex]) as! NSArray)
        if controler.whichTask
        {
            arrLast.removeObject(at: rowIndex)
            arrLast.insert([controler.txtName.text,controler.txtCity.text], at: rowIndex)
        }
        else
        {
            arrLast.add([controler.txtName.text,controler.txtCity.text])
        }
        
        discFinalData.setValue(arrLast, forKey: arrSection.object(at: selectionIndex) as! String)
        
        UserDefaults.standard.set(discFinalData, forKey: "finalData")
        UserDefaults.standard.synchronize()
        
        print(discFinalData)
        
        tblView.reloadData()
    }
}

extension MasterView:SectionViewDelegate{
    func backSectionDelegate(_ controler :SectionView)
    {
        discFinalData.setValue([], forKey: controler.txtName.text!)
        //arrSection=discFinalData.allKeys as NSArray
        arrSection=(discFinalData.allKeys as! [String]).sorted(by: <) as NSArray
        
        tblView.reloadData()
    }
}
