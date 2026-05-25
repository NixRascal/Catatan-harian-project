# Functional Testing — Daily Journal App

Dokumen ini berisi skenario pengujian fungsional untuk seluruh fitur aplikasi.
Lingkungan: emulator Android / device fisik. Versi: `1.0.0+1`.

Status hasil:
- ✅ Pass — sesuai ekspektasi
- ❌ Fail — tidak sesuai
- ⚠️ Issue — pass dengan catatan

---

## 1. Splash & Auth Routing

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| SP-01 | Splash awal | Buka app pertama kali | Lottie loader tampil, lalu redirect ke Login | |
| SP-02 | Splash dengan sesi aktif | Buka app saat user sudah login | Redirect langsung ke Home | |
| SP-03 | Auth middleware | Akses route protected (Home/Profile) saat logout | Otomatis ke Login | |

---

## 2. Login

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| LG-01 | Login email valid | Isi email & password benar, tap "Masuk" | Berhasil masuk ke Home | |
| LG-02 | Email salah format | Isi `abc`, tap "Masuk" | Error validasi format email | |
| LG-03 | Password salah | Email valid, password salah | Snackbar error / pesan auth gagal | |
| LG-04 | Field kosong | Tap "Masuk" tanpa isi | Error "wajib diisi" | |
| LG-05 | Toggle visibility password | Tap ikon mata di field password | Karakter password tampil/sembunyi | |
| LG-06 | Lupa sandi | Tap "Lupa sandi?" | Navigasi ke Forgot Password | |
| LG-07 | Login Google | Tap "Masuk dengan Google" | Picker akun Google muncul, login sukses ke Home | |
| LG-08 | Ke register | Tap "Mulai menulis hari ini" | Navigasi ke Register | |

---

## 3. Register

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| RG-01 | Register valid | Isi nama, email baru, password ≥6 char | Akun terbuat, masuk ke Home | |
| RG-02 | Email sudah dipakai | Pakai email yang sudah terdaftar | Error "email already in use" | |
| RG-03 | Password <6 karakter | Password 5 char | Error minimum 6 karakter | |
| RG-04 | Field kosong | Tap "Daftar" tanpa isi | Error wajib isi | |
| RG-05 | Daftar via Google | Tap "Daftar dengan Google" | Akun terdaftar dari Google, masuk Home | |
| RG-06 | Ke login | Tap "Masuk ke akunmu" | Navigasi ke Login | |

---

## 4. Forgot Password & OTP Reset

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| FP-01 | Kirim reset email valid | Isi email terdaftar, tap "Kirim Kode" | Navigasi ke OTP Reset, email terkirim | |
| FP-02 | Email tidak terdaftar | Email random, tap "Kirim Kode" | Error / pesan email tidak ditemukan | |
| FP-03 | Kembali ke login | Tap "Kembali ke Login" | Navigasi ke Login | |
| OT-01 | Tampilan OTP | Tiba di OTP Reset | Email tujuan tampil, info inbox tampil | |
| OT-02 | Kembali login dari OTP | Tap "Kembali ke Login" | Navigasi ke Login, stack dibersihkan | |

---

## 5. Home (Journal List)

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| HM-01 | Quote dinamis | Buka Home dengan koneksi internet | Quote dari API `quotes.liupurnomo.com` tampil di header | |
| HM-02 | Quote fallback | Matikan internet, restart app | Tampil teks "Simpan perasaan dan momenmu hari ini" | |
| HM-03 | Avatar profil | Ada/tidak `photoURL` | Foto user atau inisial nama tampil | |
| HM-04 | Tap avatar | Tap avatar di pojok kiri | Navigasi ke Profile | |
| HM-05 | List jurnal kosong | User baru, belum ada catatan | Empty state "Belum ada catatan" | |
| HM-06 | Grid jurnal | User punya beberapa entry | Grid 2 kolom dengan card jurnal | |
| HM-07 | Search judul | Ketik kata kunci di search field | List terfilter sesuai kata kunci | |
| HM-08 | Search isi/kategori/mood | Ketik kata yang match content/kategori/moodLabel | Hasil match | |
| HM-09 | Filter "Semua" | Tap pill "Semua" | Tampil semua entry | |
| HM-10 | Filter "Terbaru" | Tap pill "Terbaru" | Hanya entry 7 hari terakhir | |
| HM-11 | Filter "Favorit" | Tap pill "Favorit" | Hanya entry favorit | |
| HM-12 | Filter "Emoji" | Tap pill "Emoji" | Diurutkan berdasar mood lalu tanggal | |
| HM-13 | Tap card jurnal | Tap salah satu card | Navigasi ke Detail Journal | |
| HM-14 | Toggle favorit dari home | Tap ikon favorit di card | Status favorit ter-update di Firestore | |
| HM-15 | FAB tambah | Tap floating action button "+" | Navigasi ke Create Journal | |

---

## 6. Create Journal

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| CJ-01 | Tampilan default | Buka Create Journal | Tanggal hari ini, mood "calm", kategori "Personal" terpilih | |
| CJ-02 | Simpan valid | Isi judul + content, pilih mood & kategori, tap save | Sukses, balik ke Home, entry baru muncul | |
| CJ-03 | Judul kosong | Content terisi, judul kosong, tap save | Dialog error "Judul dan isi catatan wajib diisi." | |
| CJ-04 | Content kosong | Judul terisi, content kosong, tap save | Dialog error wajib diisi | |
| CJ-05 | Pilih mood | Tap emoji mood lain | Mood ter-update | |
| CJ-06 | Pilih kategori | Tap pill kategori lain | Kategori ter-update | |
| CJ-07 | Max length judul | Ketik >100 karakter di judul | Input dibatasi 100 char | |
| CJ-08 | Max length content | Ketik >10000 karakter | Input dibatasi 10000 char | |
| CJ-09 | Loading state | Saat tap save | Ikon save jadi loading indicator | |
| CJ-10 | Back tanpa simpan | Tap back tanpa simpan | Kembali ke Home tanpa entry baru | |

---

## 7. Detail Journal

### 7.1 Read Mode

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| DJ-01 | Tampilan detail | Tap entry dari Home | Tanggal, mood emoji besar, judul, kategori, body tampil | |
| DJ-02 | Tag favorit | Buka entry yang difavorit | Tag "Favorit" tampil | |
| DJ-03 | Selectable text | Long-press body content | Bisa di-select dan copy | |
| DJ-04 | Menu opsi | Tap titik tiga | Muncul: Edit / Toggle favorit / Hapus | |
| DJ-05 | Toggle favorit | Tap "Jadikan favorit" / "Hapus favorit" | Status berubah, label tag update | |
| DJ-06 | Hapus | Tap "Hapus", konfirmasi | Entry hilang dari list, balik ke Home | |
| DJ-07 | Batal hapus | Tap "Hapus", lalu "Batal" | Entry tetap ada | |

### 7.2 Edit Mode

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| DE-01 | Masuk edit | Tap "Edit" dari menu | Form editable muncul, top bar berubah jadi "Save" | |
| DE-02 | Simpan perubahan | Ubah judul/content/mood/kategori, tap Save | Detail update, balik ke read mode | |
| DE-03 | Validasi kosong | Hapus judul, tap Save | Dialog error wajib diisi | |
| DE-04 | Batal edit | Tap "Batal edit" | Kembali ke read mode tanpa perubahan | |

---

## 8. Mood Tab

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| MD-01 | Buka tab Mood | Tap ikon Mood di bottom nav | Halaman Mood tampil | |
| MD-02 | Filter "Minggu ini" | Tap pill "Minggu ini" | Data hanya 7 hari terakhir | |
| MD-03 | Filter "Bulan ini" | Tap pill "Bulan ini" | Data bulan berjalan | |
| MD-04 | Filter "Semua" | Tap pill "Semua" | Semua data | |
| MD-05 | Mood summary | Lihat card ringkasan | Mood teratas, jumlah entry sesuai range | |
| MD-06 | Distribution bar | Lihat progress bar | Proporsi tiap mood sesuai data | |
| MD-07 | List jurnal mood | Scroll list | Maks 8 item, terurut, ada preview | |
| MD-08 | Tap item | Tap salah satu | Navigasi ke Detail Journal | |
| MD-09 | Empty state | Range tanpa data | Placeholder kosong tampil | |

---

## 9. Calendar Tab

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| CL-01 | Buka tab Calendar | Tap ikon Calendar di bottom nav | Halaman Calendar tampil | |
| CL-02 | Bulan default | Buka pertama kali | Bulan berjalan tampil | |
| CL-03 | Navigasi bulan next | Tap arrow kanan | Pindah ke bulan berikutnya | |
| CL-04 | Navigasi bulan prev | Tap arrow kiri | Pindah ke bulan sebelumnya | |
| CL-05 | Mood emoji di tanggal | Tanggal yang ada entry | Emoji mood tampil di bawah tanggal | |
| CL-06 | Pilih tanggal | Tap tanggal di grid | Tanggal di-highlight, list update | |
| CL-07 | List entry per tanggal | Pilih tanggal yang ada entry | Card preview tampil | |
| CL-08 | Tap entry kalender | Tap card | Navigasi ke Detail Journal | |
| CL-09 | Empty per tanggal | Pilih tanggal tanpa entry | Placeholder kosong | |

---

## 10. Profile

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| PR-01 | Buka Profile | Tap avatar dari Home | Halaman Profile tampil | |
| PR-02 | Info user | Cek tampilan | Avatar, displayName, email, "Member since" tampil | |
| PR-03 | Total notes | Lihat stat card | Sesuai jumlah entry user | |
| PR-04 | Streak | Lihat stat card | Jumlah hari berurutan dengan entry | |
| PR-05 | Fav mood | Lihat wide stat card | Mood paling sering muncul | |
| PR-06 | Edit nama valid | Tap "Edit Profile", isi nama, "Simpan" | Snackbar berhasil, displayName update | |
| PR-07 | Edit nama kosong | Hapus nama, "Simpan" | Tidak update (action di-skip) | |
| PR-08 | Logout | Tap "Keluar Akun" | Sign out, redirect ke Login | |
| PR-09 | Hapus akun konfirmasi | Tap "Hapus Akun", "Hapus" | Semua entry & akun terhapus, redirect Login | |
| PR-10 | Hapus akun butuh login ulang | Akun lama, tap "Hapus" | Dialog "Butuh login ulang" muncul | |
| PR-11 | Batal hapus | Tap "Hapus Akun", "Batal" | Akun tetap ada | |

---

## 11. Bottom Navigation

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| BN-01 | Tab Mood aktif | Tap ikon Mood | Highlight di tab Mood, route `/mood` | |
| BN-02 | Tab Journal aktif | Tap ikon Journal | Highlight di tab Journal, route `/home` | |
| BN-03 | Tab Calendar aktif | Tap ikon Calendar | Highlight di tab Calendar, route `/calendar` | |

---

## 12. Integrasi & Edge Case

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| EC-01 | Offline create | Matikan internet, buat entry | Pesan error / queue offline (cek behavior Firestore) | |
| EC-02 | Offline list | Buka Home tanpa internet | Cache Firestore tampil (jika ada) | |
| EC-03 | Multi-user isolasi | Login user A buat entry, logout, login user B | User B tidak melihat entry user A | |
| EC-04 | Backgrounding app | Tinggalkan app, kembali | State tetap (filter, search, tab) | |
| EC-05 | Rotate / resize | Putar device atau resize window | Layout responsif, max width 430pt di desktop | |
| EC-06 | Quote API timeout | Sleep 10s di network throttle | Setelah 8s timeout, fallback teks tampil | |

---

## Test Run Summary

| Kategori | Total | Pass | Fail | Issue |
|----------|------:|-----:|-----:|------:|
| Auth (Splash/Login/Register/Forgot/OTP) | 19 | | | |
| Home & Quote | 15 | | | |
| Create Journal | 10 | | | |
| Detail Journal | 11 | | | |
| Mood | 9 | | | |
| Calendar | 9 | | | |
| Profile | 11 | | | |
| Bottom Nav | 3 | | | |
| Edge Case | 6 | | | |
| **Total** | **93** | | | |

---

## Catatan Tester

> Tulis temuan, bug, atau saran perbaikan di sini.
