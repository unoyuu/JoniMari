//
//  ContentView.swift
//  JoniMariPon
//
//  Created by 宇野佑 on 2024/05/12.
//

import SwiftUI

struct ContentView: View {
    @State var inputName = ""
    @State var isAlertPresented:Bool = false
    @State private var isPressed:Bool = false
    @State var disabled:Bool = true
    var body: some View {
        VStack {
            NavigationStack{
                TextField("名前を入力してください",text: $inputName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                //デフォルトはグレーアウト
                Button(action:{
                    if imageExists(named: inputName){
                        isPressed = true
                    }else{
                        isAlertPresented = true
                    }
                }){
                    Text("決定")
                }
                .padding()
                .accentColor(.white)
                .background(.blue)
                .cornerRadius(10)
                .onChange(of: inputName){ newValue in
                    if newValue != ""{
                        disabled = false
                    }else{
                        disabled = true
                    }
                }
                .disabled(disabled)
                .navigationDestination(isPresented: $isPressed){
                    ImageView(inputName: inputName)
                }
                .alert(isPresented: $isAlertPresented) {
                    Alert(title: Text("Error"), message: Text("\(inputName)の画像は見つかりませんでした"), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

func imageExists(named: String) -> Bool {
    return UIImage(named: named) != nil
}

struct ImageView:View {
    var inputName : String
    @State private var sliderVal:Double = 50
    @State private var flag = true
    @State private var isTalkPressed:Bool = false
    var body: some View {
        VStack{
            Text(flag ? "吾輩は\(inputName)である" : "")
            
            Toggle("",isOn: $flag)
                .labelsHidden()
            
            if let _ =  UIImage(named: inputName){
                Image(inputName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: sliderVal,height: sliderVal)
            }
            
            Spacer()
            //sliderで画像サイズを変更できるが、slider自身は画像サイズ変更に引っ張られたくない
            //子viewを用意して、sliderを宣言する？
            Slider(value: $sliderVal,in: 50...500)
                .padding()
            
            Button(action:{
                isTalkPressed = true
            }){
                Text("会話してみる")
            }
            .padding()
            .accentColor(.white)
            .background(.blue)
            .cornerRadius(10)
            .navigationDestination(isPresented: $isTalkPressed){
                //画面遷移
                ChatView()
            }
            
        }
    }
}

#Preview {
    ContentView()
}


