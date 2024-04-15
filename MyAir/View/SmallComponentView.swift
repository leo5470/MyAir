//
//  SmallComponentView.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/14.
//

import SwiftUI

struct SmallComponentView: View {
    var caption: String
    var symbolName: String
    
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [.accent, Color("Light Blue")], startPoint: .bottom, endPoint: .top)
            
            HStack {
                Text(caption)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Image(systemName: symbolName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .foregroundStyle(.white)
                    .padding(.bottom, 25)
            }
            .padding(.horizontal, 15)
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .frame(height: 120)
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
    }
}

#Preview {
    SmallComponentView(caption: "更多\n本地資料", symbolName: "mappin")
}
