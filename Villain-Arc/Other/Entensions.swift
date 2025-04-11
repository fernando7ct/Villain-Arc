//
//  Entensions.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

struct SignInButtonModifer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .foregroundStyle(.black)
            .fontWeight(.semibold)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct EmailPasswordTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.leading)
            .textFieldStyle(.plain)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(.white.opacity(0.25), style: .init(lineWidth: 3, lineCap: .round, lineJoin: .round))
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .tint(.white)
    }
}

struct ContinueButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.vertical, 13)
            .padding(.horizontal, 50)
            .foregroundColor(.black)
            .background(.white)
            .clipShape(.capsule)
    }
}

struct UserInfoTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .tint(.white)
            .transition(.blurReplace)
            .autocorrectionDisabled()
    }
}

extension View {
    func signInButtonStyle() -> some View {
        self.modifier(SignInButtonModifer())
    }
    func emailPasswordTextFieldStyle() -> some View {
        self.modifier(EmailPasswordTextFieldModifier())
    }
    func continueButtonStyle() -> some View {
        self.modifier(ContinueButtonModifier())
    }
    func userInfoTextFieldStyle() -> some View {
        self.modifier(UserInfoTextFieldModifier())
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

extension String {
    var isValidEmail: Bool {
        // This regex is a commonly used pattern for basic email validation.
        // Note: It won't capture every possible valid email address, but it works for most use cases.
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
}

extension Date {
    static func fromComponents(month: Int, day: Int, year: Int) -> Date {
        var components = DateComponents()
        components.month = month
        components.day = day
        components.year = year
        return Calendar.current.date(from: components)!
    }
    static func fromDate(date: Date = Date.startOfDay(), months: Int = 0, days: Int = 0, years: Int = 0) -> Date {
        var components = DateComponents()
        components.month = months
        components.day = days
        components.year = years
        return Calendar.current.date(byAdding: components, to: date)!
    }
    
    static func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: Date())
    }
}
