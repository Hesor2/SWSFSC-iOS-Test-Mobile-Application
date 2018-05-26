import UIKit

class SeasonsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var seasonsTable: UITableView!
    
    var seasons = [Season]()
    
    var editingMode = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //seasonsTable.rowHeight = UITableViewAutomaticDimension
        //seasonsTable.estimatedRowHeight = 80
        //seasonsTable.estimatedRowHeight = 180
        getSeasons()
    }
    
    func getSeasons()
    {
        API.Seasons.getAll(completion: {
            (seasons, error) in
            if error == nil
            {
                self.seasons = seasons!
                self.seasonsTable.reloadData()
            }
            else
            {
                self.presentErrorAlert(error: error)
            }
        })
    }
    
    //tableview
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return seasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:SeasonCell = tableView.dequeueReusableCell(withIdentifier: "seasonCell") as! SeasonCell
        
        //cell.textLabel?.text = seasons[indexPath.row].name
        cell.setContent(season: seasons[indexPath.row])
        //cell.nameLabel.text = seasons[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let index = indexPath.row
        var season : Season
        season = seasons[index]
        //performSegue(withIdentifier: "showCompetitions", sender: season)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
    
    /*
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowAllergy"
        {
            if let destination = segue.destination as? AllergyViewController
            {
                if let allergy = sender as? Allergy
                {
                    destination.allergy = allergy
                }
            }
        }
    }*/
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
