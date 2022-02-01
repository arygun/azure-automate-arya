[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $UrlKortStokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)


$ErrorActionPreference = 'Stop'





$response = Invoke-WebRequest -Uri $UrlKortStokk
$cards = $response.Content | ConvertFrom-Json
$sum = 0

foreach ($card in $cards) {
    $sum += switch ($card.value){
        'J' {10  }
        'Q' {10  }
        'K' {10  }
        'A' {11  }
        Default { $card.value}
    }
}

# foreach ($card in $cards) {
#     $sum += 
#     if ($card.value -eq 'J') {10}
#     elseif ($card.value -eq 'Q') {10}
#     elseif ($card.value -eq 'K') {10}
#     elseif ($card.value -eq 'A') {11}
#     else {
#         $card.value
#     }   
# }


# Skrive ut kortstokk
$kortstokk = @()
foreach ($card in $cards) {
    $kortstokk += ($card.suit[0] + $card.value)

}
Write-host "Kortstokk : $kortstokk"
Write-host "Poengsum : $sum"

