foreach ($module in get-childitem .\modules\) {
    remove-module $module.Name -ErrorAction SilentlyContinue
    import-module ($module.FullName + "\" + $module.Name + ".psd1")
}

$Dashboard = New-UDDashboard -Title "Hello, World!" -Verbose -Content {
    New-UDHeading -Text "Hello, World!" -Size 1
    New-UDSound -URL './Public/Sounds/HornHonk.wav' -PlayStatus PLAYING -AutoStart
    New-UDHeading -Text 'After Audio' -Size 1

}
$publicfolder = Publish-UDFolder -path (Join-Path $PSScriptRoot "Public") -RequestPath "/Public"
Get-UDDashboard | Stop-UDDashboard
Enable-UDLogging -Console -Level debug
Start-UDDashboard -Dashboard $Dashboard -Port 10001 -PublishedFolder $publicfolder -DisableTelemetry -Verbose