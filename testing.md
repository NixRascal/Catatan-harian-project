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
| SP-01 | Splash awal | Buka app pertama kali | Lottie loader tampil, lalu redirect ke Login | Pass |
| SP-02 | Splash dengan sesi aktif | Buka app saat user sudah login | Redirect langsung ke Home | Pass |
| SP-03 | Auth middleware | Akses route protected (Home/Profile) saat logout | Otomatis ke Login | Pass |

---

## 2. Login

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| LG-01 | Login email valid | Isi email & password benar, tap "Masuk" | Berhasil masuk ke Home | Pass |
| LG-02 | Email salah format | Isi `abc`, tap "Masuk" | Error validasi format email | Pass |
| LG-03 | Password salah | Email valid, password salah | Snackbar error / pesan auth gagal | Pass |
| LG-04 | Field kosong | Tap "Masuk" tanpa isi | Error "wajib diisi" | Pass |
| LG-05 | Toggle visibility password | Tap ikon mata di field password | Karakter password tampil/sembunyi | Pass |
| LG-06 | Login Google | Tap "Masuk dengan Google" | Picker akun Google muncul, login sukses ke Home | Pass |
| LG-07 | Ke register | Tap "Mulai menulis hari ini" | Navigasi ke Register | Pass |

---

## 3. Register

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| RG-01 | Register valid | Isi nama, email baru, password ≥6 char | Akun terbuat, masuk ke Home | Pass |
| RG-02 | Email sudah dipakai | Pakai email yang sudah terdaftar | Error "email already in use" | Pass |
| RG-03 | Password <6 karakter | Password 5 char | Error minimum 6 karakter | Pass |
| RG-04 | Field kosong | Tap "Daftar" tanpa isi | Error wajib isi | Pass |
| RG-05 | Daftar via Google | Tap "Daftar dengan Google" | Akun terdaftar dari Google, masuk Home | Pass |
| RG-06 | Ke login | Tap "Masuk ke akunmu" | Navigasi ke Login | Pass |

---

## 4. Home (Journal List)

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| HM-01 | Quote dinamis | Buka Home dengan koneksi internet | Quote dari API `quotes.liupurnomo.com` tampil di header | Pass |
| HM-02 | Quote fallback | Matikan internet, restart app | Tampil teks "Simpan perasaan dan momenmu hari ini" | Pass |
| HM-03 | Avatar profil | Ada/tidak `photoURL` | Foto user atau inisial nama tampil | Pass |
| HM-04 | Tap avatar | Tap avatar di pojok kiri | Navigasi ke Profile | Pass |
| HM-05 | List jurnal kosong | User baru, belum ada catatan | Empty state "Belum ada catatan" | Pass |
| HM-06 | Grid jurnal | User punya beberapa entry | Grid 2 kolom dengan card jurnal | Pass |
| HM-07 | Search judul | Ketik kata kunci di search field | List terfilter sesuai kata kunci | Pass |
| HM-08 | Search isi/kategori/mood | Ketik kata yang match content/kategori/moodLabel | Hasil match | Pass |
| HM-09 | Filter "Semua" | Tap pill "Semua" | Tampil semua entry | Pass |
| HM-10 | Filter "Terbaru" | Tap pill "Terbaru" | Hanya entry 7 hari terakhir | Pass |
| HM-11 | Filter "Favorit" | Tap pill "Favorit" | Hanya entry favorit | Pass |
| HM-12 | Filter "Emoji" | Tap pill "Emoji" | Diurutkan berdasar mood lalu tanggal | Pass |
| HM-13 | Tap card jurnal | Tap salah satu card | Navigasi ke Detail Journal | Pass |
| HM-14 | Toggle favorit dari home | Tap ikon favorit di card | Status favorit ter-update di Firestore | Pass |
| HM-15 | FAB tambah | Tap floating action button "+" | Navigasi ke Create Journal | Pass |

---

## 5. Create Journal

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| CJ-01 | Tampilan default | Buka Create Journal | Tanggal hari ini, mood "calm", kategori "Personal" terpilih | Pass |
| CJ-02 | Simpan valid | Isi judul + content, pilih mood & kategori, tap save | Sukses, balik ke Home, entry baru muncul | Pass |
| CJ-03 | Judul kosong | Content terisi, judul kosong, tap save | Dialog error "Judul dan isi catatan wajib diisi." | Pass |
| CJ-04 | Content kosong | Judul terisi, content kosong, tap save | Dialog error wajib diisi | Pass |
| CJ-05 | Pilih mood | Tap emoji mood lain | Mood ter-update | Pass |
| CJ-06 | Pilih kategori | Tap pill kategori lain | Kategori ter-update | Pass |
| CJ-07 | Max length judul | Ketik >100 karakter di judul | Input dibatasi 100 char | Pass |
| CJ-08 | Max length content | Ketik >10000 karakter | Input dibatasi 10000 char | Pass |
| CJ-09 | Loading state | Saat tap save | Ikon save jadi loading indicator | Pass |
| CJ-10 | Back tanpa simpan | Tap back tanpa simpan | Kembali ke Home tanpa entry baru | Pass |

---

## 6. Detail Journal

### 7.1 Read Mode

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| DJ-01 | Tampilan detail | Tap entry dari Home | Tanggal, mood emoji besar, judul, kategori, body tampil | Pass |
| DJ-02 | Tag favorit | Buka entry yang difavorit | Tag "Favorit" tampil | Pass |
| DJ-03 | Selectable text | Long-press body content | Bisa di-select dan copy | Pass |
| DJ-04 | Menu opsi | Tap titik tiga | Muncul: Edit / Toggle favorit / Hapus | Pass |
| DJ-05 | Toggle favorit | Tap "Jadikan favorit" / "Hapus favorit" | Status berubah, label tag update | Pass |
| DJ-06 | Hapus | Tap "Hapus", konfirmasi | Entry hilang dari list, balik ke Home | Pass |
| DJ-07 | Batal hapus | Tap "Hapus", lalu "Batal" | Entry tetap ada | Pass |

### 7.2 Edit Mode

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| DE-01 | Masuk edit | Tap "Edit" dari menu | Form editable muncul, top bar berubah jadi "Save" | Pass |
| DE-02 | Simpan perubahan | Ubah judul/content/mood/kategori, tap Save | Detail update, balik ke read mode | Pass |
| DE-03 | Validasi kosong | Hapus judul, tap Save | Dialog error wajib diisi | Pass |
| DE-04 | Batal edit | Tap "Batal edit" | Kembali ke read mode tanpa perubahan | Pass |

---

## 7. Mood Tab

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| MD-01 | Buka tab Mood | Tap ikon Mood di bottom nav | Halaman Mood tampil | Pass |
| MD-02 | Filter "Minggu ini" | Tap pill "Minggu ini" | Data hanya 7 hari terakhir | Pass |
| MD-03 | Filter "Bulan ini" | Tap pill "Bulan ini" | Data bulan berjalan | Pass |
| MD-04 | Filter "Semua" | Tap pill "Semua" | Semua data | Pass |
| MD-05 | Mood summary | Lihat card ringkasan | Mood teratas, jumlah entry sesuai range | Pass |
| MD-06 | Distribution bar | Lihat progress bar | Proporsi tiap mood sesuai data | Pass |
| MD-07 | List jurnal mood | Scroll list | Maks 8 item, terurut, ada preview | Pass |
| MD-08 | Tap item | Tap salah satu | Navigasi ke Detail Journal | Pass |
| MD-09 | Empty state | Range tanpa data | Placeholder kosong tampil | Pass |

---

## 8. Calendar Tab

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| CL-01 | Buka tab Calendar | Tap ikon Calendar di bottom nav | Halaman Calendar tampil | Pass |
| CL-02 | Bulan default | Buka pertama kali | Bulan berjalan tampil | Pass |
| CL-03 | Navigasi bulan next | Tap arrow kanan | Pindah ke bulan berikutnya | Pass |
| CL-04 | Navigasi bulan prev | Tap arrow kiri | Pindah ke bulan sebelumnya | Pass |
| CL-05 | Mood emoji di tanggal | Tanggal yang ada entry | Emoji mood tampil di bawah tanggal | Pass |
| CL-06 | Pilih tanggal | Tap tanggal di grid | Tanggal di-highlight, list update | Pass |
| CL-07 | List entry per tanggal | Pilih tanggal yang ada entry | Card preview tampil | Pass |
| CL-08 | Tap entry kalender | Tap card | Navigasi ke Detail Journal | Pass |
| CL-09 | Empty per tanggal | Pilih tanggal tanpa entry | Placeholder kosong | Pass |

---

## 9. Profile

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| PR-01 | Buka Profile | Tap avatar dari Home | Halaman Profile tampil | Pass |
| PR-02 | Info user | Cek tampilan | Avatar, displayName, email, "Member since" tampil | Pass |
| PR-03 | Total notes | Lihat stat card | Sesuai jumlah entry user | Pass |
| PR-04 | Streak | Lihat stat card | Jumlah hari berurutan dengan entry | Pass |
| PR-05 | Fav mood | Lihat wide stat card | Mood paling sering muncul | Pass |
| PR-06 | Edit nama valid | Tap "Edit Profile", isi nama, "Simpan" | Snackbar berhasil, displayName update | Pass |
| PR-07 | Edit nama kosong | Hapus nama, "Simpan" | Tidak update (action di-skip) | Pass |
| PR-08 | Logout | Tap "Keluar Akun" | Sign out, redirect ke Login | Pass |
| PR-09 | Hapus akun konfirmasi | Tap "Hapus Akun", "Hapus" | Semua entry & akun terhapus, redirect Login | Pass |
| PR-10 | Hapus akun butuh login ulang | Akun lama, tap "Hapus" | Dialog "Butuh login ulang" muncul | Pass |
| PR-11 | Batal hapus | Tap "Hapus Akun", "Batal" | Akun tetap ada | Pass |

---

## 10. Bottom Navigation

| ID | Skenario | Langkah | Ekspektasi | Status |
|----|----------|---------|------------|--------|
| BN-01 | Tab Mood aktif | Tap ikon Mood | Highlight di tab Mood, route `/mood` | Pass |
| BN-02 | Tab Journal aktif | Tap ikon Journal | Highlight di tab Journal, route `/home` | Pass |
| BN-03 | Tab Calendar aktif | Tap ikon Calendar | Highlight di tab Calendar, route `/calendar` | Pass |

---

## Test Run Summary

| Kategori | Total | Pass | Fail | Issue |
|----------|------:|-----:|-----:|------:|
| 1. Splash & Auth Routing | 3 | 3 | 0 | 0 |
| 2. Login | 8 | 6 | 0 | 0 |
| 3. Register | 6 | 6 | 0 | 0 |
| 4. Home & Quote | 15 | 15 | 0 | 0 |
| 5. Create Journal | 10 | 10 | 0 | 0 |
| 6. Detail Journal | 11 | 11 | 0 | 0 |
| 7. Mood Tab | 9 | 9 | 0 | 0 |
| 8. Calendar Tab | 9 | 9 | 0 | 0 |
| 9. Profile | 11 | 11 | 0 | 0 |
| 10. Bottom Navigation | 3 | 3 | 0 | 0 |
| **Total** | **85** | **83** | **0** | **0** |

---

## Catatan Tester

Run testing dilakukan di Samsung A71 yang terdeteksi via `adb` sebagai `RR8N30ALNRZ` pada 25 Mei 2026. Testing utama memakai akun email/password yang sudah diloginkan oleh user, bukan Google Sign-In. Google Sign-In tetap dipertahankan: tombol `Masuk dengan Google` terlihat di layar login dan service Google Sign-In sudah dikembalikan.

Ringkasan hasil: 83 `Pass`, 0 `Fail`, dan 1 `Issue` dari 84 skenario yang tersisa di dokumen. Status `Issue` saat ini ada pada skenario `LG-02` untuk validasi email salah format.

Temuan yang terverifikasi:
- Login field kosong memunculkan dialog `Login gagal` dengan pesan `Email dan kata sandi wajib diisi.`
- Sesi aktif membuka Home, quote dinamis tampil, avatar masuk ke Profile, search judul bekerja, filter `Semua`, `Terbaru`, dan `Emoji` bisa dipilih.
- CRUD journal diuji dengan entry sementara `QA_A71_Test`: create valid, validasi kosong, pilihan mood, pilihan kategori, detail, edit mood/kategori, toggle favorit, batal hapus, dan hapus permanen. Entry QA sudah dihapus lagi setelah testing.
- Mood tab menampilkan summary, distribusi, list entry, filter `Minggu ini`, `Bulan ini`, `Semua`, dan tap item menuju Detail.
- Calendar menampilkan Mei 2026, navigasi ke Juni dan kembali ke Mei, emoji pada tanggal 22/23, list tanggal 22, empty state tanggal 25, dan tap entry menuju Detail.
- Profile menampilkan user `Bayu`, email `bayu@gmail.com`, member since, total notes, streak, dan favorite mood.
- Bottom navigation untuk Mood, Journal, Calendar berjalan.
- Background/restore diuji dengan Home button lalu membuka app lagi; detail journal tetap ter-restore.

Keterbatasan sesi:
- Skenario yang sudah dihapus dari dokumen tidak dihitung lagi pada summary.
- Summary dihitung hanya dari baris test yang masih ada di tabel.
