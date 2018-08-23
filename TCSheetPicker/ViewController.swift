//
//  ViewController.swift
//  TCSheetPicker
//
//  Created by tancheng on 2018/8/22.
//  Copyright © 2018年 tancheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pop(_ sender: UIButton) {
        
        let items = [
            TCPickerItem(
                [
                    "name":"a",
                    "id":"1",
                    "children":[
                        [
                            "name":"aa1",
                            "id":"11",
                            "children":[
                            [
                                "name":"aaa1",
                                "id":"111",
                                ]
                            ]
                        ],
                        [
                            "name":"aa2",
                            "id":"112",
                            "children":[
                                [
                                    "name":"aaa2",
                                    "id":"1112",
                                    ]
                            ]
                        ]
                    ]
                ]
            ),
            
            TCPickerItem(
                [
                    "name":"b",
                    "id":"2",
                    "children":[
                        [
                            "name":"bb1",
                            "id":"22",
                            "children":[
                                [
                                    "name":"bbb1",
                                    "id":"111",
                                    ]
                            ]
                        ],
                        [
                            "name":"bb2",
                            "id":"222",
                            "children":[
                                [
                                    "name":"bbb2",
                                    "id":"111",
                                    ]
                            ]
                        ]
                    ]
                ]
            ),
            
            TCPickerItem(
                [
                    "name":"c",
                    "id":"3",
                    "children":[
                        [
                            "name":"331",
                            "id":"22",
                            "children":[
                                [
                                    "name":"3331",
                                    "id":"111",
                                    ]
                            ]
                        ],
                        [
                            "name":"332",
                            "id":"33",
                            "children":[
                                [
                                    "name":"3332",
                                    "id":"333",
                                    ],
                                [
                                    "name":"3333",
                                    "id":"3333",
                                    ]
                            ]
                        ]
                    ]
                ]
            )
        ]
        
        let picker = TCSheetStringPicker("title", items: items)
        picker.show()
        picker.selectedClosure = { names, ids in
            print(names)
        }
        
    }
    
}

