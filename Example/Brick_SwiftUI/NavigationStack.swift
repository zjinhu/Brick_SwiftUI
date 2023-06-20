//
//  NavigationStack.swift
//  Example
//
//  Created by iOS on 2023/6/12.
//

import SwiftUI
import Brick_SwiftUI
struct NavigationStackTView: View {
    @EnvironmentObject var navigator: PathNavigator
    
    var body: some View {
        List{
            
            Brick.NavigationLink(value: NumberList(range: 0 ..< 10), label: { Text("Pick a number") })
            // Push via navigator
            Button("99 Red balloons", action: show99RedBalloons)
            // Push child class via navigator
            Button("Show Class Destination", action: showClassDestination)
        }
        .ss.useNavigationStack()
        .ss.navigationDestination(for: NumberList.self, destination: { numberList in
          NumberListView(numberList: numberList)
        })
        .ss.navigationDestination(for: Int.self, destination: { number in
            NumberView(number: number)
        })
        .ss.navigationDestination(for: ClassDestination.self, destination: { destination in
            ClassDestinationView(destination: destination)
        })
    }
    
    
    func show99RedBalloons() {
        navigator.push(99)
    }
    
    func showClassDestination() {
        navigator.push(SampleClassDestination())
    }
}

struct NavigationStackTView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStackTView()
    }
}


struct NumberList: Hashable, Codable {
    let range: Range<Int>
}

private struct NumberListView: View {
  let numberList: NumberList
  var body: some View {
    List {
      ForEach(numberList.range, id: \.self) { number in
          Brick.NavigationLink("\(number)", value: number)
      }
    }.navigationTitle("List")
  }
}


private struct NumberView: View {
    @EnvironmentObject var navigator: PathNavigator
    @State var number: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(number)").font(.title)
            
            Stepper(
                label: { Text("\(number)") },
                onIncrement: { number += 1 },
                onDecrement: { number -= 1 }
            ).labelsHidden()
            
            Brick.NavigationLink(
                value: number + 1,
                label: { Text("Show next number") }
            )
            
            Button("Go back to root") {
                navigator.popToRoot()
            }
        }.navigationTitle("\(number)")
    }
}

class ClassDestination {
    let data: String
    
    init(data: String) {
        self.data = data
    }
}

extension ClassDestination: Hashable {
    static func == (lhs: ClassDestination, rhs: ClassDestination) -> Bool {
        lhs.data == rhs.data
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }
}

class SampleClassDestination: ClassDestination {
    init() { super.init(data: "Sample data") }
}

private struct ClassDestinationView: View {
    let destination: ClassDestination
    
    var body: some View {
        Text(destination.data)
            .navigationTitle("A ClassDestination")
    }
}
