//
//  LoadingView.swift
//  Drugable
//
//  Created by Vladimir Jeremic on 3/15/21.
//

import SwiftUI

struct LoadingView: View {
    let color: Color
    let text: String
    
    @State var animates = false
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Capsule()
                    .fill(color)
                    .frame(width:10, height:animates ? 30.0 : 70.0)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever())
                Capsule()
                    .fill(color)
                    .frame(width:10, height:animates ? 70.0 : 30.0)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.25))
                Capsule()
                    .fill(color)
                    .frame(width:10, height:animates ? 70.0 : 30.0)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.5))
                Capsule()
                    .fill(color)
                    .frame(width:10, height:animates ? 70.0 : 30.0)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.75))
                Capsule()
                    .fill(color)
                    .frame(width:10, height:animates ? 70.0 : 30.0)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(1))
            }
            Text(text).foregroundColor(color).font(.title3)
        }.onAppear(perform: {
            DispatchQueue.main.async {
                animates.toggle()
            }
        }).fixedSize()
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(color: .black, text: "Loading...")
    }
}
