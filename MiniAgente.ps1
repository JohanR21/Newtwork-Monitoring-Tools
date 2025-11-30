# Bucle Infinito: El script nunca muere hasta que presiones Ctrl + C
while ($true) {
    
    # 1. Limpiar pantalla en cada ciclo para efecto "video"
    Clear-Host

    # 2. Definir Umbrales
    $LimiteRAM = 80
    $LimiteDisco = 90

    # Obtener fecha actual
    $Fecha = Get-Date -Format "HH:mm:ss"
    
    Write-Host "--- MONITOR EN VIVO [$Fecha] ---" -ForegroundColor Cyan
    Write-Host "    (Presiona Ctrl + C para salir)" -ForegroundColor Gray
    Write-Host "----------------------------------" -ForegroundColor Cyan

    # 3. Medir RAM
    $OS = Get-CimInstance Win32_OperatingSystem
    $Total = $OS.TotalVisibleMemorySize
    $Free = $OS.FreePhysicalMemory
    $Usado = $Total - $Free
    $PorcentajeRAM = [Math]::Round(($Usado / $Total) * 100, 2)

    Write-Host "[RAM] Uso Actual: $PorcentajeRAM%"

    # 4. Medir Disco C:
    $Disco = Get-PSDrive C
    $UsadoDisco = $Disco.Used
    $TotalDisco = $Disco.Used + $Disco.Free
    $PorcentajeDisco = [Math]::Round(($UsadoDisco / $TotalDisco) * 100, 2)

    Write-Host "[DISCO C:] Uso Actual: $PorcentajeDisco%"

    Write-Host "----------------------------------" -ForegroundColor Cyan
    Write-Host "--- ESTADO DE ALERTAS ---" -ForegroundColor Cyan

    # 5. Logica de Alertas
    if ($PorcentajeDisco -ge $LimiteDisco) {
        Write-Host "[ALERTA] El disco se esta llenando." -ForegroundColor Red -BackgroundColor Black
    } else {
        Write-Host "[OK] Disco estable." -ForegroundColor Green
    }

    if ($PorcentajeRAM -ge $LimiteRAM) {
        Write-Host "[ALERTA] La RAM esta saturada." -ForegroundColor Red -BackgroundColor Black
    } else {
        Write-Host "[OK] RAM estable." -ForegroundColor Green
    }

    Write-Host "----------------------------------" -ForegroundColor Cyan
    
    # 6. EL DESCANSÓ (El ritmo cardiaco)
    # Espera 3 segundos antes de volver a medir.
    # Sin esto, tu CPU se quemaria recalculando mil veces por segundo.
    Start-Sleep -Seconds 3
}