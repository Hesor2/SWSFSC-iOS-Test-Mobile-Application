//
//  SeasonViewController.swift
//  SWSFSC Mobile Application
//
//  Created by Flemming Eriksen on 03/06/2018.
//  Copyright © 2018 Flemming Eriksen. All rights reserved.
//

import UIKit

class SeasonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var highscoreTable: UITableView!
    @IBOutlet var competitionTable: UITableView!
    
    
    var season : Season?
    var highscore = [UserScore]()
    var competitions = [Competition]()
    //var competitions = [Competition]()
    
    func getContent()
    {
        if let season = season
        {
            API.Seasons.getHighscore(season: season, page: 1)
            {
                (highscore, error) in
                if error == nil
                {
                    self.highscore = highscore!
                    self.highscoreTable.reloadData()
                }
            }
            API.Seasons.getCompetitions(season: season, page: 1)
            {
                (competitions, error) in
                self.competitions = competitions!
                self.competitionTable.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 0
        {
            return highscore.count
        }
        else
        {
            return competitions.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView.tag == 0
        {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "scoreCell")!
            cell.textLabel?.text = String(highscore[indexPath.row].score)
            return cell
        }
        else
        {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "competitionCell")!
            cell.textLabel?.text = String(competitions[indexPath.row].name)
            return cell
        }
        
    }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        getContent()
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
