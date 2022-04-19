Configuration IISOrgDefaultConfig
{
    # This will generate a .mof file; IISCHDemo.mof
    Node ('IISSRV01')
    {
        #ensure IIS is installed
        WindowsFeature IIS
        {
            Name = 'web-server'
            Ensure = 'Present'
        }

        #ensure the default document is configured for web app
        File default
        {
          DestinationPath = 'C:\inetpub\wwwroot\default.htm'
          Contents = 'Hello World'
          DependsOn = '[WindowsFeature]IIS'
          Ensure = 'Present'
        }
    }
}