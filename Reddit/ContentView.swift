//
//  ContentView.swift
//  Reddit
//
//  Created by Serge Vysotsky on 25.05.2020.
//  Copyright © 2020 Serge Vysotsky. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct ContentView: View {
    @State private var posts: [RedditHotPost] = []
    
    var body: some View {
        TabView {
            NavigationView {
                GeometryReader { p in
                    List {
                        ForEach(self.posts) { post in
                            VStack(alignment: .leading) {
                                Text(post.title)
                                if post.url != nil {
                                    KFImage(post.url)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: p.size.width - 32, height: 300)
                                        .clipped()
                                }
                            }.listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                        }
                    }.frame(width: UIScreen.main.bounds.width)
                }.navigationBarTitle("reddit.com")
            }.tabItem {
                VStack {
                    Image(systemName: "doc.text")
                    Text("Hot")
                }
            }
            
            Text("Other 1").tabItem {
                VStack {
                    Image(systemName: "doc.text")
                    Text("Other 1")
                }
            }
            
            Text("Groups").tabItem {
                VStack {
                    Image(systemName: "folder")
                    Text("Groups")
                }
            }
            
            Text("Profile").tabItem {
                VStack {
                    Image(systemName: "person")
                    Text("Profile")
                }
            }
        }.onAppear(perform: loadHot)
        
    }
    
    func loadHot() {
        let hotURL = URL(string: "https://www.reddit.com/r/api/hot.json")!
        URLSession.shared.dataTask(with: hotURL) { data, _, _ in
            guard let data = data else { return }
            let list = try! JSONDecoder().decode(RootResponse.self, from: data)
            self.posts = list.data.children.map { $0.data }
        }.resume()
    }
}

extension RedditHotPost {
    var url: URL? {
        guard let u = preview?.images.first?.resolutions.last?.url.replacingOccurrences(of: "amp;", with: ""),
            let encoded = u.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encoded) else { return nil }
        print(url)
        return url
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
