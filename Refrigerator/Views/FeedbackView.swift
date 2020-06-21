//
//  FeedbackView.swift
//  Refrigerator
//
//  Created by Ryan Du on 6/17/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import Firebase

struct FeedbackView: View {
    @State var responseText = ""
    @State var show = false
    @State var ref: DocumentReference!
    var body: some View {
        GeometryReader{ geo in
            ScrollView{
            ZStack{
            VStack{
                Text(RemoteConfigManager.stringValue(forkey: RCKeys.feedbackViewMessage.rawValue)).padding().fixedSize(horizontal: false, vertical: false)
                Spacer()
                
                MultilineTextField("", text: self.$responseText, onCommit: {
                    
                })
                    .frame(width: geo.size.width - 30)
                    .padding(.vertical)
                    .background(
                        Rectangle()
                            .fill(Color("cellColor"))
                            .frame(width: geo.size.width - 30)
                            .cornerRadius(12)
                        
                )
                Spacer()
                Button(action: {
                    print("button Pressed")
                    
                    Analytics.logEvent("feedback", parameters: ["feedbackText" : self.responseText])
                    withAnimation(){
                        self.show.toggle()
                    }
                    self.ref = Firestore.firestore().collection("Feedback").addDocument(data: ["Feedback": self.responseText, "hasBeenRead" : false])
                    simpleSuccess()
                }, label: {
                    Image("sendButton").renderingMode(.original)
                    }).buttonStyle(PlainButtonStyle()).padding()
                
                
                if self.show{
                    Text("Sent!").foregroundColor(.green)
                }

            }.navigationBarTitle("Feedback View")
                
            }
            }
        }
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}

fileprivate struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var onDone: (() -> Void)?

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear

//        if nil != onDone {
//            textField.returnKeyType = .done
//        }

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        if uiView.window != nil, !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        }
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // !! must be called asynchronously
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?

        init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
            onDone!()
        }
        
//        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//            if let onDone = self.onDone, text == "\n" {
//                textView.resignFirstResponder()
//                onDone()
//                return false
//            }
//            return true
//        }
    }

}

struct MultilineTextField: View {

    private var placeholder: String
    private var onCommit: (() -> Void)?

    @Binding private var text: String
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.showingPlaceholder = $0.isEmpty
        }
    }

    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = false

    init (_ placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self._showingPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

    var body: some View {
        UITextViewWrapper(text: self.internalText, calculatedHeight: $dynamicHeight, onDone: onCommit)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
            .background(placeholderView, alignment: .topLeading)
    }

    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
}
