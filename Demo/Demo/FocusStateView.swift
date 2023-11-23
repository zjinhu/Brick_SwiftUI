import SwiftUI
import BrickKit
#if os(iOS)
struct FocusStateView: View {

    enum Field: Hashable {
        case username
        case password
    }

    @State private var username = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    var body: some View {
        Form{
            TextField("Username", text: $username)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }

            SecureField("Password", text: $password)
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
                .onSubmit {
                    signIn()
                }

            Button("Sign In") {
                signIn()
            }
        }
        .onAppear {
            focusedField = .username
        }
        .ss.tabBar(.hidden)
    }

    private func signIn() {
        if username.isEmpty {
            focusedField = .username
        } else if password.isEmpty {
            focusedField = .password
        } else {
            focusedField = nil
            print(username, password)
        }
    }
}
#endif
