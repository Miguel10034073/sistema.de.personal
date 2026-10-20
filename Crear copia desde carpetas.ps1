# Crea una copia de seguridad del expediente (.json) a partir de las carpetas de los trabajadores.
# Incluye la estructura de carpetas, el indice de documentos, cada documento en base64 y los datos
# de las hojas de vida (si se indica un archivo de datos). Se usa para la primera carga o para
# volver a armar la copia desde las carpetas.
#
# Sin -Carpeta pide elegir la carpeta de los trabajadores. Antes de escribir muestra que se va a copiar
# y pide confirmacion (-Confirmar la omite).
#
# Uso: powershell -ExecutionPolicy Bypass -File "Crear copia desde carpetas.ps1" [-Carpeta <ruta>] [-Datos <datos.json>] [-Salida <archivo.json>] [-Limite N] [-Compania <nombre>] [-Confirmar]
# La copia queda en "Copias de seguridad\<Compania>\", la carpeta que esta al lado de la de la pagina
# ("007. Sistema de personal\Copias de seguridad"). Sin -Compania pregunta a cual compania pertenece.
param(
  [string]$Carpeta,
  [string]$Datos,
  [string]$Salida,
  [int]$Limite = 0,
  [string]$Compania,
  [switch]$Confirmar
)

$ErrorActionPreference = 'Stop'
$App = $PSScriptRoot                                       # ...\007. Sistema de personal\Expediente laboral
$raizCopias = Join-Path (Split-Path $App -Parent) 'Copias de seguridad'   # al lado de la carpeta de la pagina
if (-not $Carpeta) {
  # Ya no se toma sola la carpeta de arriba: ahi hay otros proyectos (nomina, DIAN...) que no son del expediente.
  Add-Type -AssemblyName System.Windows.Forms
  $dueno = New-Object System.Windows.Forms.Form -Property @{ TopMost = $true }
  $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
  $dlg.Description = 'Elija la carpeta que contiene los grupos de trabajadores (001. Palma, 002. Aprendiz SENA...)'
  $dlg.ShowNewFolderButton = $false
  $ok = $dlg.ShowDialog($dueno) -eq [System.Windows.Forms.DialogResult]::OK
  $dueno.Dispose()
  if (-not $ok) { Write-Host 'Cancelado. No se creo ninguna copia.'; exit 1 }
  $Carpeta = $dlg.SelectedPath
}
$Carpeta = [System.IO.Path]::GetFullPath($Carpeta)
if (-not (Test-Path -LiteralPath $Carpeta -PathType Container)) { throw "No existe la carpeta: $Carpeta" }
$AppFull = [System.IO.Path]::GetFullPath($App).TrimEnd('\')
$CopiasFull = [System.IO.Path]::GetFullPath($raizCopias).TrimEnd('\')
$Elegida = $Carpeta.TrimEnd('\')
$dentro = { param($a, $b) $a -ieq $b -or $a.StartsWith($b + '\', [System.StringComparison]::OrdinalIgnoreCase) }
# No sirve la carpeta de la pagina, la de copias, ni una que las contenga (por ejemplo "007. Sistema de personal")
if ((& $dentro $Elegida $AppFull) -or (& $dentro $Elegida $CopiasFull) -or (& $dentro $AppFull $Elegida) -or (& $dentro $CopiasFull $Elegida)) {
  throw 'Elija la carpeta de los trabajadores, no la del sistema de personal ni la de copias de seguridad.'
}
$AppNombre = Split-Path $App -Leaf
if (-not $Salida) {
  # Cada compania tiene su subcarpeta de copias (por ejemplo "Copias de seguridad\Mindala")
  if (-not $Compania) {
    $existentes = @(Get-ChildItem -LiteralPath $raizCopias -Directory -ErrorAction SilentlyContinue | Sort-Object Name | ForEach-Object { $_.Name })
    Write-Host 'Companias (subcarpetas de "Copias de seguridad"):'
    for ($i = 0; $i -lt $existentes.Count; $i++) { Write-Host ('  {0}. {1}' -f ($i + 1), $existentes[$i]) }
    $r = Read-Host 'Escriba el numero de la compania, o el nombre de una nueva'
    if ($r -match '^\d+$' -and [int]$r -ge 1 -and [int]$r -le $existentes.Count) { $Compania = $existentes[[int]$r - 1] } else { $Compania = "$r" }
  }
  $Compania = (($Compania -replace '[\\/:*?"<>|]', ' ') -replace '\s+', ' ').Trim()
  if (-not $Compania) { Write-Host 'Cancelado: falta la compania. No se creo ninguna copia.'; exit 1 }
  $dirCopias = Join-Path $raizCopias $Compania
  [void][System.IO.Directory]::CreateDirectory($dirCopias)
  $Salida = Join-Path $dirCopias ('Expediente ' + $Compania + ' ' + (Get-Date -Format 'yyyy-MM-dd HHmm') + ' desde carpetas.json')
}

$Epoch = New-Object DateTime(1970, 1, 1, 0, 0, 0, [DateTimeKind]::Utc)
$Tipos = @{ '.pdf' = 'application/pdf'; '.jpg' = 'image/jpeg'; '.jpeg' = 'image/jpeg'; '.png' = 'image/png'; '.gif' = 'image/gif'; '.webp' = 'image/webp';
  '.txt' = 'text/plain'; '.csv' = 'text/csv'; '.zip' = 'application/zip';
  '.docx' = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
  '.xlsx' = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }

function J([string]$s) {
  $sb = New-Object System.Text.StringBuilder ($s.Length + 2)
  [void]$sb.Append('"')
  foreach ($c in $s.ToCharArray()) {
    if ($c -eq '"') { [void]$sb.Append('\"') }
    elseif ($c -eq '\') { [void]$sb.Append('\\') }
    elseif ([int]$c -lt 32) { [void]$sb.Append(('\u{0:x4}' -f [int]$c)) }
    else { [void]$sb.Append($c) }
  }
  [void]$sb.Append('"')
  return $sb.ToString()
}

# 1. Recorrer carpetas y documentos
$n = $Carpeta.Length + 1
$carpetas = New-Object System.Collections.Generic.List[string]
$archivos = New-Object System.Collections.Generic.List[object]
$di = New-Object System.IO.DirectoryInfo($Carpeta)
foreach ($f in $di.EnumerateFileSystemInfos('*', [System.IO.SearchOption]::AllDirectories)) {
  $rel = $f.FullName.Substring($n).Replace('\', '/')
  if ($rel -eq $AppNombre -or $rel.StartsWith($AppNombre + '/')) { continue }
  if ($rel.StartsWith('.') -or $rel.Contains('/.')) { continue }
  if ($f.Name -ieq 'desktop.ini' -or $f.Name -ieq 'Thumbs.db' -or $f.Name.StartsWith('~$')) { continue }
  if (($f.Attributes -band [System.IO.FileAttributes]::Directory) -ne 0) { $carpetas.Add($rel); continue }
  if ($Limite -gt 0 -and $archivos.Count -ge $Limite) { continue }
  $archivos.Add($f)
}

# Mostrar lo que se va a copiar y pedir confirmacion antes de escribir nada
$grupos = @($carpetas | Where-Object { -not $_.Contains('/') } | Sort-Object)
$conEstados = @($carpetas | Where-Object { $_ -match '^[^/]+/(Activos|Retirados)$' } | ForEach-Object { $_.Split('/')[0] } | Select-Object -Unique)
$reGrupo = '(?i)palma|sena|aprendiz|servicio|contratist|oficina|trabajador|personal'
$mb = [double](($archivos | Measure-Object -Property Length -Sum).Sum) / 1MB
Write-Host ''
Write-Host ("Carpeta elegida: {0}" -f $Carpeta)
Write-Host ("La copia se guardara en: {0}" -f $Salida)
Write-Host ("Se copiarian {0} documentos ({1:N1} MB) de estas carpetas:" -f $archivos.Count, $mb)
$dudosas = 0
foreach ($g in $grupos) {
  if ($conEstados -contains $g -or $g -match $reGrupo) { Write-Host ('    ' + $g) } else { Write-Host ('  ? ' + $g); $dudosas++ }
}
if ($dudosas) { Write-Host ("Las {0} carpeta(s) marcadas con ? no parecen grupos de trabajadores." -f $dudosas) -ForegroundColor Yellow }
if (-not $conEstados.Count) { Write-Host 'Ninguna carpeta tiene subcarpetas Activos o Retirados: revise que sea la carpeta correcta.' -ForegroundColor Yellow }
if (-not $archivos.Count) { Write-Host 'No hay documentos para copiar. No se creo ninguna copia.'; exit 1 }
if (-not $Confirmar) {
  $r = Read-Host 'Escriba S y Enter para crear la copia (cualquier otra respuesta cancela)'
  if ($r -notmatch '^[sS]') { Write-Host 'Cancelado. No se creo ninguna copia.'; exit 1 }
}
$sello = Get-Date -Format 'yyyyMMddHHmmss'

# 2. Datos de las hojas de vida
$textoDatos = '{}'
if ($Datos -and (Test-Path -LiteralPath $Datos)) { $textoDatos = [System.IO.File]::ReadAllText($Datos, [System.Text.Encoding]::UTF8).Trim() }

# 3. Escribir la copia: cabecera y luego cada documento en base64
$utf8 = New-Object System.Text.UTF8Encoding($false)
$sw = New-Object System.IO.StreamWriter($Salida, $false, $utf8, 1048576)
try {
  $sw.Write('{"formato":"expediente-laboral-mindala","version":2,"exportado":' + (J ((Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffZ'))))
  $sw.Write(',"origen":"carpetas","totalDocumentos":' + $archivos.Count + ',"datos":' + $textoDatos + ',"carpetas":[')
  for ($i = 0; $i -lt $carpetas.Count; $i++) { if ($i) { $sw.Write(',') }; $sw.Write((J $carpetas[$i])) }
  $sw.Write('],"archivos":[')
  for ($i = 0; $i -lt $archivos.Count; $i++) {
    $f = $archivos[$i]
    $rel = $f.FullName.Substring($n).Replace('\', '/')
    $tipo = $Tipos[$f.Extension.ToLower()]; if (-not $tipo) { $tipo = 'application/octet-stream' }
    $ms = [long](($f.LastWriteTimeUtc - $Epoch).TotalMilliseconds)
    if ($i) { $sw.Write(',') }
    $sw.Write('{"id":"c' + $sello + '-' + $i + '","ruta":' + (J $rel) + ',"size":' + $f.Length + ',"mtime":' + $ms + ',"tipo":"' + $tipo + '"}')
  }
  $sw.Write("],`n" + '"documentos":{' + "`n")
  for ($i = 0; $i -lt $archivos.Count; $i++) {
    if ($i) { $sw.Write(",`n") }
    $sw.Write('"c' + $sello + '-' + $i + '":"')
    $sw.Write([System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($archivos[$i].FullName)))
    $sw.Write('"')
    if (($i % 50) -eq 0) { Write-Progress -Activity 'Creando copia del expediente' -Status ("{0} de {1} documentos" -f $i, $archivos.Count) -PercentComplete ([int](100 * $i / [Math]::Max(1, $archivos.Count))) }
  }
  $sw.Write("`n}}`n")
} finally { $sw.Close() }
Write-Progress -Activity 'Creando copia del expediente' -Completed
$tam = (Get-Item -LiteralPath $Salida).Length / 1MB
Write-Host ("Copia creada: {0}" -f $Salida)
Write-Host ("{0} carpetas, {1} documentos, {2:N1} MB" -f $carpetas.Count, $archivos.Count, $tam)
