package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

/*
As the submarine drops below the surface of the ocean, it automatically performs a sonar sweep of the nearby sea floor.
On a small screen, the sonar sweep report (your puzzle input) appears: each line is a measurement of the sea floor depth as the sweep
looks further and further away from the submarine.
*/

func main() {

	opened_file, err := os.Open("input.txt")
	//opened_file, err := os.Open("test_input.txt")

	if err != nil {
		fmt.Println(err)
	}
	scanner := bufio.NewScanner(opened_file)
	scanner.Split(bufio.ScanLines)

	gut := []string{}
	for scanner.Scan() {
		gut = append(gut, scanner.Text())
	}

	counter := part1(gut)
	fmt.Printf("[1:~] The depth increased a total of %d times\n", counter)

	counter2 := part2(gut)
	fmt.Printf("[2:~] The depth increased a total of %d times\n", counter2)

}

func part1(gut []string) int {
	counter := 0
	prev_line := -1

	for _, s_line := range gut {
		line, err := strconv.Atoi(s_line)

		if err != nil {
			fmt.Println(err)
		}

		if prev_line != -1 && line > prev_line {
			counter++
		}

		prev_line = line
	}

	return counter
}

func part2(gut []string) int {
	counter := 0
	prev_sum := -1
	sum := 0

	for i := range gut {

		a, err := strconv.Atoi(gut[i])
		if err != nil {
			fmt.Println(err)
		}

		b := 0
		c := 0

		if i+1 < len(gut) {
			b, err = strconv.Atoi(gut[i+1])
			if err != nil {
				fmt.Println(err)
			}
		}

		if i+2 < len(gut) {
			c, err = strconv.Atoi(gut[i+2])
			if err != nil {
				fmt.Println(err)
			}
		}

		if b == 0 || c == 0 {
			break
		}
		sum = a + b + c

		if prev_sum != -1 && sum > prev_sum {
			counter++
		}

		prev_sum = sum
	}

	return counter
}
