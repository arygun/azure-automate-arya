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

# Lager en string av hele kortstokken og legger dem i en array
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

# Regne ut poengsummen
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

$magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

Write-Output "meg: $(kortStokktilString -kortstokk $meg)"
Write-Output "meg poengsum: $(sumPoengKortstokk -kortstokk $meg)"
Write-Output "magnus: $(kortStokktilString -kortstokk $magnus)"
Write-Output "magnus poengsum: $(sumPoengKortstokk -kortstokk $magnus)"
Write-Output "kortstokk: $(kortStokktilString -kortstokk $kortstokk)"

function skrivUtResultat {
    param (
        [string]
        $vinner,        
        [object[]]
        $kortStokkMagnus,
        [object[]]
        $kortStokkMeg        
    )
    Write-Output "Vinner: $vinner"
    Write-Output "magnus | $(sumPoengKortstokk -kortstokk $kortStokkMagnus) | $(kortStokktilString -kortstokk $kortStokkMagnus)"    
    Write-Output "meg    | $(sumPoengKortstokk -kortstokk $kortStokkMeg) | $(kortStokktilString -kortstokk $kortStokkMeg)"
}

# bruker 'blackjack' som et begrep - er 21
$blackjack = 21


if ((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) {
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
elseif ((sumPoengKortstokk -kortstokk $magnus) -eq $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}