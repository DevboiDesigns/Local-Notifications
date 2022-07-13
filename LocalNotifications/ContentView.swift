//
//  ContentView.swift
//  LocalNotifications
//
//  Created by Christopher Hicks on 7/8/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var alertService = AlertService()
    @ObservedObject var vm = ViewModel()
    
    @State private var components = DateComponents()
    
    @State private var showAlert: Bool = false
    
    @State private var object: [Any] = []
    
    //MARK: - SwiftUI
    let pub = NotificationCenter.default.publisher(for: NSNotification.Name("internalNotification.enteredRegion"))
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 38) {
                
                //MARK: - Timer
                Button {
                    alertService.timerAlert()
                    self.showAlert.toggle()
                    UNService.shared.timerRequest(with: 5)
                } label: {
                    createButton(imgName: "timer")
                }
                
               
                HStack(alignment: .center, spacing: 38) {
                    //MARK: - Location
                    Button {
                        alertService.locationAlert()
                        self.showAlert.toggle()
                        CLService.shared.updateLocation()
                        
                    } label: {
                        createButton(imgName: "location.circle")
                    }
                    
                    
                    //MARK: - Date
                    Button {
                        alertService.dateAlert()
                        self.showAlert.toggle()
                        UNService.shared.dateRequest(with: components)
                    } label: {
                        createButton(imgName: "calendar")
                    }
                }
                
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertService.title), message: Text(alertService.message), dismissButton: .cancel())
        }
        .onReceive(pub, perform: { output in
            //MARK: - Notification Observer for SwiftUI
            vm.didEnterRegion()
        })
        .onAppear {
            // Best to not add too much to AppDelegate (slows down opening of app)
            UNService.shared.authorize()
            CLService.shared.authorize()
            // will trigger everytime clock lands on Zero
            components.second = 0
//            components.weekday = 1 // Sunday 1 : Monday 2
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
