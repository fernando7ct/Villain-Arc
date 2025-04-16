//
//  UserQuestionsView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/11/25.
//

import SwiftUI

struct UserQuestionsView: View {
    @Environment(\.modelContext) private var context
    @State var profileStep: Int = 0
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var username: String = ""
    @State var birthday: Date = Date.fromDate(years: -18)
    @FocusState var firstNameFocusState: Bool
    @FocusState var lastNameFocusState: Bool
    @FocusState var usernameFocusState: Bool
    @State private var existingUsernames: [String] = []
    
    var nextButtonDisabled: Bool {
        switch profileStep {
        case 0:
            firstName.isEmpty
        case 1:
            lastName.isEmpty
        case 2:
            usernameStatus != "Available!"
        default:
            false
        }
    }
    
    var usernameStatus: String {
        if username.isEmpty {
            return " "
        } else if username.count < 3 {
            return "Username must be at least 3 characters long."
        } else if username.contains(" ") {
            return "Username cannot contain spaces."
        } else if username.prefix(1).rangeOfCharacter(from: CharacterSet.letters) == nil {
            return "Username must start with a letter."
        } else if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: username)) {
            return "Username cannot be numbers only."
        } else if !CharacterSet.alphanumerics.isSuperset(of: CharacterSet(charactersIn: username)) {
            return "Username can only contain letters and numbers."
        } else if existingUsernames.contains(username.lowercased()) {
            return "Username already taken."
        } else {
            return "Available!"
        }
    }
    
    private func updateStep() {
        if profileStep < 3 && !nextButtonDisabled {
            profileStep += 1
        } else if profileStep == 3 {
            DataManager.shared.createUser(firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines), lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines), username: username.lowercased(), birthday: birthday, context: context)
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            switch profileStep {
            case 0:
                firstNameView()
                    .transition(.blurReplace)
            case 1:
                lastNameView()
                    .transition(.blurReplace)
            case 2:
                usernameView()
                    .transition(.blurReplace)
            case 3:
                birthdayView()
                    .transition(.blurReplace)
            default: Text("")
            }
            
            Spacer()
            
            Button {
                updateStep()
            } label: {
                Text(profileStep < 3 ? "Next" : "Finish")
                    .continueButtonStyle()
            }
            .disabled(nextButtonDisabled)
            .opacity(nextButtonDisabled ? 0.5 : 1)
            
            if profileStep > 0 {
                Button {
                    profileStep -= 1
                } label: {
                    Text("Back")
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                }
                .padding(.top)
            }
        }
        .padding(.horizontal, 30)
        .safeAreaPadding(.bottom, 40)
        .animation(.smooth, value: profileStep)
        .onAppear {
            DataManager.shared.fetchAllUsernames { usernames in
                existingUsernames = usernames
            }
        }
    }
    
    @ViewBuilder
    private func firstNameView() -> some View {
        TextField("First Name", text: $firstName)
            .userInfoTextFieldStyle()
            .focused($firstNameFocusState)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    firstNameFocusState = true
                }
            }
    }

    @ViewBuilder
    private func lastNameView() -> some View {
        TextField("Last Name", text: $lastName)
            .userInfoTextFieldStyle()
            .textInputAutocapitalization(.words)
            .focused($lastNameFocusState)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    lastNameFocusState = true
                }
            }
    }
    
    @ViewBuilder
    private func usernameView() -> some View {
        VStack(alignment: .leading) {
            TextField("Username", text: $username)
                .userInfoTextFieldStyle()
                .textInputAutocapitalization(.never)
                .focused($usernameFocusState)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        usernameFocusState = true
                    }
                }
            Text(usernameStatus)
                .foregroundStyle(nextButtonDisabled ? .red : .green)
                .font(.caption)
        }
    }
    
    @ViewBuilder
    private func birthdayView() -> some View {
        HStack {
            TextField("Birthday", text: .constant(""))
                .disabled(true)
                .userInfoTextFieldStyle()
            DatePicker("", selection: $birthday, in: Date.fromDate(years: -90)...Date.fromDate(years: -16), displayedComponents: .date)
                .datePickerStyle(.compact)
                
        }
    }
}

#Preview {
    ZStack {
        Background()
        
        UserQuestionsView()
            .environment(\.colorScheme, .dark)
    }
}
