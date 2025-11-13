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