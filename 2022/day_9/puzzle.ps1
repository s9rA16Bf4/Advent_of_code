param(
    [Parameter()]
    [String]$file
)

if ([string]::IsNullOrEmpty($file)){
    "Error: Needs input file"
    "Usage: pwsh puzzle.ps1 <input_file>"
    return 
}

if (-not(Test-Path -Path $file -PathType Leaf)) {
    "Error: Failed to find the provided file"
    return
}

$guts = Get-Content $file
$guts = $guts -split " "
$head = [System.Tuple]::Create(0,0)
$tail = [System.Tuple]::Create(0,0)
$history = [System.Collections.ArrayList]@()

function Main(){
    $amount = -1
    $direction = ""
    
    for ($i = 0; $i -lt $guts.length; $i++){

        if ($i%2 -eq 0){ # Direction
            $direction = $guts[$i]

        }else{ # Amount of moves in previous direction
            $amount = [int]$guts[$i]
        }
    
        if ($amount -ne 0){
        
                $amount--
            }
        }
    }
    
    #$history
    $tail_movement = $history.count
    "[PART 1] Tail moved to a total of $tail_movement cells"
}

main