//
//  MviViewModel.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 17/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import Foundation
import RxSwift

protocol MviViewModel {
    
    associatedtype I: MviIntent
    associatedtype S: MviViewState
    
    func processIntents(intents: Observable<I>)
    func states() -> Observable<S>
}
