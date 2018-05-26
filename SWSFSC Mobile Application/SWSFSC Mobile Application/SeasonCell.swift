import UIKit
class SeasonCell: UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    
    func setContent(season: Season)
    {
        nameLabel.text = season.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        startLabel.text = dateFormatter.string(from:season.start_date)
        endLabel.text = dateFormatter.string(from:season.end_date)
    }
}
