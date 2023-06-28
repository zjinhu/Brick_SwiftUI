//
//  TTextFieldDemoView.swift
//  Example
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI
import Brick_SwiftUI
struct TTextFieldDemoView: View {
    @State var username = ""
    @State var password = ""
    var body: some View {
        VStack{
            
            Text(separator: " ") {

                Text("Login")
                    .font(.headline)
                    .foregroundColor(.red)
                
                Text("for")

                Text("TextField")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            .width(100)
            .background {
                Color.purple
            }
            
            TTextField(text: $username)
                .tTextFieldTitle("Username")
                .tTextFieldPlaceHolderText("Enter...")
                .tTextFieldPlaceHolderTextColor(.gray)
                .tTextFieldHeight(50)
                .tTextFieldCornerRadius(25)
                .tTextFieldTruncationMode(.middle)
                .tTextFieldLimitCount(10)
            
            TTextField(text: $password)
                .tTextFieldSecure(true)
                .tTextFieldTitle("Password")
                .tTextFieldPlaceHolderText("Enter...")
                .tTextFieldPlaceHolderTextColor(.gray)
                .tTextFieldHeight(50)
                .tTextFieldCornerRadius(25)
                .tTextFieldTrailingImageForegroundColor(.black.opacity(0.7))
                .tTextFieldLimitCount(10)

        }
    }
}

struct TTextFieldDemoView_Previews: PreviewProvider {
    static var previews: some View {
        TTextFieldDemoView()
    }
}
