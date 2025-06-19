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

struct PlaybackSpeedOption: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}

struct PodcastPlayerView: View {
    
    @StateObject private var viewModel = ContentViewModel()

    let playbackSpeeds: [PlaybackSpeedOption] = [
        PlaybackSpeedOption(label: "0.5x", value: 0.5),
        PlaybackSpeedOption(label: "1x", value: 1.0),
        PlaybackSpeedOption(label: "1.5x", value: 1.5),
        PlaybackSpeedOption(label: "2x", value: 2.0)
    ]
    
    @State private var currentSpeedIndex = 1
    @State private var isPlaying = true
    @State private var playbackSpeed = 1.0
    
    let progress: CGFloat = 0.75
    
    var body: some View {
        
        let currentSpeed = playbackSpeeds[currentSpeedIndex]
        
        if viewModel.isLoading {
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.edgesIgnoringSafeArea(.all))
        } else if let error = viewModel.error {
            Text("Error: \(error)")
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.edgesIgnoringSafeArea(.all))
        } else {
            ZStack {
                (viewModel.isDarkModeEnabled ? Color.hex("#172A67") : Color.hex("#8CCDEB"))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    VStack(alignment: .leading, spacing: 2) {
                        
                        Text(isPlaying ? "Playing" : "Paused")
                            .foregroundColor(viewModel.isDarkModeEnabled ? .orange : Color.hex("#0B1D51"))
                            .font(.system(size: 12, weight: .semibold))
                        
                        Text("Bill Belichick: Inside the Mind of the NFL’s Greatest Coach")
                            .font(.system(size: 14, weight: .bold))
                            .lineLimit(1)
                            .foregroundColor(viewModel.isDarkModeEnabled ? .white : .black)
                        
                        Text("The Knowledge Project")
                            .font(.system(size: 12))
                            .foregroundColor(viewModel.isDarkModeEnabled ? .gray : .black.opacity(0.5))
                            .lineLimit(1)
                    }
                    
                    Spacer(minLength: 10)
                    
                    HStack(spacing: 10) {
                        Button(action: {
                            // Rewind 15 seconds action
                        }) {
                            Image(systemName: "gobackward.15")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(viewModel.isDarkModeEnabled ? .white : .black)
                                .padding(12)
                                .background((viewModel.isDarkModeEnabled ? Color.white.opacity(0.3) : Color.black.opacity(0.1)))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        
                        
                        ZStack {
                            Circle()
                                .stroke((viewModel.isDarkModeEnabled ? Color.gray.opacity(0.3) : Color.black.opacity(0.1)), lineWidth: 3)
                                .frame(width: 60, height: 60)
                            
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(viewModel.isDarkModeEnabled ? Color.orange : Color.hex("#0B1D51"), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .frame(width: 60, height: 60)
                            
                            Button(action: {
                                isPlaying.toggle()
                            }) {
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(viewModel.isDarkModeEnabled ? .white : .black)
                                    .padding(12)
                                    .background((viewModel.isDarkModeEnabled ? Color.white.opacity(0.3) : Color.black.opacity(0.1)))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(.plain)
                            
                        }
                        
                        Button(action: {
                            // Forward 15 seconds action
                        }) {
                            Image(systemName: "goforward.15")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(viewModel.isDarkModeEnabled ? .white : .black)
                                .padding(12)
                                .background((viewModel.isDarkModeEnabled ? Color.white.opacity(0.3) : Color.black.opacity(0.1)))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                    
                    HStack(alignment: .center, spacing: 4) {
                        if viewModel.isPlaybackSpeedControlEnabled {
                            Button(action: {
                                // Change playback speed
                                viewModel.trackPlaybackFeaturesUsed()
                                currentSpeedIndex = (currentSpeedIndex + 1) % playbackSpeeds.count
                            }) {
                                
                                Text(currentSpeed.label)
                                    .font(.system(size: 14, weight: .semibold))
                                    .frame(width: 18, height: 18)
                                    .scaledToFit()
                                    .foregroundColor(viewModel.isDarkModeEnabled ? .white : .black)
                                    .padding(12)
                                    .background((viewModel.isDarkModeEnabled ? Color.white.opacity(0.3) : Color.black.opacity(0.1)))
                                    .clipShape(Circle())
                                
                            }
                            .buttonStyle(.plain)
                        }
                        
                        Spacer()
                        
                        if viewModel.isSettingEnabled {
                            Button(action: {
                                // Show settings
                                viewModel.trackPlaybackFeaturesUsed()
                            }) {
                                Image(systemName: "slider.horizontal.3")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundColor(viewModel.isDarkModeEnabled ? .white : .black)
                                    .padding(12)
                                    .background((viewModel.isDarkModeEnabled ? Color.white.opacity(0.3) : Color.black.opacity(0.1)))
                                    .clipShape(Circle())
                                
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(4)
            }
            .preferredColorScheme(viewModel.isDarkModeEnabled ? .dark : .light)
            .onAppear {
                viewModel.initializeAndFetchFeatureFlags()
            }
        }
    }
}

#Preview {
    PodcastPlayerView()
}
