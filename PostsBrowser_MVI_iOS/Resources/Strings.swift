//
//  Strings.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 17/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import Foundation

extension String {

    // MARK: - Titles
    static let title_PostListView = "Title_PostListView".localized.uppercased()
    static let title_PostDetailsView = "Title_PostDetailsView".localized
    static let lbl_UserId = "Lbl_UserId".localized
    static let lbl_FetchingPosts = "Lbl_FetchingPosts".localized
    static let btnTitle_OK = "BtnTitle_OK".localized
    
    // MARK: - Errors
    static let error_NoPosts = "Error_NoPosts".localized
    static let error_NoNetwork = "Error_NoNetwork".localized
    
    // MARK: - Alerts
    static let alertTitle_Attention = "AlertTitle_Attention".localized
    static let alertDesc_Generic = "AlertDesc_Generic".localized
    static let alertTitle_NetworkError = "AlertTitle_NetworkError".localized
    static let alertDesc_NetworkError = "AlertDesc_NetworkError".localized
}
