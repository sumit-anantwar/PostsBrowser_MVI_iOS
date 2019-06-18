//
//  ConnectableObservableType+Extensions.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 18/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import Foundation
import RxSwift

extension ConnectableObservableType {
    func autoConnect() -> Observable<E> {
        return Observable.create { observer in
            return self.do(onSubscribe: {
                _ = self.connect()
            }).subscribe { (event: Event<Self.E>) in
                switch event {
                case .next(let value):
                    observer.on(.next(value))
                case .error(let error):
                    observer.on(.error(error))
                case .completed:
                    observer.on(.completed)
                }
            }
        }
    }
}
