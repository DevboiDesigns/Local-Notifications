//
//  ContentView.swift
//  LocalNotifications
//
//  Created by Christopher Hicks on 7/8/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 38) {
                
                //MARK: - Timer
                Button {
                    // Action
                } label: {
                    createButton(imgName: "timer")
                }
                
               

                HStack(alignment: .center, spacing: 38) {
                    //MARK: - Location
                    Button {
                        // Action
                    } label: {
                        createButton(imgName: "location.circle")
                    }
                    
                    //MARK: - Date
                    Button {
                        // Action
                    } label: {
                        createButton(imgName: "calendar")
                    }
                }
                
            }
        }
       
    }
    
    private func createButton(imgName: String) -> some View {
        VStack {
            
            Image(systemName: imgName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50, alignment: .center)
                .foregroundColor(.gray)
                .padding()
        }
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
