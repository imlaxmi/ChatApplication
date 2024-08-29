//
//  ChatViewController.swift
//  firebase_registration
//
//  Created by Yusata Infotech Pvt Ltd on 14/08/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messagesTableView: UITableView!

    var ref: DatabaseReference!
    var messages: [Message] = []
    var users: [String: String] = [:] // Dictionary to store userID and username pairs

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        ref = Database.database().reference()
        observeUsers() // Load usernames
        observeMessages()
    }

    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let messageText = messageTextField.text, !messageText.isEmpty else {
            return
        }
        
        let currentUser = Auth.auth().currentUser!
        let message = [
            "senderId": currentUser.uid,
            "text": messageText,
            "timestamp": ServerValue.timestamp()
        ] as [String: Any]
        
        ref.child("chats").child("chat_id_1").child("messages").childByAutoId().setValue(message) { error, _ in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            } else {
                self.messageTextField.text = ""
            }
        }
    }
    private func observeUsers() {
            ref.child("users").observe(.value) { snapshot in
                guard let usersData = snapshot.value as? [String: [String: Any]] else { return }
                
                for (userId, userInfo) in usersData {
                    if let username = userInfo["username"] as? String {
                        self.users[userId] = username
                    }
                }
                
                self.messagesTableView.reloadData() // Reload to show usernames
            }
        }
    private func observeMessages() {
        ref.child("chats").child("chat_id_1").child("messages").observe(.childAdded) { snapshot in
            guard let messageData = snapshot.value as? [String: Any] else { return }
            let senderId = messageData["senderId"] as? String ?? ""
            let text = messageData["text"] as? String ?? ""
            let timestamp = messageData["timestamp"] as? Int ?? 0
            
            let message = Message(senderId: senderId, text: text, timestamp: timestamp)
            self.messages.append(message)
            self.messagesTableView.reloadData()
        }
    }
}

struct Message {
    let senderId: String
    let text: String
    let timestamp: Int
}
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return messages.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
           let message = messages[indexPath.row]
           
           let senderUsername = users[message.senderId] ?? "Unknown User"
           cell.senderLabel.text = senderUsername//message.senderId
           cell.messageLabel.text = message.text
           
           return cell
       }

       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
    
}

