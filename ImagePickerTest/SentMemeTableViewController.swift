import Foundation
import UIKit

class SentMemeTableViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send Meme", style: .plain, target: self, action: #selector(sendNew))
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    @objc func sendNew() {
        let newMemeVC = storyboard?.instantiateViewController(withIdentifier: "NewMemeViewController")as! NewMemeViewController
        self.navigationController?.pushViewController(newMemeVC, animated:true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")!
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.top
        cell.detailTextLabel?.text = meme.bottom
        
        return cell
    }
}
