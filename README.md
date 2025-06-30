# 🔐 SecureAppRequest

**SecureAppRequest** is a lightweight Swift package that ensures your backend only accepts requests made by **authorized client apps**.

It works by **encrypting your app’s bundle identifier** using a shared AES-256 key and sending it in a custom header. The backend can then **decrypt and verify** the identifier, ensuring the request came from a trusted source.

---

## ✅ Features

- 🔒 AES-256-GCM encryption  
- 📦 Zero-dependency, clean Swift implementation  
- 🔧 Easy developer integration  
- 🧵 Swift Concurrency support  
- 🧰 No SDK bloat  

---

## 📦 Installation (SPM)

Using **Swift Package Manager**:

1. In Xcode, go to **File > Add Packages**
2. Paste the repo URL:

   ```
   https://github.com/SecureAppRequest/SecureAppRequest-Swift
   ```

3. Select the version and add it to your project.

---

## 🛠 Usage

### 1. Add a `.env` file (or use CI secrets)

Create a `.env` file at the root of your app project:

```env
SECURE_APP_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
```

### 2. Set up a shared secureSessionManager

in a SecureSessionManager.swift file

```swift
import Foundation
import SecureAppRequest

class SecureSessionManager {
    static var shared: SecureURLSession!
}
```

### 3. Load the key and initialize the secure session

Use a helper (like [DotEnv](https://github.com/swift-dotenv/swift-dotenv)) to read the `.env` file.

```swift
import SecureAppRequest
import Foundation

// MARK: - App setup (e.g., in AppDelegate or SceneDelegate)

guard let keyString = ProcessInfo.processInfo.environment["SECURE_APP_KEY"] else {
    fatalError("SECURE_APP_KEY environment variable not set.")
}
guard let keyData = keyString.data(using: .utf8), keyData.count == 32 else {
    fatalError("SECURE_APP_KEY must be a 32-byte UTF-8 string.")
}

 do {
     let session = try SecureURLSession(secretKeyData: keyData)
     SecureSessionManager.shared = session
} catch {
        fatalError("Failed to initialize SecureURLSession: \(error)")
}
```

### 4. Send a secure request from anywhere in the app

```swift
func sendSecureRequest() async {
    let urlString = "https://api.example.com/protected"
    guard let url = URL(string: urlString) else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    // ✅ Enable encrypted bundle identifier
    request.wantsEncryptedBundleIdentifier = true

    do {
        let (data, response) = try await secureSession.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Status code: \(httpResponse.statusCode)")
        }

        if let body = String(data: data, encoding: .utf8) {
            print("Response: \(body)")
        }
    } catch {
        print("Request error: \(error)")
    }
}
```

### 5. What happens under the hood?

- Your app's bundle identifier (`Bundle.main.bundleIdentifier`) is **AES-256 encrypted**
- It is sent as a custom HTTP header:

```http
X-App-Auth: <encrypted_payload>
```

- Your backend decrypts it using the same shared key and validates that it matches an expected bundle identifier.

---

## 🧪 Example Server Decryption (Optional)

A very basic server-side decryption pseudocode (e.g., in Node.js, Python, Go) would:

1. Read the `X-App-Auth` header  
2. Decrypt it using the shared key (AES-GCM)  
3. Validate the bundle ID against a whitelist

---

## 👨‍💻 Author

Made by [Avinash96-gthb](https://github.com/Avinash96-gthb)
