# Tisztaszoftver KMS Aktiváló Script (All-in-One)

Indítás (PS):

```
irm "https://raw.githubusercontent.com/Rzoltan22/Tisztaszoftver_aktivalas/refs/heads/main/Tisztaszoftver_aktivalas.cmd" -OutFile "$env:TEMP\aktivator.cmd"; & "$env:TEMP\aktivator.cmd"
```

Ez egy menüvezérelt, automatizált program Windows operációs rendszerek és Microsoft Office irodai csomagok legális, intézményi aktiválásához a központi `kms.edu.hu` szerveren keresztül.

## 📋 Mit csinál?

A script egy interaktív felületen teszi lehetővé a különböző Microsoft termékek aktiválását anélkül, hogy a felhasználónak manuálisan kellene termékkulcsokat keresgélnie vagy parancsokat gépelnie.

### Támogatott termékek és verziók:
* **Windows:**
    * Windows 10 / 11 Pro
    * Windows 10 / 11 Enterprise
    * Windows Server 2016 Standard
    * Windows Server 2019 Standard
    * Windows Server 2022 Standard
* **Microsoft Office:**
    * Office 2016 (32-bit és 64-bit)
    * Office 2019 (32-bit és 64-bit)
    * Office 2021 (32-bit és 64-bit)

---

## ⚙️ Hogyan csinálja? (Működési elv)

A script több szintű automatizálást és hibakezelést tartalmaz a háttérben:

1.  **Automatikus Rendszergazdai Jogosultság (UAC):** Indításkor ellenőrzi a jogosultságokat. Ha nem rendszergazdaként indították, automatikusan feldobja az UAC ablakot a szükséges jogosultságok igényléséhez.
2.  **Beépített GVLK Kulcsok:** Tartalmazza az összes hivatalos Microsoft KMS kliens kulcsot, így nincs szükség kézi kulcsmásolásra.
3.  **Verzióellenőrzés (Office):** Az Office aktiválása előtt teszteli, hogy a kiválasztott verzió kulcsa megegyezik-e a gépre telepített kiadással. Ha nem (pl. Office 2016-ot választottál, de 2019 van a gépen), a script detektálja a `0xC004F069 (SKU not found)` hibát, megszakítja a folyamatot, és hibaüzenettel visszadob a menübe a végtelen ciklus helyett.
4.  **Hibatűrő Aktiválási Hurok (Loop):** Mivel iskolaidőben a központi hálózati szerver (`kms.edu.hu`) gyakran túlterhelt, a Windows/Office sokszor `0xC004F074` hibával leállna. Ez a script **addig próbálkozik automatikusan 5 másodperces szünetekkel, amíg az aktiválás sikeres nem lesz**.

---

## 🚀 Hogyan kell használni?

A script használata rendkívül egyszerű és mindössze néhány lépésből áll:

1.  **Fájl futtatása:** Vagy letöltöd a .cmd fájlt és simán futtatod vagy a fent található paracsal powershell-ből indítható
2.  **Menüpont kiválasztása:** A megjelenő listából válaszd ki a számodra szükséges opciót (például ha Windows 11 Pro-t szeretnél aktiválni, üsd be az `1`-es számot, ha 64 bites Office 2019-et, akkor a `8`-ast).
3.  **Indítás:** Nyomj egy `Enter` gombot.
4.  **Folyamat megvárása:** * A program eltávolítja a régi kulcsmaradványokat, regisztrálja az újat, majd megkísérli elérni a szervert.
      Ha a szerver túlterhelt, látni fogod a piros figyelmeztetést és a visszaszámlálót. **Ne zárd be az ablakot**, a script magától újra fog próbálkozni.
5.  **Befejezés:** Amint a szerver válaszol, megjelenik a zöld **`SIKERES AKTIVALAS!`** üzenet. Nyomj meg egy tetszőleges gombot a főmenübe való visszatéréshez.
6.  **Kilépés:** A főmenüben a `0` gomb megnyomásával, majd Enterrel tudsz biztonságosan kilépni a programból.

