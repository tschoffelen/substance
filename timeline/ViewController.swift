//
//  ViewController.swift
//
//  Created by Thomas Schoffelen on 21/09/2019.
//  Copyright © 2019 Schof.co. All rights reserved.
//

import UIKit
import RealmSwift
import RxRealm
import RxSwift

class ViewController: UITableViewController {

    var items = [TimelineItem]()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 10))
        self.tableView.estimatedRowHeight = 80

        let items = Util.realm
            .objects(TimelineItem.self)
            .sorted(byKeyPath: "createdAt", ascending: false)

        Observable.array(from: items).subscribe(onNext: { (items) in
            self.items = items.filter { !$0.isDeleted }
            self.tableView.reloadData()
        }).disposed(by: bag)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let detailViewController = self.mainStoryboard?.instantiateViewController(
        //     withIdentifier: "ArtistViewController") as! ArtistViewController
        // detailViewController.setArtist(
        //     self.searchActive ? self.filteredArtists[indexPath.row] : self.artists[indexPath.row])
        // self.navigationController?.pushViewController(detailViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! Util.realm.write {
                self.items[indexPath.row].isDeleted = true
            }
        } else {
            NSLog("Unhandled editingStyle")
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath)
            as? ItemTableViewCell {
            if self.items.count > indexPath.row {
                cell.setup(item: self.items[indexPath.row])
            }

            return cell
        }

        return UITableViewCell()
    }

}
