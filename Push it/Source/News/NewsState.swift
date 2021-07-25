//
//  NewsState.swift
//  Push it
//
//  Created by Bart on 25/07/2021.
//

import Foundation

struct NewsState {
    
   enum ArticleState {
       case loading
       case result([NetworkArticle])
       case error(Error)
   }
    
   let articleState: ArticleState
}
