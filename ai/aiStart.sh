#!/bin/bash

echo "=== Sprawdzanie stanu i uruchamianie stosu AI ==="

# 1. Sprawdzenie i uruchomienie Ollamy
if systemctl is-active --quiet ollama; then
    echo "[OK] Ollama już działa."
else
    echo "[!] Ollama jest wyłączona. Uruchamianie usługi..."
    sudo systemctl start ollama
    
    if systemctl is-active --quiet ollama; then
        echo "[SUKCES] Ollama została pomyślnie uruchomiona."
    else
        echo "[BŁĄD] Nie udało się uruchomić Ollamy."
    fi
fi

# 2. Sprawdzenie i uruchomienie Open WebUI
if pgrep -f "open-webui" > /dev/null; then
    echo "[OK] Open WebUI już działa."
else
    echo "[!] Open WebUI jest wyłączony. Uruchamianie w tle..."
    
    # Uruchomienie w tle na porcie 3000 przez uvx
    nohup env DATA_DIR="$HOME/.open-webui" uvx --python 3.11 open-webui@latest serve --port 3000 > "$HOME/.open-webui/webui.log" 2>&1 &
    
    # Krótka chwila na inicjalizację procesów
    sleep 3
    
    if pgrep -f "open-webui" > /dev/null; then
        echo "[SUKCES] Open WebUI został uruchomiony!"
        echo "🌐 Dostępny pod adresem: http://localhost:3000"
        echo "📄 Logi serwera zapisywane są w: ~/.open-webui/webui.log"
    else
        echo "[BŁĄD] Nie udało się uruchomić Open WebUI. Sprawdź logi w ~/.open-webui/webui.log"
    fi
fi

# 3. Sprawdzenie i uruchomienie n8n (przez PM2)
if pm2 info n8n | grep -q "online"; then
    echo "[OK] n8n już działa."
else
    echo "[!] n8n jest wyłączony. Uruchamianie przez PM2..."
    
    # Uruchomienie n8n w PM2
    pm2 start npx --name "n8n" -- n8n
    
    sleep 2
    
    if pm2 info n8n | grep -q "online"; then
        echo "[SUKCES] n8n został uruchomiony!"
        echo "🌐 Dostępny pod adresem: http://localhost:5678"
    else
        echo "[BŁĄD] Nie udało się uruchomić n8n."
    fi
fi

echo "=== Gotowe! Wszystkie usługi AI i automatyzacje są aktywne. ==="
