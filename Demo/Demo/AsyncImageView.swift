//
//  ImageView.swift
//  Example
//
//  Created by iOS on 2023/6/9.
//

import SwiftUI
import Brick_SwiftUI
struct AsyncImageView: View {

    
    var body: some View {
        VScrollStack{
   
            Brick.AsyncImage(url: URL(string:"https://t7.baidu.com/it/u=2531125946,3055766435&fm=193&f=GIF")!) { image in
                image
                    .resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 250, height: 250)
            
            
            Brick.AsyncImage(url: URL(string:"https://t7.baidu.com/it/u=2531125946,3055766435&fm=193&f=GIF")!, scale: 2) { phase in // 1
                if let image = phase.image { // 2
                    // if the image is valid
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if phase.error != nil { // 3
                    // some kind of error appears
                    Text("404! \n No image available 😢")
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                } else { // 4
                    // showing progress view as placeholder
                    ProgressView()
                        .font(.largeTitle)
                }
            }.padding()
            
            Brick.AsyncImage(url: URL(string: "AWrongURL")!) { phase in // 1
                if let image = phase.image { // 2
                    // if the image is valid
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if phase.error != nil { // 3
                    // some kind of error appears
                    Text("No image available")
                } else {
                    //appears as placeholder image
                    Image(systemName: "photo") // 4
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }.frame(width: 250, height: 250, alignment: .center)
            
        }
 
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView()
    }
}
