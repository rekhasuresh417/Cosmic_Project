import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var isAuthenticated = false

    var body: some View {
        VStack {
            if isAuthenticated {
                HealthMetricsView()
            } else {
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        handleAuthorization(result: authResults)
                    case .failure(let error):
                        handleAuthorizationError(error: error)
                    }
                }
                .frame(width: 280, height: 45)
                .padding()
            }
        }
    }

    private func handleAuthorization(result: ASAuthorization) {
        switch result.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            print("User ID: \(appleIDCredential.user)")
            print("Full Name: \(String(describing: appleIDCredential.fullName))")
            print("Email: \(String(describing: appleIDCredential.email))")
            isAuthenticated = true
            
        default:
            break
        }
    }
    
    private func handleAuthorizationError(error: Error) {
        print("Authorization failed: \(error.localizedDescription)")
    }
}

struct ContentView: View {
    var body: some View {
        LoginView()
    }
}


// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}


