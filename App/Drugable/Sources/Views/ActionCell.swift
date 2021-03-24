//
//  ActionCell.swift
//  Drugable
//
//  Created by Vladimir Jeremic on 3/19/21.
//

import SwiftUI

struct Action: Identifiable {
    var title: String
    var handler: ((Action) -> Void)
    var color: Color
    var id: String = UUID().uuidString
}

struct ActionView: View {
    
    var action: Action
    
    var body: some View {
        HStack {
            Text(action.title)
        }
        .background(action.color)
    }
}

struct ActionCell: View {
    
    enum SwipeState {
        case left, right, normal
    }
    
    var leftActions: [Action]
    var rightActions: [Action]
    
    @State var swipeDirection = SwipeState.normal
    
    
    var body: some View {
        HStack {
            GeometryReader(content: { geometry in
                leftActionView
                Text("Title")
                    .multilineTextAlignment(.leading)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                rightActionView
            })
        }.gesture(
            DragGesture().onChanged({ value in
                print(value.translation)
            }).onEnded({ value in
                if abs(value.translation.width) > 100 {
                    if value.translation.width < 0 {
                        swipeDirection = .right
                    } else {
                        swipeDirection = .left
                    }
                }
            })
        )
    }
    
    var leftActionView: some View {
        HStack {
            if swipeDirection == .left {
                ForEach(leftActions) { action in
                    ActionView(action: action)
                }
            }
        }
    }
    
    var rightActionView: some View {
        HStack {
            if swipeDirection == .right {
                ForEach(rightActions) { action in
                    ActionView(action: action)
                }
            }
        }
    }
}

struct ActionCell_Previews: PreviewProvider {
    static var previews: some View {
        ActionCell(leftActions: [Action(title: "addImage", handler: { action in
            //
        }, color: .red)], rightActions: [Action(title: "addImage", handler: { action in
            //
        }, color: .red)])
    }
}
