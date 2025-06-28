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
   https://github.com/your-username/SecureAppRequest-Swift
   ```

3. Select the version and add it to your project.

---

## 🛠 Usage

### 1. Add a `.env` file (or use CI secrets)

Create a `.env` file at the root of your app project:

```env
SECURE_APP_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
```

### 2. Load the key from your environment

Use a helper (like [DotEnv](https://github.com/swift-dotenv/swift-dotenv)) to read the `.env` file.

```swift
import SecureAppRequest
import Foundation

// Load environment variable
let key = ProcessInfo.processInfo.environment["SECURE_APP_KEY"]!
```

### 3. Make a secure request

```swift
let secureSession = try SecureURLSession(encryptionKey: key)

let request = URLRequest(url: URL(string: "https://api.example.com/protected")!)

let (data, response) = try await secureSession.data(for: request)

if let httpResponse = response as? HTTPURLResponse {
    print("Status code: \(httpResponse.statusCode)")
}

print("Response body: \(String(data: data, encoding: .utf8) ?? "")")
```

### 4. What happens under the hood?

- Your app's bundle identifier (`Bundle.main.bundleIdentifier`) is **AES-256 encrypted**
- It is added to the request as a custom HTTP header:

```http
X-App-Auth: <encrypted_payload>
```

- The server can **decrypt this** using the same shared key and validate that the request originated from your app.

---

## 👨‍💻 Author

Made by Avinash96-gthb

---
