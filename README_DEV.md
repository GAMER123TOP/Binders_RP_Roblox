# Документация для разработчиков

Этот файл предназначен для тех, кто хочет **изменить, дополнить или адаптировать** скрипты под свои нужды.

---

## 📁 Структура репозитория

Binders_RP_Roblox/
├── Zarechensk/
│   ├── Zarechensk_MVD_Macros.ahk
│   ├── SMP_Macros.ahk
│   └── Civilian_Macros.ahk
├── Kemerovo/
│   ├── Kemerovo_MVD_Macros.ahk
│   ├── SMP_Macros.ahk
│   └── Civilian_Macros.ahk
├── Province/
│   ├── Province_MVD_Macros.ahk
│   ├── Province_SMP_Macros.ahk
│   └── Province_Civilian_Macros.ahk
├── README.md
├── README_DEV.md
├── LICENSE
└── LICENSE_RU

---

## 🎮 Файлы для фракций

| Игра | МВД | СМП | Гражданские |
|------|-----|-----|-------------|
| **Зареченск** | `Zarechensk_MVD_Macros.ahk` | `SMP_Macros.ahk` | `Civilian_Macros.ahk` |
| **Кемерово** | `Kemerovo_MVD_Macros.ahk` | `SMP_Macros.ahk` | `Civilian_Macros.ahk` |
| **Провинция** | `Province_MVD_Macros.ahk` | `Province_SMP_Macros.ahk` | `Province_Civilian_Macros.ahk` |

> **Почему у Провинции префикс `Province_`?** > В Провинции используется отдельная клавиша для открытия чата (`U` / `Г`), поэтому все скрипты для неё имеют отдельные названия, чтобы не путаться с другими играми.

---

## ⚙️ Как устроен лаунчер

`Launcher.ahk` — это AutoHotkey-скрипт, который:

1. Показывает интерфейс с выбором игры и фракции
2. Скачивает нужный `.ahk` файл из репозитория
3. Сохраняет его в папку где лежит `Launcher.ahk`
4. Запускает скачанный скрипт

### Принцип работы

- Все скрипты хранятся в одной папке где лежит `Launcher.ahk`
- Лаунчер использует прямые ссылки на `raw`-версии файлов с GitHub
- При выборе фракции скачивается соответствующий файл
- Кэш (скрипты) хранится в папке где лежит `Launcher.ahk` и очищается кнопкой **ОЧИСТИТЬ КЭШ**

---

## 🛠️ Как добавить новую игру

1. Создай текстовые документы
2. Вместо `.txt` напиши `.ahk`:
   - `MVD_Macros.ahk` (или `[Игра]_MVD_Macros.ahk`, если нужен префикс и другие)
3. В лаунчере добавь новый пункт в список игр
4. Обнови ссылки для скачивания в коде лаунчера

---

## ⌨️ Как добавить свою команду в макрос

Открой нужный `.ahk` файл в любом текстовом редакторе.  
Все команды выглядят примерно так:

; ===== НАЗВАНИЕ МАКРОСА =====
Numpad0::
F10::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Send("{Г down}")
    Sleep(30)
    Send("{Г up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("")
    Send("{Enter}")
    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

### Формат:

Горячая_клавиша::
Горячая_клавиша_2::
{
    global StopMacro
    if StopMacro {
        ToolTip("Макрос остановлен!")
        SetTimer(() => ToolTip(), -1500)
        return
    }
    Send("{Г или . down}")
    Sleep(30)
    Send("{Г или . up}")
    Sleep(50)
    Send("{Backspace}")
    Sleep(50)
    PauseWithCheck(300)
    SendText("")
    Send("{Enter}")
    ToolTip("Готово!")
    SetTimer(() => ToolTip(), -1500)
}

### Специальные клавиши:

| Символ | Клавиша |
| --- | --- |
| `^` | Ctrl |
| `+` | Shift |
| `!` | Alt |
| `#` | Win |

---

## 🧪 Как тестировать изменения

1. Установи [AutoHotkey v2](https://www.autohotkey.com/)
2. Открой любой `.ahk` файл в редакторе
3. Внеси изменения и сохрани
4. Запусти файл двойным щелчком и проверь в игре

### Советы по отладке:

* Добавьте `MsgBox` для проверки срабатывания клавиши:
F1::
    MsgBox, Клавиша F1 нажата!
    Send, /me достаёт рацию{Enter}
Return

* Используйте `Sleep()` для добавления задержки между действиями

---

## 📦 Как собрать релиз

1. Убедись, что все скрипты обновлены и протестированы
2. Залей изменения в GitHub
3. Перейди в раздел **Releases**
4. Нажми **Draft a new release**
5. Укажи версию (например, v1.6)
6. Прикрепи `Launcher.ahk`
7. Напиши краткий список изменений (что нового в этой версии)
8. Опубликуй

---

## 📝 Соглашение о версиях

Формат: `v[мажорная].[минорная]`

* **Мажорная** — крупные изменения, новые игры, переработка лаунчера
* **Минорная** — добавление команд, исправление багов, мелкие улучшения

---

## 💡 Как предложить идею

Если у вас есть идея для новой отыгровки, команды или улучшения — поделитесь!

- **Discord:** [gamer123top](https://discord.com/users/gamer123top)
- **Telegram:** [@GAMER123TOPTG](https://t.me/GAMER123TOPTG)
- **Discord сервер студии:** [dsc.gg/cubefusion](https://dsc.gg/cubefusion) → Форум → Идеи

Желательно указать:
- Что вы предлагаете
- Для какой фракции (МВД, СМП, Гражданские)
- Пример команды или сценария (если есть)

---

## 🐛 Как сообщить об ошибке

Если вы нашли баг в процессе разработки, сообщите автору любым удобным способом:

- **Discord:** [gamer123top](https://discord.com/users/gamer123top)
- **Telegram:** [@GAMER123TOPTG](https://t.me/GAMER123TOPTG)
- **Discord сервер студии:** [dsc.gg/cubefusion](https://dsc.gg/cubefusion) → Форум → Баги

Желательно указать:
- Что произошло
- Как воспроизвести
- Версия скрипта и игры
- Скриншот или видео (если есть)

---

## 📄 Лицензия

Проект распространяется под лицензией MIT.

Подробнее: [LICENSE](LICENSE) · [LICENSE_RU](LICENSE_RU)

---

## ⭐ Контакты разработчика

* **Автор:** GAMER123TOP
* **Discord:** [gamer123top](https://discord.com/users/gamer123top)
* **Telegram:** [@GAMER123TOPTG](https://t.me/GAMER123TOPTG)
* **Discord сервер студии:** [dsc.gg/cubefusion](https://dsc.gg/cubefusion)