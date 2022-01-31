$Url = "http://nav-deckofcards.herokuapp.com/shuffle"

$response = Invoke-WebRequest -Uri $Url
$cards = $response.Content | ConvertFrom-Json

$kortstokk = @()
foreach ($card in $cards) {
    $kortstokk += ($card.value + $card.value) + ","

}
Write-host "Kortstokk : $kortstokk"