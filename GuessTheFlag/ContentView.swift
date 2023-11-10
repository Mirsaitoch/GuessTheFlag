//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Мирсаит Сабирзянов on 26.10.2023.
//

import SwiftUI

//struct FlagImage: View{
//    var image: String
//    var degrees: Double
//    var body: some View{
//        Image(image)
//
//    }
//}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correntAns = Int.random(in: 0...2)
    @State private var scoreTitle = ""
    @State private var showingScore = false
    @State private var showingFinishAlert = false
    @State var gameNumber = 1
    @State var score = 0
    @State private var animationAmount = 0.0
    @State private var selectedFlag = -1
    @State private var unSelectedOpacity = 1.0
    @State private var animationScale = 1.0
    var body: some View {
        ZStack{
            RadialGradient(stops: [.init(color: .red, location: 0.5), .init(color: Color(red: 0.3, green: 0.3, blue: 0.5), location: 0.5)], center: .top, startRadius: 250, endRadius: 260)
                .ignoresSafeArea()
            VStack{
                Text("Guess the flag")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                Text("\(gameNumber)/8")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                VStack(spacing: 20){
                    Text("Tap the flag of")
                        .foregroundColor(.secondary)
                        .font(.subheadline.weight(.heavy))
                    Text("\(countries[correntAns])")
                        .foregroundColor(.white)
                        .font(.title.weight(.bold))
                    
                    ForEach(0..<3){num in
                        Button{
                            selectedFlag = num
                            flagTapped(num)
                            print(num)
                            withAnimation{
                                animationAmount += 360
                                unSelectedOpacity = 0.25
                                animationScale -= 0.25
                            }
                        }label: {
                            Image(countries[num])
                                .shadow(radius: 10)
                                .clipShape(Rectangle())
                                .cornerRadius(20)
                                .scaleEffect(selectedFlag != num ? animationScale: animationScale)
                                .opacity(selectedFlag != num ? unSelectedOpacity : 1.0)
                                .animation(.easeInOut, value: animationScale)
                                .rotation3DEffect(
                                    .degrees(selectedFlag == num ? animationAmount: 0), axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
                            )
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(Rectangle())
                .cornerRadius(20)
                
                Text("Your score: \(score)")
                    .foregroundColor(.white)
                    .fontWeight(.ultraLight)
            }
            .padding()
        }.alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: newGame)
        }message: {
            Text("Score: \(score)")
        }
        .alert("Finish", isPresented: $showingFinishAlert){
            Button("New game", action: newGame)
        }
    message: {
        Text("Score: \(score)")
    }
    }
    
    func flagTapped(_ number: Int){
        
        gameNumber += 1
        
        if (gameNumber == 8){
            showingFinishAlert = true
        }
        else{
            if number == correntAns{
                score += 1
                scoreTitle = "Correct!"
            }
            else{
                scoreTitle = "Wrong! This is \(countries[number])"
            }
            showingScore = true
        }
    }
    
    func newGame(){
        if (gameNumber == 8){
            score = 0
            gameNumber = 1
        }
        selectedFlag = -1
        unSelectedOpacity = 1.0
        animationScale = 1
        countries.shuffle()
        correntAns = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
