//
//  ContentView.swift
//  Final Project
//
//  Created by Scholar on 7/18/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack{
                Text("This")
                NavigationLink(destination: Globe()) {
                    Text("Click Me")
                    NavigationLink(destination: Calc()) {
                        Text("Click Me!!")
                    }
                }
            }
        }
    }
}
    #Preview {
        ContentView()
    }

