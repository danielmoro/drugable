//
//  MyToggle.swift
//  Drugable
//
//  Created by Vladimir Jeremic on 3/17/21.
//

import SwiftUI

struct MyToggle: View {
    
    @Binding var isOn: Bool
    
    
    var body: some View {
        Capsule()
            .fill(isOn ? Color.accentColor : Color(red: 220/255.0, green: 220/255.0, blue: 220/255.0))
            .frame(width: 60, height: 30, alignment: .center).overlay(circle())
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.2)) {
                isOn.toggle()
            }
        }
    }
    
    func circle() -> some View {
        Circle()
            .fill(Color.white)
            .frame(width: 24, height: 24)
            .offset(x: isOn ? 14 : -14)
            .shadow(
                color: Color(
                        white: 0.6,
                        opacity: 1.0),
                radius: 1, x: 0.0, y: 0.0)
    }
}

struct MyToggle_Previews: PreviewProvider {
    static var previews: some View {
        MyToggle(isOn: .constant(true))
    }
}
