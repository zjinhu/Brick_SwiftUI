//
//  ContentView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/5/12.
//

import SwiftUI
import Brick_SwiftUI
struct ContentView: View {
    @Brick.AppStorage("START_TIME_KEY", store:UserDefaults.standard) var startTime: Date = Date()
 
    var body: some View {
        TabbarView()
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


