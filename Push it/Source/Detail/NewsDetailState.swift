//
//  NewsDetailState.swift
//  Push it
//
//  Created by Bart on 25/07/2021.
//

import UIKit

struct NewsDetailState {
    
    enum ArticleState {
        case loading
        case result(UIImage)
        case error(Error)
    }
    
   enum ImageState {
       case loading
       case result(UIImage)
       case error(Error)
   }
    
    let imageState: ImageState
    let articleState: ArticleState
}
