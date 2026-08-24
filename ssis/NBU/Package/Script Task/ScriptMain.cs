using System.Net;

public void Main()
{
    var url = "https://bank.gov.ua/NBU_BankInfo/rcukru?json";
    var client = new WebClient();
    string json = client.DownloadString(url);

    Dts.Variables["User::JsonRaw"].Value = json;
    Dts.TaskResult = (int)ScriptResults.Success;
}
