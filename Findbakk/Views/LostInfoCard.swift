//
//  LostInfoCard.swift
//  Findbakk
//
//  Created by jack on 2021/3/8.
//

import SwiftUI

struct LostInfoCard: View {
    var body: some View {
        VStack {
            Spacer().frame(height:0)
            
            Image("Cat")
                .resizable()
                .frame(minHeight:200)
                .scaledToFill()
                .scaledToFit()
                .clipped()
            
            HStack{
                Spacer()
                Circle()
                    .colorMultiply(.blue)
                    .frame(width: 40, height: 40)
                    .overlay(Image("Pet")
                                .resizable()
                                .frame(width: 35, height: 35))
                
                Spacer()
                    .frame(width:10)
            }
            List {
                HStack {
                    Text("Title:")
                    Text("Cat").foregroundColor(.gray)
                }.padding(.horizontal,4)
                HStack {
                    VStack{
                        Text("desc:")
                        Spacer()
                    }
                    
                    Text(".............................................").foregroundColor(.gray)
                }.padding(.horizontal,4)
            }
            Spacer()
        }.background(Color(UIColor.systemBackground))
//        .frame(width: 200, height: 400, alignment: .center)
        
    }
}

struct LostInfoCard_Previews: PreviewProvider {
    static var previews: some View {
        LostInfoCard().previewLayout(.fixed(width: 200, height: 400))
    }
}
