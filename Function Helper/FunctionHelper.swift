//
//  FunctionHelper.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/15/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import Foundation
import OCThumbor

class FunctionHelper: NSObject {
    func getThumborUrlFromImageUrl(imageUrlStr: String, width: Int32, height: Int32) -> URL {
        let thumbor: OCThumbor = OCThumbor.create(withHost: Constants.kTHUMBOR_URL, key: Constants.kTHUMBOR_SECURE_KEY)
        let builder: OCThumborURLBuilder = thumbor.buildImage(imageUrlStr)
        builder.resizeSize = ResizeSizeMake(width, height)
        return URL(string: builder.toUrlSafe())!
    }
}
