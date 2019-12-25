//
//  AddItemViewController.swift
//
//  Created by Thomas Schoffelen on 21/09/2019.
//  Copyright © 2019 Schof.co. All rights reserved.
//

import UIKit
import Contacts
import RealmSwift

class AddItemViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {

    @IBOutlet var bodyLabel: UITextView?

    @IBOutlet var saveButton: UIBarButtonItem?

    @IBOutlet var collectionView: UICollectionView?

    @IBOutlet var tagsConstraint: NSLayoutConstraint?

    var activities: [Activity] = []

    var replacementInstance = ""
    var tagsMode = ""
    var tagsShown = true
    var keyboardHeight: CGFloat = 329

    var tagsHeight: CGFloat = 144

    var mainActivity = Activity()

    static var defaultTagsByUsage = [Activity]()

    static var contactsCache = [String: CNContact]()

    static var contactStore = CNContactStore()

    static var personsByUsage = [Activity]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.bodyLabel?.textContainerInset = UIEdgeInsets(top: 34, left: 28, bottom: 34, right: 28)

        self.bodyLabel?.delegate = self

        self.tagsConstraint?.constant = tagsHeight

        if AddItemViewController.contactsCache.count == 0 {
            self.loadContacts()
        }

        if AddItemViewController.defaultTagsByUsage.count == 0 {
            self.loadTags()
        }

        self.activities = self.getDefaultActivities()
        self.activities += AddItemViewController.defaultTagsByUsage.enumerated().compactMap {
            $0.offset < 24 ? $0.element : nil
        }
        self.activities += AddItemViewController.personsByUsage.enumerated().compactMap {
            $0.offset < 24 ? $0.element : nil
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }

    func getDefaultActivities() -> [Activity] {
        let noteAct = Activity()
        noteAct.color = UIColor.systemGreen
        noteAct.title = "Note"
        noteAct.type = "note"
        noteAct.icon = "doc.fill"
        mainActivity = noteAct

        let todoAct = Activity()
        todoAct.color = UIColor.systemYellow
        todoAct.title = "Todo"
        todoAct.type = "todo"
        todoAct.icon = "star.fill"

        let ideaAct = Activity()
        ideaAct.color = UIColor.systemOrange
        ideaAct.title = "Idea"
        ideaAct.type = "idea"
        ideaAct.icon = "lightbulb.fill"

        let cigAct = Activity()
        cigAct.color = UIColor.systemBlue
        cigAct.type = "cig"
        cigAct.title = "Cigarette"
        cigAct.icon = "staroflife.fill"
        cigAct.body = "Smoked a cigarette"

        let weedAct = Activity()
        weedAct.color = UIColor.systemBlue
        weedAct.type = "weed"
        weedAct.title = "Weed"
        weedAct.icon = "staroflife.fill"
        weedAct.body = "Smoked a joint"

        return [noteAct, todoAct, ideaAct, cigAct, weedAct]
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
        }
    }

    func loadTags() {
       // let tags : [Activity: Int] = ["#idea": 0, "#todo": 0, "#lookup": 0, "#important": 0]

        // TODO: store used tags in separate Realm table!
//        for (item) in API.get() {
//            if item.entities == nil {
//                continue
//            }
//            for entity in item.entities! {
//                if let entityDict = entity as? [String: Any?] {
//                    if let entityType = entityDict["type"] as? String,
//                        let entityBody = entityDict["body"] as? String {
//                        if entityType == "tag", entityBody.count > 0 {
//                            if tags.keys.contains(entityBody) {
//                                tags[entityBody]! += 1
//                            } else {
//                                tags[entityBody] = 1
//                            }
//                        }
//                    }
//                }
//            }
//        }
//

        let ideaTag = Activity()
        ideaTag.text = "#idea"
        ideaTag.title = "idea"
        ideaTag.color = UIColor.systemGray
        ideaTag.icon = "tag"

        let conTag = Activity()
        conTag.text = "#concept"
        conTag.title = "concept"
        conTag.color = UIColor.systemGray
        conTag.icon = "tag"

        AddItemViewController.defaultTagsByUsage = [conTag, ideaTag]
    }

    func loadContacts() {
        self.requestForAccess { (accessGranted) -> Void in
            if !accessGranted {
                print("No contacts access granted")
                AddItemViewController.contactsCache = [:]
                return
            }

            let contactsStore = AddItemViewController.contactStore
            let keys = [
                CNContactGivenNameKey,
                CNContactFamilyNameKey,
                CNContactMiddleNameKey,
                CNContactImageDataKey
            ]

            var allContainers: [CNContainer] = []

            do {
                allContainers = try contactsStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }

            AddItemViewController.contactsCache = [:]
            var tags = [Activity: Int]()
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

                do {
                    let containerResults = try contactsStore.unifiedContacts(
                        matching: fetchPredicate, keysToFetch: keys as [CNKeyDescriptor])
                    for contact in containerResults {
                        let text = "@\(contact.givenName)\(contact.middleName)\(contact.familyName)"
                            .lowercased().replacingOccurrences(of: " ", with: "")
                        AddItemViewController.contactsCache[text] = contact
                        let activity = Activity()
                        activity.text = text
                        activity.title = "\(contact.givenName) \(contact.middleName) \(contact.familyName)"
                            .replacingOccurrences(of: "  ", with: " ")
                        activity.color = UIColor.systemGray
                        activity.icon = "person"
                        tags[activity] = 0
                    }
                } catch {
                    print("Error fetching results for container")
                }
            }

            // TODO: store entities in seperate Realm model
//            for item in API.get() {
//                if item.entities == nil {
//                    continue
//                }
//                for entity in item.entities! {
//                    if let entityDict = entity as? [String: Any?] {
//                        print(entityDict)
//                        if let entityType = entityDict["type"] as? String,
//                            let entityBody = entityDict["body"] as? String {
//                            if entityType == "person", entityBody.count > 0 {
//                                if tags.keys.contains(entityBody) {
//                                    tags[entityBody]! += 1
//                                } else {
//                                    tags[entityBody] = 1
//                                }
//                            }
//                        }
//                    }
//                }
//            }

            AddItemViewController.personsByUsage = tags.sorted(by: { (tag1, tag2) -> Bool in
                return tag2.value > tag1.value
            }).map({ (tag) -> Activity in
                return tag.key
            })
        }
    }

    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)

        switch authorizationStatus {
        case .authorized:
            completionHandler(true)

        case .denied, .notDetermined:
            AddItemViewController.contactStore.requestAccess(
                for: CNEntityType.contacts, completionHandler: { (access, _) -> Void in
                if access {
                    completionHandler(access)
                }
            })

        default:
            completionHandler(false)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.bodyLabel?.becomeFirstResponder()
    }

    @IBAction func saveItem() {
        if self.bodyLabel!.text.count < 1 {
            self.dismiss(animated: true)
            return
        }

        self.saveButton?.isEnabled = false

        let item = TimelineItem()
        item.body = self.bodyLabel!.text
        item.type = self.mainActivity.type!
        item.color = self.mainActivity.color
        item.title = self.mainActivity.title!
        item.icon = self.mainActivity.icon

        try! Util.realm.write {
            Util.realm.add(item)
        }

        self.dismiss(animated: true)
        self.saveButton?.isEnabled = true
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath)
        if let itemCell = cell as? TagCollectionViewCell {
            itemCell.setup(self.activities[indexPath.row])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let act = self.activities[indexPath.row]

        if act.type != nil && act.body != nil {
            self.saveButton?.isEnabled = false

            let item = TimelineItem()
            item.body = act.body
            item.title = act.title!
            item.type = act.type!
            item.color = act.color
            item.icon = act.icon
            // item.activity = act

            try! Util.realm.write {
                Util.realm.add(item)
            }

            self.dismiss(animated: true)
            self.saveButton?.isEnabled = true

            return
        }

        if act.type != nil {
            mainActivity = act

            navigationItem.title = mainActivity.title
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: mainActivity.color
            ]
        }

        if act.text != nil {
            let tag = act.text! + " "

            if self.bodyLabel?.selectedRange.location != nil, self.replacementInstance != "" {
                var curCursorPos = self.bodyLabel!.selectedRange.location - self.replacementInstance.count + tag.count
                if curCursorPos < 0 {
                    curCursorPos = 0
                }
                self.bodyLabel?.text = self.bodyLabel!.text.replacingOccurrences(
                    of: self.replacementInstance, with: tag)
                self.bodyLabel?.selectedRange = NSRange(location: curCursorPos, length: 0)
            } else {
                self.bodyLabel?.text = self.bodyLabel!.text + " \(tag)"
            }
        }

        self.hideTags()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activities.count
    }

    func textViewDidChange(_ textView: UITextView) {
        let word = textView.editedWord()
        if word.hasPrefix("@") {
            // Person filter
            self.replacementInstance = word
            self.filterPersons(word)
            self.showTags()
        } else if word.hasPrefix("#") {
            // Tag filter
            self.replacementInstance = word
            self.filterTags(word)
            self.showTags()
        } else {
            // No filter
            self.hideTags()
        }
    }

    func forComparison(_ str: String) -> String {
        return str.folding(options: .diacriticInsensitive, locale: .current).lowercased()
    }

    func filterPersons(_ filter: String) {
        if self.tagsMode == "persons", filter.count > 1 {
            // Filter
            let compFilter = self.forComparison(filter)
            var filteredTags = [Activity]()
            for item in AddItemViewController.personsByUsage {
                if filteredTags.count > 12 {
                    break
                }
                if self.forComparison(item.text!).hasPrefix(compFilter) {
                    filteredTags.append(item)
                }
            }
            self.activities = filteredTags
        } else {
            self.tagsMode = "persons"
            self.loadDefaultPersons()
        }

        self.showTags()
    }

    func filterTags(_ filter: String) {
        if self.tagsMode == "tags", filter.count > 1 {
            // Filter
            let compFilter = self.forComparison(filter)
            var filteredTags: [Activity] = []
            for item in AddItemViewController.defaultTagsByUsage {
                if filteredTags.count > 12 {
                    break
                }
                if self.forComparison(item.text!).hasPrefix(compFilter) {
                    filteredTags.append(item)
                }
            }
            self.activities = filteredTags
        } else {
            self.tagsMode = "tags"
            self.loadDefaultTags()
        }

        self.showTags()
    }

    func loadDefaultPersons() {
        self.activities = AddItemViewController.personsByUsage.enumerated().compactMap {
            $0.offset < 24 ? $0.element : nil
        }
    }

    func loadDefaultTags() {
        self.activities = AddItemViewController.defaultTagsByUsage.enumerated().compactMap {
            $0.offset < 24 ? $0.element : nil
        }
    }

    func hideTags() {
        if self.tagsShown {
            UIView.animate(withDuration: 0.5) {
                self.tagsConstraint?.constant = 0
            }
            self.tagsShown = false
        }

        self.activities = []
        self.collectionView?.reloadData()
    }

    func showTags() {
        if self.tagsShown, self.activities.count == 0 {
            self.hideTags()
            return
        }

        self.collectionView?.reloadData()

        if !self.tagsShown {
            UIView.animate(withDuration: 0.5) {
                self.tagsConstraint?.constant = self.tagsHeight
            }

            self.tagsShown = true
        }
    }

}
