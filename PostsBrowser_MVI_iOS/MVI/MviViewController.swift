//
//  MviViewController.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 17/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import Foundation
import RxSwift

class MviViewController<I: MviIntent, S: MviViewState> : BaseViewController, MviView {
   
    let bag = DisposeBag()
    
    func bindIntents() {
        Log.fatalError(message: "Subclass needs to implement `bindIntents()` method")
    }
    
    func intents() -> Observable<I> {
        Log.fatalError(message: "Subclass needs to implement `intents()` method")
    }
    
    func render(state: S) {
        Log.fatalError(message: "Subclass needs to implement `render()` method")
    }
    
    
}
