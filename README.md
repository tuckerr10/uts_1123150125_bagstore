# 🛍️ BAG STORE — Aplikasi Mobile E-Commerce Tas

> **UTS Mobile Programming**

---

## 📱 Demo Aplikasi

> 🎥 **Video Demo YouTube:** [Klik di sini untuk menonton demo](https://youtu.be/aW3JTUPGSsELINK=_VIDEO_DISINI)

> **Nama : Moh Frendy Aprianto**
> 
> **NIM  : 1123150125**

---

## 📸 Screenshot Aplikasi

| Splash Screen | Login | Register |
|:---:|:---:|:---:|
| <img width="200" src="https://github.com/user-attachments/assets/bcb68eb7-e10f-411f-a303-ffcedb9952ad" /> | <img width="200" src="https://github.com/user-attachments/assets/25a851dd-04b2-4f73-85d8-c65af1bbfc96" /> | <img width="200" src="https://github.com/user-attachments/assets/5543dee0-6dc4-456a-ac17-c39c1508feb8" /> |

| Verifikasi Email | Link Email | Pilih Akun Google | Home Produk |
|:---:|:---:|:---:|:---:|
| <img width="200" src="https://github.com/user-attachments/assets/81f0e020-edaa-4892-8327-23abe228c224" /> | <img width="200" src="https://github.com/user-attachments/assets/0a15a20d-37c5-4636-8c70-5ac6fb5b38fd" /> | <img width="200" src="https://github.com/user-attachments/assets/b5e8f455-84c0-4d3b-956d-0c8145604779" /> | <img width="200" src="https://github.com/user-attachments/assets/ffae9e3a-5b3c-4eca-8742-08282520e474" /> |

| Detail Produk | My Bag (Keranjang) | Order Confirmed |
|:---:|:---:|:---:|
| <img width="200" src="https://github.com/user-attachments/assets/bca24934-3cb4-4de7-96c2-da9e634da199" /> | <img width="200" src="https://github.com/user-attachments/assets/20cde190-89e9-4528-a7be-277edbbafa93" /> | <img width="200" src="https://github.com/user-attachments/assets/00f6319c-b74c-4179-adde-4193a143cbcc" /> |

---

## 📋 Deskripsi Aplikasi

**Bag Store** adalah aplikasi mobile e-commerce berbasis Flutter untuk menjual produk tas premium. Aplikasi ini memiliki fitur autentikasi menggunakan Firebase, data produk dari backend Golang + MySQL, serta fitur keranjang belanja dan pemesanan.

---

## 🛠️ Teknologi yang Digunakan

### Frontend
- **Flutter** (Dart) — Framework mobile cross-platform
- **Firebase Auth** — Autentikasi email/password dan Google Sign-In

### Backend
- **Golang** — REST API server
- **MySQL (XAMPP)** — Database produk dan transaksi
- **Firebase Admin SDK** — Verifikasi token dari Flutter

---

## ⚙️ Fitur Aplikasi

- ✅ Splash Screen animasi
- ✅ Register akun baru dengan email & password
- ✅ Verifikasi email via Firebase
- ✅ Login dengan email & password
- ✅ Login dengan Google (Google Sign-In)
- ✅ Halaman produk dengan grid layout + info stok
- ✅ Detail produk (gambar, nama, harga, deskripsi, stok)
- ✅ Tambah produk ke keranjang (My Bag)
- ✅ Halaman keranjang dengan total pembayaran
- ✅ Konfirmasi pesanan (Order Confirmed)
- ✅ Logout

---

## 🔐 Cara Kerja Autentikasi

```
Flutter App
    │
    ├─ Register/Login → Firebase Auth → dapat ID Token
    │
    └─ Kirim ID Token ke Backend Golang
            │
            └─ Golang verifikasi token via Firebase Admin SDK
                    │
                    └─ Return JWT Token (access_token)
                            │
                            └─ Flutter simpan JWT di Secure Storage
                                    │
                                    └─ JWT dikirim di setiap request API
                                       sebagai Bearer Token
```

1. User register/login di Flutter menggunakan Firebase Auth
2. Firebase mengirim email verifikasi ke user
3. Setelah verified, Flutter mendapat **ID Token** dari Firebase
4. ID Token dikirim ke backend Golang via `POST /v1/auth/verify-token`
5. Golang memverifikasi token menggunakan **Firebase Admin SDK**
6. Backend return **JWT Token** sebagai `access_token`
7. Flutter menyimpan JWT Token di **Secure Storage**
8. Setiap request ke API, JWT Token dikirim sebagai **Bearer Token** di header `Authorization`

### Contoh Header Request dengan JWT
```
Authorization: Bearer <jwt_token>
```

---

## 🌐 Endpoint Backend (Golang)

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/v1/auth/verify-token` | Verifikasi Firebase ID Token |
| GET | `/v1/products` | Ambil semua data produk |

### Contoh Request Verify Token
```json
POST /v1/auth/verify-token
{
  "firebase_token": "eyJhbGciOiJSUzI1NiIs..."
}
```

### Contoh Response Products
```json
{
  "success": true,
  "message": "Berhasil mengambil data produk",
  "data": [
    {
      "id": 1,
      "name": "Tas Kulit Premium",
      "price": 350000,
      "image_url": "https://..."
    }
  ]
}
```

---

## 🗄️ Struktur Database MySQL

### Tabel `products`
```sql
CREATE TABLE products (
  id        INT PRIMARY KEY AUTO_INCREMENT,
  name      VARCHAR(255) NOT NULL,
  price     DECIMAL(10,2) NOT NULL,
  image_url TEXT,
  stock     INT DEFAULT 0,
  description TEXT
);
```

---

## 🚀 Cara Menjalankan Aplikasi

### Prasyarat
- Flutter SDK
- Android Studio + JDK 17+
- XAMPP (Apache + MySQL)
- Golang 1.21+
- Firebase Project

### 1. Clone Repository
```bash
git clone https://github.com/tuckerr10/uts_1123150125_bagstore.git
cd uts_1123150125_bagstore
```

### 2. Install Dependencies Flutter
```bash
flutter pub get
```

### 3. Jalankan Backend Golang (Local)

Clone backend dari repo terpisah:
```bash
git clone https://github.com/tuckerr10/bag_store_backend.git
cd bag_store_backend
```

Tambahkan file `serviceAccountKey.json` dari Firebase Console ke folder tersebut, lalu:
```bash
# Pastikan XAMPP sudah nyala (MySQL aktif)
go run main.go
```
> ⚠️ **Catatan:** Backend berjalan secara lokal. Pastikan XAMPP aktif dan HP berada di jaringan WiFi yang sama dengan laptop. Sesuaikan IP di konfigurasi dengan IP lokal laptop kamu (`ipconfig` → IPv4).

### 4. Jalankan Aplikasi Flutter
```bash
# Pastikan HP tersambung via USB (USB Debugging ON)
# Pastikan HP dan laptop dalam WiFi yang sama
flutter run
```

> ⚠️ **Catatan:** Ganti IP di backend `main.go` dan konfigurasi Flutter sesuai IP lokal laptop kamu (`ipconfig` → IPv4).

---

## 📁 Struktur Project

```
uts_1123150125_bagstore/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart
│   │   │   ├── app_colors.dart
│   │   │   └── app_strings.dart
│   │   ├── routes/
│   │   │   ├── app_router.dart
│   │   │   └── auth_guard.dart
│   │   ├── services/
│   │   │   ├── dio_client.dart
│   │   │   └── secure_storage.dart
│   │   └── theme/
│   │       └── app_theme.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/repositories/
│   │   │   │   └── auth_repository_impl.dart
│   │   │   ├── domain/repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── login_page.dart
│   │   │       │   ├── register_page.dart
│   │   │       │   └── verify_email_page.dart
│   │   │       ├── providers/
│   │   │       │   └── auth_provider.dart
│   │   │       └── widgets/
│   │   │           ├── auth_header.dart
│   │   │           ├── custom_button.dart
│   │   │           ├── custom_text_field.dart
│   │   │           ├── divider_with_text.dart
│   │   │           ├── google_sign_in_button.dart
│   │   │           └── loading_overlay.dart
│   │   └── dashboard/
│   │       ├── data/models/
│   │       │   └── product_model.dart
│   │       └── presentation/
│   │           ├── pages/
│   │           │   ├── cart_page.dart
│   │           │   ├── dashboard_page.dart
│   │           │   └── product_detail_page.dart
│   │           └── providers/
│   │               ├── cart_provider.dart
│   │               └── product_provider.dart
│   ├── splash/presentation/screens/
│   │   └── splash_screen.dart
│   ├── firebase_options.dart
│   └── main.dart
├── android/
│   ├── app/build.gradle.kts
│   ├── build.gradle.kts
│   └── settings.gradle.kts
└── README.md
```

---

## 👨‍💻 Developer

| | |
|---|---|
| **Nama** | Moh Frendy Aprianto |
| **NIM** | 1123150125 |
| **GitHub** | [tuckerr10](https://github.com/tuckerr10) |

---

> 📌 *Dibuat untuk memenuhi tugas UTS mata kuliah Mobile Programming*
