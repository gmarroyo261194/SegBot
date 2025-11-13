# SegBot (MAUI - Android)

Proyecto .NET MAUI (C#) orientado a Android, target net9.0-android.

Requisitos previos:
- .NET 9 SDK con workloads de MAUI instalados (dotnet workload install maui-android).
- Visual Studio 2022/2023 con soporte MAUI o Visual Studio para Mac, o el entorno de desarrollo que soporte MAUI + Android/emulador.
- Android SDK y emulador / dispositivo físico.

Instrucciones rápidas (línea de comandos):

1. Descomprime SegBot.zip o clona el repositorio.
2. Abre la carpeta del proyecto (contiene SegBot.csproj).
3. Instala workloads si es necesario:
   dotnet workload install maui-android
4. Compila:
   dotnet build -f net9.0-android
5. Abre en Visual Studio para ejecutar en emulador o dispositivo.

Crear repo y subir:
- Con gh CLI:
  gh repo create gmarroyo261194/SegBot --private --source=. --remote=origin --push
- O usar la interfaz web y luego:
  git remote add origin https://github.com/gmarroyo261194/SegBot.git
  git branch -M main
  git push -u origin main