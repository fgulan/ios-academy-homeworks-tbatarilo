//
//  NewEpisodeViewController.swift
//  TVShow
//
//  Created by Infinum Student Academy on 27/07/2018.
//  Copyright © 2018 Tomislav Batarilo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import Kingfisher

protocol Reloading: class {
    func shouldReload(episode: Episode)
}

class NewEpisodeViewController: UIViewController {

    @IBOutlet weak var episodeTitleTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var episodeNumberTextField: UITextField!
    @IBOutlet weak var episodeDescriptionTextField: UITextField!
    
    //MARK: -Private-
    private var imagePicker = UIImagePickerController()
    private var mediaId = ""
    private var image: UIImage?
    
    var showId: String?
    var token: String?
    weak var delegate: Reloading?
    
    @IBAction func uploadPhotoButtonTap(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defineCancelButton()
        defineTitle()
        defineAddButton()
    }
    
    private func defineCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectCancel))
    }
    
    private func defineTitle() {
         navigationItem.title = "Add episode"
    }
    
    private func defineAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action:    #selector(didSelectAddShow))
    }
    
    @objc func didSelectAddShow() {
        uploadImageOnAPI(token: token!, completion: {})
    }
    
    @objc func didSelectCancel() {
        self.dismiss(animated: false)
    }
    
    private func showAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Alert", message:
            alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func uploadImageOnAPI(token: String, completion: @escaping () -> ()) {
        let headers = ["Authorization": token]
        
        let someUIImage = image!
        let imageByteData = UIImagePNGRepresentation(someUIImage)!
        
        SVProgressHUD.show()
        
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageByteData,
                                         withName: "file",
                                         fileName: "image.png",
                                         mimeType: "image/png")
            }, to: "https://api.infinum.academy/api" + "/media",
               method: .post,
               headers: headers)
            { [weak self] result in
                switch result {
                case .success(let uploadRequest, _, _):
                    self?.processUploadRequest(uploadRequest)
                case .failure(let encodingError):
                    print(encodingError)
                }
                
                completion()
                
        }
    }
    
    func processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") {[weak self] (response:
                DataResponse<Media>) in
                
                switch response.result {
                    
                case .success(let media):
                    self?.mediaId = media.id
                    self?.addEpisode()
                case .failure(let error):
                    print("FAILURE: \(error)")
                }
                
        }
    }
    
    private func addEpisode() {
        let parameters: [String: String] = [
            "showId": showId!,
            "mediaId": mediaId,
            "title": episodeTitleTextField.text!,
            "description": episodeDescriptionTextField.text!,
            "episodeNumber": episodeNumberTextField.text!,
            "season": seasonNumberTextField.text!
        ]
        
        let headers = ["Authorization": token!]
        
        Alamofire
            .request("https://api.infinum.academy/api/episodes",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers : headers
            )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (response:DataResponse<Episode>) in
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let episode):
                    self?.delegate?.shouldReload(episode: episode)
                    self?.dismiss(animated: true)
                case .failure:
                    self?.showAlert(alertMessage: "Adding episode failed")
                }
        }
    }
}

extension NewEpisodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
}
