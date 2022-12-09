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

# Define our grid
$grid = New-Object 'object[,]' 6,6

# Start values
$head_y = 5
$head_x = 0

$prev_head_x = 0
$prev_head_y = 5
$tail_y = $prev_head_y
$tail_x = $prev_head_x
$prev_tail_x = $tail_x
$prev_tail_y = $tail_y

$start = $TRUE # If this is set to FALSE then we have move outside of our start location
$skip_tail = $FALSE

function BuildGrid(){
    for ($y = 0; $y -lt $grid.length/6; $y++){
        for ($x = 0; $x -lt $grid.length/6; $x++){
            $grid[$y, $x] = "."
        }
    }

    $grid[5,0] = "s" # Indicating the start
}

function PrintGrid(){
    for ($y = 0; $y -lt $grid.length/6; $y++){
        $line = ""
        for ($x = 0; $x -lt $grid.length/6; $x++){
            $line += $grid[$y, $x]
        }
        $line
    }
}

function UpdateTail(){
    $tail_x = $prev_head_x
    $tail_y = $prev_head_y

    if ($skip_tail){
        "Test: $direction , $prev_direction"
        "y:$tail_y , x:$tail_x"

        $grid[$tail_y, $tail_x] = "."
    }else{
        $grid[$tail_y, $tail_x] = "#"
    }
}

function UpdateHeader(){
    UpdateTail

    $grid[$head_y, $head_x] = "H"
}

function Main(){
    BuildGrid

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
                $prev_head_y = $head_y
                $prev_head_x = $head_x

                if ($direction -eq "R"){
                    $head_x++

                }elseif ($direction -eq "L"){
                    $head_x--

                }elseif ($direction -eq "U"){
                    $head_y--
    
                }elseif ($direction -eq "D"){
                    $head_y++
                }

                if (($direction -ne $prev_direction) -and (($direction -eq "R" -or $direction -eq "L" -or $direction -eq "U" -or 
                $direction -eq "D") -and ($prev_direction -eq "U" -or $prev_direction -eq "D" -or $prev_direction -eq "R" -or  $prev_direction -eq "L"))){
               
                   $skip_tail = $TRUE
                }

                UpdateHeader

                $amount--
                $prev_direction = $direction # Overwrite the old value
            }    
        }
    }
    
    $positions -= 1
    #"[PART 1] Tail moved to "$positions
}

main

PrintGrid
