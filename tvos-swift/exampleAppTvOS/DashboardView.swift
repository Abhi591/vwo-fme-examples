/**
 * Copyright 2025 Wingify Software Pvt. Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import SwiftUI

struct Video: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let portraitImageUrl: String
    let landscapeImageUrl: String
}

struct DashboardView: View {
    
    let playlist: [Video] = [
        Video(title: "Exploring the Wonders of Iceland",
                     description: "Join us on a journey through Iceland's stunning landscapes and natural wonders.",
                     portraitImageUrl: "iceland-portrait",
                     landscapeImageUrl: "iceland"),
        
        Video(title: "A Tour of Japan's Hidden Gems",
                     description: "Discover the lesser-known but breathtaking spots in Japan.",
                     portraitImageUrl: "japan-portrait",
                     landscapeImageUrl: "japan"),
        
        Video(title: "Backpacking Through South America",
                     description: "Experience the vibrant cultures and diverse landscapes of South America.",
                     portraitImageUrl: "south-america-portrait",
                     landscapeImageUrl: "south-america"),
        
        Video(title: "The Beauty of New Zealand",
                     description: "Explore the majestic scenery and adventure activities in New Zealand.",
                     portraitImageUrl: "new-zealand-portrait",
                     landscapeImageUrl: "new-zealand"),
        
        Video(title: "A Journey Across Europe by Train",
                     description: "Travel through Europe's iconic cities and countryside by train.",
                     portraitImageUrl: "europe-portrait",
                     landscapeImageUrl: "europe"),
        
        Video(title: "Discovering the Culture of India",
                     description: "Immerse yourself in the rich culture and history of India.",
                     portraitImageUrl: "india-portrait",
                     landscapeImageUrl: "india"),
        
        Video(title: "Safari Adventure in Africa",
                     description: "Join us on a thrilling safari adventure in Africa's wildlife reserves.",
                     portraitImageUrl: "africa-portrait",
                     landscapeImageUrl: "africa"),
        
        Video(title: "Exploring the Canadian Rockies",
                     description: "Witness the breathtaking beauty of the Canadian Rockies.",
                     portraitImageUrl: "canada-portrait",
                     landscapeImageUrl: "canada"),
        
        
        Video(title: "Adventures in Alaska",
                     description: "Explore the rugged wilderness and stunning landscapes of Alaska.",
                     portraitImageUrl: "alaska-portrait",
                     landscapeImageUrl: "alaska"),
        
        Video(title: "Discovering Australia",
                     description: "Experience the diverse wildlife and iconic landmarks of Australia.",
                     portraitImageUrl: "australia-portrait",
                     landscapeImageUrl: "australia"),
    ]
    
    @StateObject private var viewModel = DashboardViewModel()
    @State private var selectedShow: Video?

    let listWidth: CGFloat = 400
    let spacing: CGFloat = 40
    
//    // Focus state for tvOS focus engine
//    @FocusState private var focusedShow: Video?
    
    var body: some View {
        
        if viewModel.isLoading {
            // Show loading indicator while feature flags are loading
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.edgesIgnoringSafeArea(.all))
        } else if let error = viewModel.error {
            // Show error message if loading failed
            Text("Error: \(error)")
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.edgesIgnoringSafeArea(.all))
        } else {
            GeometryReader { geo in
                
                HStack(spacing: 40) {
                    // Left: List of shows
                    VStack(alignment: .leading, spacing: 20) {
                        
                        HStack {
                            Text("Travel Videos")
                                .font(.system(size: 46, weight: .bold))
                                .foregroundColor(.white)
                            
                            Button(action: {
                                self.viewModel.showRandomVariation()
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "shuffle")
                                        .font(.system(size: 24))
                                        .padding(10)
                                }
                                .background(.black)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                            }
                            .buttonStyle(.plain)
//                           comment below line to try different variations
                            .hidden()
                        }
                        
                        List(playlist, id: \.id) { show in
                            Text(show.title)
                                .font(.system(size: selectedShow == show ? 36 : 32, weight: .semibold))
                                .foregroundColor(selectedShow == show ? .yellow : .white)
                                .listRowBackground(Color.clear)
                                .focusable(true)
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedShow == show ? Color.yellow.opacity(0.25) : Color.clear)
                                )
                                .onTapGesture {
                                    selectedShow = show
                                }
                        }
                        .listStyle(PlainListStyle())
                        .frame(width: listWidth)
                        .background(Color.black)
                    }
                    
                    // Right: Detail panel for selected show
                    if let show = selectedShow {
                        VStack(alignment: .leading, spacing: 30) {
                            
                            // Poster
                            Image(viewModel.isFeatureEnabled && viewModel.posterPortrait ? show.portraitImageUrl : show.landscapeImageUrl)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(20)

                            // Title
                            Text(show.title)
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Description
                            Text(show.description)
                                .font(.system(size: 28))
                                .foregroundColor(.white.opacity(0.85))
                            
                            // Play button
                            HStack(spacing: 30) {
                                Button(action: {

                                    self.viewModel.trackPlayButtonInteraction(isWatchListEnabled: self.viewModel.isWatchListEnabled)
                                    
                                }) {
                                    HStack(spacing: 20) {
                                        Image(systemName: "play.fill")
                                            .font(.system(size: 32))
                                        Text("Play")
                                            .font(.system(size: 32, weight: .bold))
                                    }
                                    .padding(.horizontal, 50)
                                    .padding(.vertical, 20)
                                    .background(Color.hex(viewModel.isFeatureEnabled ? viewModel.playButtonColor : "#E50914"))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .shadow(color: .red.opacity(0.3), radius: 5, x: 0, y: 0)
                                }
                                .buttonStyle(.plain)
                                .padding(.top, 20)
                                
                                if viewModel.isFeatureEnabled && viewModel.isWatchListEnabled {
                                    Button(action: {

                                    }) {
                                        HStack(spacing: 20) {
                                            Image(systemName: "plus")
                                                .font(.system(size: 32))
                                            Text("My List")
                                                .font(.system(size: 32, weight: .semibold))
                                        }
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, 20)
                                        .background(.white)
                                        .foregroundColor(.black.opacity(0.85))
                                        .cornerRadius(15)
                                        .shadow(color: .white.opacity(0.3), radius: 5, x: 0, y: 0)
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.top, 20)
                                }
                            }
                        }
                        .padding(40)
                        .frame(width: max(0, geo.size.width - listWidth - spacing), alignment: .leading)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.red.opacity(0.75), Color.black.opacity(0.6)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .cornerRadius(30)
                            .shadow(radius: 20)
                        )
                        .padding(.vertical, 40)
                        .transition(.opacity)
                    } else {
                        Spacer()
                    }
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
                .animation(.easeInOut, value: selectedShow)
                .onAppear {
                    viewModel.initializeAndFetchFeatureFlags()
                    selectedShow = playlist.first
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
