//
//  ContentView.swift
//  Scrumdinger
//
//  Created by Aliya Alymbekova on 24/11/24.
//

import SwiftUI
import AVFoundation

struct MeetingView: View {
    
    @Binding var scrum: DailyScrum
    @StateObject var scrumTimer = ScrumTimer()
    @StateObject var speechRecongnizer = SpeechRecognizer()
    @State private var isRecording = false
    
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(scrum.theme.mainColor)
            VStack {
                MeetingHeaderView(secondElapsed: scrumTimer.secondsElapsed, secondRemaining: scrumTimer.secondsRemaining, theme: scrum.theme)
                MeetingTimerView(speakers: scrumTimer.speakers, isRecording: isRecording, theme: scrum.theme)
                MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
            }
        }
        .padding()
        .foregroundColor(scrum.theme.accentColor)
        .onAppear {
            startScrum()
        }
        .onDisappear {
            endScrum()
              }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func startScrum() {
        scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
        scrumTimer.speakerChangedAction = {
            player.seek(to: .zero)
            player.play()
        }
        speechRecongnizer.resetTranscript()
        speechRecongnizer.stopTranscribing()
        isRecording = true
        scrumTimer.startScrum()
    }
    
    fileprivate func endScrum() {
        scrumTimer.stopScrum()
        speechRecongnizer.stopTranscribing()
        isRecording = false 
        let newHistory = History(attendees: scrum.attendees, transcript: speechRecongnizer.transcript)
        scrum.history.insert(newHistory, at: 0)
    }
    
}

#Preview {
    MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
}
