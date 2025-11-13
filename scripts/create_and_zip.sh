#!/usr/bin/env bash
set -e

ROOT_DIR="SegBot"
ZIP_NAME="SegBot.zip"

# Remove any existing
rm -rf "$ROOT_DIR" "$ZIP_NAME"

# Create directories
mkdir -p "$ROOT_DIR/Platforms/Android"
mkdir -p "$ROOT_DIR/Resources"

# Write files
cat > "$ROOT_DIR/.gitignore" <<'GITIGNORE'
bin/
obj/
.vs/
*.user
*.suo
*.userosscache
*.sln.docstates
.vscode/
*.apk
*.aab
GITIGNORE

cat > "$ROOT_DIR/SegBot.csproj" <<'CSproj'
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net9.0-android</TargetFramework>
    <OutputType>Exe</OutputType>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    <UseMaui>true</UseMaui>
    <SupportedOSPlatformVersion>21</SupportedOSPlatformVersion>
  </PropertyGroup>

  <ItemGroup>
    <MauiAsset Include="Resources\**" />
  </ItemGroup>
</Project>
CSproj

cat > "$ROOT_DIR/MauiProgram.cs" <<'MAUIPROG'
using Microsoft.Maui;
using Microsoft.Maui.Hosting;

namespace SegBot;

public static class MauiProgram
{
    public static MauiApp CreateMauiApp()
    {
        var builder = MauiApp.CreateBuilder();
        builder
            .UseMauiApp<App>()
            .ConfigureFonts(fonts =>
            {
                // fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
            });

        return builder.Build();
    }
}
MAUIPROG

cat > "$ROOT_DIR/App.xaml" <<'APPXAML'
<?xml version="1.0" encoding="utf-8" ?>
<Application xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             x:Class="SegBot.App">
  <Application.Resources>
    <ResourceDictionary>
      <Style TargetType="Label">
        <Setter Property="HorizontalOptions" Value="Center" />
        <Setter Property="VerticalOptions" Value="Center" />
      </Style>
    </ResourceDictionary>
  </Application.Resources>
</Application>
APPXAML

cat > "$ROOT_DIR/App.xaml.cs" <<'APPXAMLCS'
using Microsoft.Maui.Controls;

namespace SegBot;

public partial class App : Application
{
    public App()
    {
        InitializeComponent();
        MainPage = new MainPage();
    }
}
APPXAMLCS

cat > "$ROOT_DIR/MainPage.xaml" <<'MAINXAML'
<?xml version="1.0" encoding="utf-8" ?>
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             x:Class="SegBot.MainPage"
             Title="SegBot">
  <VerticalStackLayout Padding="20" Spacing="15">
    <Label Text="SegBot" FontSize="32" HorizontalOptions="Center" />
    <Button Text="Saludar" Clicked="OnGreetingClicked" />
  </VerticalStackLayout>
</ContentPage>
MAINXAML

cat > "$ROOT_DIR/MainPage.xaml.cs" <<'MAINXAMLCS'
using Microsoft.Maui.Controls;

namespace SegBot;

public partial class MainPage : ContentPage
{
    public MainPage()
    {
        InitializeComponent();
    }

    private async void OnGreetingClicked(object sender, EventArgs e)
    {
        await DisplayAlert("Hola", "SegBot está listo para Android.", "OK");
    }
}
MAINXAMLCS

cat > "$ROOT_DIR/Platforms/Android/MainActivity.cs" <<'MAINACT'
using Android.App;
using Android.Content.PM;
using Microsoft.Maui;

namespace SegBot;

[Activity(Theme = "@style/Maui.SplashTheme", MainLauncher = true,
    ConfigurationChanges = ConfigChanges.ScreenSize | ConfigChanges.Orientation | ConfigChanges.UiMode | ConfigChanges.ScreenLayout)]
public class MainActivity : MauiAppCompatActivity
{
}
MAINACT

cat > "$ROOT_DIR/Platforms/Android/AndroidManifest.xml" <<'MAND'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.yourcompany.segbot">
  <uses-sdk android:targetSdkVersion="34" />
  <application android:label="SegBot" />
</manifest>
MAND

cat > "README.md" <<'README'
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
README

# Zip it
if command -v zip >/dev/null 2>&1; then
  zip -r "$ZIP_NAME" "$ROOT_DIR" README.md
elif command -v apt-get >/dev/null 2>&1 || command -v yum >/dev/null 2>&1; then
  # try python zip if zip not available
  python3 - <<PY
import zipfile,sys,os
zf = zipfile.ZipFile("$ZIP_NAME","w",zipfile.ZIP_DEFLATED)
for root,dirs,files in os.walk("$ROOT_DIR"):
    for f in files:
        path = os.path.join(root,f)
        zf.write(path)
zf.write("README.md")
zf.close()
PY
else
  echo "No 'zip' tool found and couldn't fallback. Please install zip or run the PowerShell script on Windows."
  exit 1
fi

echo "Created $ZIP_NAME"
