//
//  ContentView.swift
//  ScrambledWords
//
//  Created by Abiodun Osagie on 07/04/2025.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES
//    @State var letters: [Letter] = [
//        Letter(id: 0, text: "A"),
//        Letter(id: 1, text: "O"),
//        Letter(id: 2, text: "E"),
//        Letter(id: 3, text: "R"),
//        Letter(id: 4, text: "N"),
//        Letter(id: 5, text: "G"),
//    ]
    //    let correctAnswer = "ORANGE"
    @State var guessedLetters: [Letter] = []
    @State var score = 0

    @State var questions: [QuestionModel] = [
        QuestionModel(
            image: "orange",
            scrambledletters: [                              Letter(id: 0, text: "A"),
                                                             Letter(id: 1, text: "O"),
                                                             Letter(id: 2, text: "E"),
                                                             Letter(id: 3, text: "R"),
                                                             Letter(id: 4, text: "N"),
                                                             Letter(id: 5, text: "G"),], answer: "ORANGE"),
        QuestionModel(image: "banana", scrambledletters: [   Letter(id: 0, text: "A"),
                                                             Letter(id: 1, text: "A"),
                                                             Letter(id: 2, text: "N"),
                                                             Letter(id: 3, text: "B"),
                                                             Letter(id: 4, text: "N"),
                                                             Letter(id: 5, text: "A"),], answer: "BANANA"),
        QuestionModel(image: "apple", scrambledletters: [   Letter(id: 0, text: "P"),
                                                            Letter(id: 1, text: "A"),
                                                            Letter(id: 2, text: "P"),
                                                            Letter(id: 3, text: "E"),
                                                            Letter(id: 4, text: "L"),
                                                           ], answer: "APPLE")
    ]
    @State private var currentQuestionIndex = 0
    @State var showSuccess = false
    @State var showFailure = false
    // MARK: - FUNCTIONS
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.background
                VStack {
                    VStack{
                        Spacer()
                        Image(questions[currentQuestionIndex].image)
                            .resizable()
                            .frame(width: 100, height: 100)
                        Spacer()
                        HStack {
                            ForEach(
                                Array( guessedLetters.enumerated()), id: \.1
                            ) {
index,
 guessedLetter in
                            VStack {
                                LetterView(letter: guessedLetter).textCase(.uppercase)
                                    .onTapGesture {
                                        guessedLetters.remove(at: index)
                                        questions[currentQuestionIndex]
                                            .scrambledletters[guessedLetter.id].text = guessedLetter.text
                                    }
                                Rectangle()
                                    .frame(width: 25, height: 2)
                                    .foregroundStyle(.white)
                            }//: VSTACK
                        }//: LOOP
                        }//: HSTACK
                        .padding(.bottom, 20)
                    }// VSTACK
                    .frame(
                        width: geometry.size.width * 0.9,
                        height: geometry.size.width * 0.9
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.border, lineWidth: 2)
                    }
                    Text("Score: \(score)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.top)
                    HStack{
                        ForEach(
                            Array(
                                questions[currentQuestionIndex].scrambledletters
                                    .enumerated()),
                            id: \.1) {
index,
 letter in
                            LetterView(letter: letter)
                                .onTapGesture {
                                    if !letter.text.isEmpty {
                                        guessedLetters.append(letter)
                                        questions[currentQuestionIndex].scrambledletters[index].text = ""
                                        if guessedLetters.count == questions[currentQuestionIndex].scrambledletters.count {
                                            
                                        // evaluate if right or wrong
                                            let guessedAnswer = guessedLetters.map {$0.text }.joined()
                                            if guessedAnswer
                                                .uppercased() == questions[currentQuestionIndex].answer {
                                                showSuccess = true
                                                score = score + 1
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                                    showSuccess = false
                                                })
                                            } else {
                                                showFailure = true
                                                score = score - 1
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                                    showFailure = false
                                                })
                                                   
                                            }
                                        }
                                    }
                                }
                        }
                       
                        
                    }
                }//: VSTACK
                if showFailure {
                    VStack {
                        Image("cross")
                    }//: VSTACK
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black.opacity(0.3))
                }
                if showSuccess {
                    VStack {
                        Image("tick")
                    }//: VSTACK
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black.opacity(0.3))
                }
            }//: ZSTACK
            .ignoresSafeArea()
        }

        
    }
}

// MARK: - PREVIEW
#Preview {
    ContentView()
}


// MARK: - COMPONENTS
struct LetterView: View {
    let letter: Letter
    var body: some View {
        Text(letter.text)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 30,height: 30)
            .background(.white.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
