//
//  DiaryTableViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/06/21.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class DiaryTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var content = Content.findAllWithSort()
    var selectedContent: Content?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title =  "日記"
        tableView.delegate = self
        tableView.dataSource = self
        //Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        content = Content.findAllWithSort()
        self.tableView.register(UINib(nibName: "DiaryCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.separatorStyle = .none
        tableView.reloadData()
        print(content, content.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DiaryCell
        cell.dateLabel.text = content[indexPath.row].date
        let redValue: CGFloat = CGFloat(content[indexPath.row].redValue)
        let greenValue: CGFloat = CGFloat(content[indexPath.row].greenValue)
        let blueValue: CGFloat = CGFloat(content[indexPath.row].blueValue)
        cell.BGView.backgroundColor = UIColor(red: redValue / 255, green: greenValue / 255, blue: blueValue / 255, alpha:1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedContent = content[indexPath.row]
        self.performSegue(withIdentifier: "toVC", sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC = segue.destination as! DetailViewController
        VC.content = selectedContent
    }

}
