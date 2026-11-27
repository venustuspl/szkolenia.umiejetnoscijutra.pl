#!/bin/bash

# Funkcje do restartowania poszczególnych usług

restart_ollama() {
    echo "🔄 Restartowanie Ollamy..."
    sudo systemctl restart ollama
    if systemctl is-active --quiet ollama; then
        echo "[SUKCES] Ollama została pomyślnie zrestartowana."
    else
        echo "[BŁĄD] Nie udało się zrestartować Ollamy."
    fi
}

restart_openwebui() {
    echo "🔄 Restartowanie Open WebUI..."
    pkill -f "open-webui"
    sleep 2
    
    nohup env DATA_DIR="$HOME/.open-webui" uvx --python 3.11 open-webui@latest serve --port 3000 > "$HOME/.open-webui/webui.log" 2>&1 &
    sleep 3
    
    if pgrep -f "open-webui" > /dev/null; then
        echo "[SUKCES] Open WebUI został pomyślnie zrestartowany!"
    else
        echo "[BŁĄD] Nie udało się uruchomić Open WebUI. Sprawdź logi w ~/.open-webui/webui.log"
    fi
}

restart_n8n() {
    echo "🔄 Restartowanie n8n..."
    pm2 restart n8n > /dev/null 2>&1
    
    # Jeśli n8n nie był w ogóle zarejestrowany w PM2, uruchom go
    if ! pm2 info n8n | grep -q "online"; then
        pm2 start npx --name "n8n" -- n8n > /dev/null 2>&1
    fi
    
    sleep 2
    
    if pm2 info n8n | grep -q "online"; then
        echo "[SUKCES] n8n został pomyślnie zrestartowany!"
    else
        echo "[BŁĄD] Nie udało się zrestartować n8n."
    fi
}

# Walidacja argumentu
PARAM="$1"

if [ -z "$PARAM" ]; then
    echo "❌ Błąd: Nie podano parametru!"
    echo "Użycie: $0 [opcje]"
    echo "  o   - restart Ollamy"
    echo "  w   - restart Open WebUI"
    echo "  n   - restart n8n"
    echo "Przykłady: $0 o, $0 w, $0 n, $0 own"
    exit 1
fi

echo "=== Restartowanie wybranych usług AI ==="

# Sprawdzanie poszczególnych liter w przekazanym parametrze
[[ "$PARAM" == *o* ]] && restart_ollama
[[ "$PARAM" == *w* ]] && restart_openwebui
[[ "$PARAM" == *n* ]] && restart_n8n

echo "=== Gotowe! ==="
