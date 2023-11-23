//
//  TTextFieldDemoView.swift
//  Example
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI
import BrickKit

struct TTextFieldDemoView: View {
    @State var birthday: Date = Date()
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
                .tTextFieldSecureImageForegroundColor(.red)
                .tTextFieldLimitCount(10)

            TTextField(text: $username)
                .tTextFieldBorderType(.line)
                .tTextFieldTitle("Username")
                .tTextFieldPlaceHolderText("Enter...")
                .tTextFieldPlaceHolderTextColor(.gray)
                .tTextFieldHeight(50)
                .tTextFieldCornerRadius(25)
                .tTextFieldTruncationMode(.middle)
                .tTextFieldLimitCount(10)
                .tTextFieldLeadingView {
                    Image(symbol: .calendar)
                        .padding(.leading, 12)
                }
            
            TTextField(text: $username)
                .tTextFieldBorderType(.line)
                .tTextFieldTitle("Username")
                .tTextFieldPlaceHolderText("Enter...")
                .tTextFieldPlaceHolderTextColor(.gray)
                .tTextFieldHeight(50)
                .tTextFieldCornerRadius(25)
                .tTextFieldTruncationMode(.middle)
                .tTextFieldLimitCount(10)
                .tTextFieldLeadingView {
                    Image(symbol: .calendar)
                        .padding(.leading, 12)
                }
                .tTextFieldTrailingView {
                    Image(symbol: ._00Circle)
                }
            
#if os(iOS)
            UnderLineText()
                .underLineText("Text")
                .underLineTitle("Title")
                .underLineColor(.red)
                .underLineLeadingView{
                    Image(symbol: .calendar)
                }
                .underLineTrailingView {

                    DatePicker("", selection: $birthday, displayedComponents: .date)
                }
#endif
        }
        .padding()
#if os(iOS)
        .ss.tabBar(.hidden)
#endif
    }
}

struct TTextFieldDemoView_Previews: PreviewProvider {
    static var previews: some View {
        TTextFieldDemoView()
    }
}
