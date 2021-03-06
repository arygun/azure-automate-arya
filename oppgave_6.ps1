[CmdletBinding()]
param (
    #Parameteren er ikke obligatorisk siden vi har default verdi
    [Parameter(HelpMessage = "Url til kortstokk", Mandatory = $false)]
    [string]
    #når parametern ikke er gitt brukes defalut verdi
    $UrlKortStokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

#Feilhåndering - stopp programet hvis det dukker opp noen feil
$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

$webRequest = Invoke-WebRequest -Uri $UrlKortStokk

$kortstokkJson = $webRequest.Content

$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson


function kortStokktilString {
    [OutputType([string])] 
    param (
        [Object[]]
        $kortstokk
    )
    $streng =''
    foreach ($kort in $kortstokk) {
        $streng = $streng + "$($kort.suit[0])" + $($kort.value) + ','
     } 
     return $streng
}


function sumPoengKortstokk {
    [OutputType([int])]
    param (
        [object[]]
        $kortstokk
    )

    $poengKortstokk = 0

    foreach ($kort in $kortstokk) {
        
        $poengKortstokk += switch ($kort.value) {
            { $_ -cin @('J', 'Q', 'K') } { 10 }
            'A' { 11 }
            default { $kort.value }
        }
    }
    return $poengKortstokk
}

Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $kortstokk)"

$meg = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

Write-Output "meg: $(kortStokktilString -kortstokk $meg)"
Write-Output "magnus: $(kortStokktilString -kortstokk $magnus)"
Write-Output "kortstokk: $(kortStokktilString -kortstokk $kortstokk)"
