import Foundation
import SwiftUI

/**
 Represents the main view for displaying news headlines and performing searches.
 */
struct NewsView: View {
    @State var loader: HeadlinesLoader
    @State private var isSearching: Bool = false
    @State private var searchQuery: String = ""
    
    var body: some View {
        VStack {
            Text(searchQuery.isEmpty ? "Environment Headlines" : "Query Headlines")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 8)
            
            Image(systemName: "mountain.2")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(height: 60)
                .padding(.bottom, 20)
            
            SearchBarView(query: $searchQuery, onSearch: performSearch)
            ShowArticles(loader: loader)
        }
        .background(Color.green.edgesIgnoringSafeArea(.all))
        .toolbarBackground(Color.green.opacity(0.7), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
    
    
    private func performSearch() {
        if searchQuery.isEmpty {
            Task { await loader.loadHeadlinesData() }
        } else {
            Task { await loader.loadSearchData(query: searchQuery) }
        }
    }
}


#Preview {
    NewsView(loader: HeadlinesLoader(apiClient: MockNewsAPIClient()))
}


/**
 Provides a text field interface for inputting search queries.
 */
private struct SearchBarView: View {
    @Binding var query: String
    var onSearch: () -> Void
    
    var body: some View {
        TextField("Search for articles...", text: $query)
            .padding(7) // Padding for actual text
            .padding(.horizontal, 10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 10) // Padding for bar
            .onSubmit(onSearch)
            .onChange(of: query) { _ in onSearch() }
    }
}

/**
 Displays articles on the screen after an API call. The API call will display success and errors accordingly.
 */
private struct ShowArticles: View {
    
    var loader: HeadlinesLoader
    
    var body: some View {
        List {
            switch loader.state {
            case .idle, .loading:
                Text("Loading...")
            case .success(let articles):
                ForEach(articles, id: \.id) { article in
                    VStack(alignment: .leading) {
                        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .frame(height: 200)
                                    .frame(width: 350)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        
                        Text(article.title ?? "Untitled")
                            .font(.headline)
                            .foregroundColor(Color.white)
                        Text(article.description ?? "No description available")
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .listRowBackground(Color.green.opacity(0.8))
            case .failed(let error):
                Text("Error: \(error.localizedDescription)")
            }
        }
        .listStyle(.inset)
        .onAppear {
            Task {
                await loader.loadHeadlinesData()
            }
        }
    }
}


