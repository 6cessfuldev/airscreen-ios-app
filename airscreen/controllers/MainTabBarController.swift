//
//  MainTabBarController.swift
//  airscreen
//
//  Created by 육성민 on 2/9/24.
//

import Alamofire
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("app start")
        getTest()
    }
    
    func getTest() {
        let url = "https://jsonplaceholder.typicode.com/todos/1"
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .responseDecodable(of: Todo.self) { response in
                switch response.result {
                case .success(let todo):
                    print("Received todo: \(todo)")
                case .failure(let error):
                    print("API 요청 실패: \(error.localizedDescription)")
                }
        }
    }
}
