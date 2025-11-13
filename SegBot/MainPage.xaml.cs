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