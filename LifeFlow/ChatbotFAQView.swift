import SwiftUI
import AVFoundation
import Speech

struct ChatbotFAQView: View {
    @State private var messages: [Message] = [
        Message(text: "Hi! I’m your blood donation assistant. How can I help you today?", isUser: false, date: Date())
    ]
    @State private var inputText: String = ""
    
    @State private var isListening = false
    @State private var speechRecognizer = SFSpeechRecognizer()
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var audioEngine = AVAudioEngine()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(messages) { msg in
                            MessageView(message: msg)
                                .id(msg.id)
                        }
                    }
                    .padding()
                    .onChange(of: messages.count) { _ in
                        if let last = messages.last {
                            withAnimation {
                                scrollViewProxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            Divider()
            
            HStack(spacing: 12) {
                Button(action: {
                    if isListening {
                        stopListening()
                    } else {
                        startListening()
                    }
                }) {
                    Image(systemName: isListening ? "mic.fill" : "mic")
                        .foregroundColor(isListening ? .red : .blue)
                        .font(.system(size: 24))
                        .padding(10)
                        .background(isListening ? Color.red.opacity(0.2) : Color.blue.opacity(0.2))
                        .clipShape(Circle())
                }
                
                TextField("Ask a question...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(isListening)
                    .submitLabel(.send)
                    .onSubmit {
                        sendMessage()
                    }
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(inputText.trimmingCharacters(in: .whitespaces).isEmpty || isListening ? Color.gray : Color.red)
                        .clipShape(Circle())
                }
                .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty || isListening)
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .navigationTitle("Chatbot & FAQ")
        .onAppear {
            requestSpeechAuth()
        }
    }
    
    func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let userMessage = Message(text: trimmed, isUser: true, date: Date())
        messages.append(userMessage)
        
        // Simulate bot response with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            let replyText = getBotReply(for: trimmed)
            let botMessage = Message(text: replyText, isUser: false, date: Date())
            messages.append(botMessage)
            speak(text: replyText)
        }
        
        inputText = ""
    }
    
    func getBotReply(for question: String) -> String {
        let lowerQ = question.lowercased()
        
        let faqData: [ [String] : [String] ] = [
            ["eligibility", "who can donate", "criteria", "requirements", "qualify"]: [
                "You must be at least 18 years old, weigh over 50kg, and be healthy to donate blood.",
                "Blood donors need to be 18+, weigh at least 50kg, and be in good health."
            ],
            
            ["interval", "gap", "how often", "frequency"]: [
                "The minimum gap between two blood donations is 3 months.",
                "You should wait at least 3 months between donations for your safety."
            ],
            
            ["thalassemia", "thalassemic", "genetic blood disorder"]: [
                "Thalassemia is a genetic blood disorder. People with severe thalassemia cannot donate blood.",
                "Individuals with severe thalassemia are not eligible to donate blood."
            ],
            
            ["thank", "thanks", "thank you"]: [
                "You’re welcome! If you have more questions, just ask.",
                "Glad I could help! Feel free to ask anything else."
            ],
            
            ["blood groups", "blood type", "types of blood"]: [
                "There are 8 main blood types: A+, A-, B+, B-, AB+, AB-, O+, and O-.",
                "Blood types include A, B, AB, and O, each with positive or negative Rh factor."
            ],
            
            ["donation process", "how to donate", "donation steps"]: [
                "You fill a health questionnaire, undergo a quick medical check, then donate blood in about 10 minutes.",
                "The process involves registration, health check, blood donation, and refreshments."
            ],
            
            ["side effects", "after donation", "post donation"]: [
                "Most donors feel fine after donation, but some might experience mild dizziness or fatigue.",
                "Common side effects can include slight weakness or bruising, but they usually go away quickly."
            ],
            
            ["emergency", "urgent", "immediate need"]: [
                "If there’s an urgent need for blood, hospitals will notify eligible donors directly.",
                "Emergency blood requests are prioritized and communicated swiftly."
            ],
        ]
        
        for (keywords, answers) in faqData {
            for keyword in keywords {
                if lowerQ.contains(keyword) {
                    return answers.randomElement() ?? "Sorry, I don't have an answer right now."
                }
            }
        }
        
        let fallbackReplies = [
            "I’m not sure about that, but I’ll find out for you!",
            "Could you please rephrase your question?",
            "Let me check on that and get back to you!",
            "Sorry, I don't have information on that topic yet."
        ]
        return fallbackReplies.randomElement()!
    }
    
    func speak(text: String) {
        guard !synthesizer.isSpeaking else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
    
    // MARK: - Speech Recognition
    
    func requestSpeechAuth() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized: break
            default:
                print("Speech recognition authorization denied")
            }
        }
    }
    
    func startListening() {
        guard !audioEngine.isRunning else {
            stopListening()
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let node = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                inputText = result.bestTranscription.formattedString
            }
            
            if error != nil || (result?.isFinal ?? false) {
                stopListening()
            }
        }
        
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            isListening = true
        } catch {
            print("Audio engine start error: \(error.localizedDescription)")
        }
    }
    
    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        isListening = false
    }
}

struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let date: Date
}

struct MessageView: View {
    let message: Message
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.text)
                    .padding(12)
                    .background(message.isUser ? userBubbleColor : botBubbleColor)
                    .foregroundColor(message.isUser ? .white : botTextColor)
                    .cornerRadius(16)
                    .shadow(radius: 1)
                
                Text(message.date, style: .time)
                    .font(.caption2)
                    .foregroundColor(timeTextColor)
                    .padding(message.isUser ? .trailing : .leading, 8)
            }
            
            if !message.isUser { Spacer() }
        }
        .padding(message.isUser ? .leading : .trailing, 60)
        .padding(.horizontal, 10)
    }
    
    private var userBubbleColor: Color {
        Color.blue.opacity(colorScheme == .dark ? 0.8 : 0.85)
    }
    
    private var botBubbleColor: Color {
        colorScheme == .dark ? Color(.systemGray5).opacity(0.2) : Color.gray.opacity(0.25)
    }
    
    private var botTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.9) : Color.black
    }
    
    private var timeTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.5) : Color.gray
    }
}
