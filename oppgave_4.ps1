[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $UrlKortStokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)


$ErrorActionPreference = 'Stop'
 
$response = Invoke-WebRequest -Uri $UrlKortStokk
$cards = $response.Content | ConvertFrom-Json

$kortstokk = @()
foreach ($card in $cards) {
    $kortstokk += ($card.value + $card.value) + ","

}
Write-host "Kortstokk : $kortstokk"