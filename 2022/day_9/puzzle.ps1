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
$start = $TRUE # If this is set to FALSE then we have move outside of our start location
$skip_tail = $FALSE
$tail = [System.Tuple]::Create(0,0)
$history = [System.Collections.ArrayList]@()

function Main(){
    $prev_direction = ""
    $amount = -1
    $direction = ""
    
    for ($i = 0; $i -lt $guts.length; $i++){

        if ($i%2 -eq 0){ # Direction
            $direction = $guts[$i]

        }else{ # Amount of moves in previous direction
            $amount = [int]$guts[$i]
        }
    
        if ($amount -ne 0){
            if ($start){
                $start = $FALSE
                $amount -= 1
            }


            while ($amount -gt 0){
                $skip_tail = $FALSE
                $x = $tail.Item1
                $y = $tail.Item2

                if ($direction -eq "R"){
                    $x++

                }elseif ($direction -eq "L"){
                    $x--

                }elseif ($direction -eq "U"){
                    $y++
    
                }elseif ($direction -eq "D"){
                    $y--
                }

                $tail = [System.Tuple]::Create($x,$y) # Update the tuple

                # -and !($direction -eq "R" -and $prev_direction -eq "L") -and !($direction -eq "U" -and $prev_direction -eq "D")
                if (($direction -ne $prev_direction) -or (($prev_direction -ne "") -and !(($direction -eq "R" -and $prev_direction -eq "L") -and !($direction -eq "U" -and $prev_direction -eq "D"))) ){
                   $skip_tail = $TRUE
                   $amount--
                }

                # We must check if we have been in this cell before
                if (!($skip_tail) && !($history_x -contains $tail)){
                    #"$direction , $prev_direction"
                    $history.Add($tail) | out-null

                }

                $amount--
                $prev_direction = $direction # Overwrite the old value
            }    
        }
    }
    
    $tail_movement = $history.count - 1 # We do this to represent that the tail is still behind the head
    "[PART 1] Tail moved to a total of $tail_movement cells"
}

main