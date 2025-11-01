[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/VcFknM5q)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=21330973&assignment_repo_type=AssignmentRepo)
# Flutter: Geo Journal

## Cel
Stwórz podstawową aplikację w **Flutter (Dart)** z **natywną funkcją** oraz **komunikacją z API**, zawierającą **3–4 widoki**.

## Zakres i wymagania funkcjonalne
- **Natywna funkcja (min. 1):** wybierz i uzasadnij (np. lokalizacja GPS, aparat/kamera, udostępnianie/clipboard, czujniki).
- **API (min. 1 endpoint):** odczyt listy wpisów lub zapis nowego.
- **Widoki (3–4):**
  1. **Mapa/Lista wpisów** (pin/pozycja lub lista z datą i miejscem).
  2. **Szczegóły wpisu** (opis, zdjęcie/lokalizacja, akcje).
  3. **Dodaj wpis** (formularz: tytuł, opis, przycisk „pobierz lokalizację” **lub** „zrób zdjęcie”).
  4. *(Opcjonalnie)* **Ustawienia** (np. motyw jasny/ciemny).
- **Nawigacja:** przejścia między widokami z przekazaniem identyfikatora.
- **UX:** komunikaty o błędach, pusty stan, stany ładowania.


## Testowanie lokalne (w trakcie developmentu)
- Uruchom na **emulatorze/urządzeniu**.
- Pokaż: dodanie wpisu z **natywną funkcją** (GPS/zdjęcie), pojawienie się na liście/mapie.
- Pokaż komunikację z **API** (pobranie/zapis), zachowanie bez internetu/bez uprawnień.

## Definition of Done (DoD)
- [+] 3–4 widoki, kompletna nawigacja.
<details>
  <summary>Screensgots</summary>
  ![](https://media.discordapp.net/attachments/293098662962135040/1434203024577790072/Screenshot_20251101-162629.png?ex=69077927&is=690627a7&hm=59bcfcc67dade5eb519de49964c5f8b2e8a9503c9cac4a9435a2056ab152f294&=&format=webp&quality=lossless&width=389&height=873)

  ![](https://media.discordapp.net/attachments/293098662962135040/1434203023588065290/Screenshot_20251101-162726.png?ex=69077927&is=690627a7&hm=5b89412eac4399fd96defa5f6ab86a9fdf283a06c199fe8273de3f8c40b6a5de&=&format=webp&quality=lossless&width=389&height=873)

  ![](https://media.discordapp.net/attachments/293098662962135040/1434203024955543663/Screenshot_20251101-162640.png?ex=69077927&is=690627a7&hm=2dbba973a5692d3dde22c4502b24b2ecc6ff2aa928e91df52c1c4d6833d7445a&=&format=webp&quality=lossless&width=389&height=873)

  ![](https://media.discordapp.net/attachments/293098662962135040/1434203024192180317/Screenshot_20251101-162708.png?ex=69077927&is=690627a7&hm=65c5e5684b6d67d7eaf3d9686c4854e0782f9256209b561eefebd4cc51031333&=&format=webp&quality=lossless&width=389&height=873)
</details>

- [+] Co najmniej 1 **natywna funkcja**. 
**GPS + Kamera**
- [+] Co najmniej 1 operacja **API** (GET/POST).
**GET /journal_entries - Fetch journal entries from MockAPI**
**POST /journal_entries - Create new journal entries**
**DELETE /journal_entries/:id - Remove entries**
- [+] Stany: ładowanie, błąd, pusty.
- [+] `README.md`, zrzuty ekranów, min. 3 commity.

