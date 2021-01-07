Generalisation of [Advent of Code - 2020 day 17](https://adventofcode.com/2020/day/17) to higher dimensions.

See [report about this problem](https://github.com/MichalMarsalek/Advent-of-code/blob/master/2020/misc/day17-highdims/ND_gol_with_low_dimensional_initial_state.pdf)
or
visit [reddit thread regarding this topic](https://www.reddit.com/r/adventofcode/comments/kfb6zx/day_17_getting_to_t6_at_for_higher_spoilerss/).

* *nd_gol.nim* is a bruteforce version (d=7 in 4 minutes).
* *nd_gol_sym.nim* is a version using symmetries and precomputation (d=16 in under 3 minutes)
* *nd_gol_sym2.nim* is a minor speed up of the above using list of active cells instead of a set
* *nd_gol_sym3.nim* significant speed up by using single neigbourhood function/table (d=22 under 3 minutes)
* *nd_gol_sym3_single.nim* version without precomputation (same speed as above, but RAM is not problem so d=25 under 6 minutes).
* *nd_gol_sym4.nim* is the fastest version yet. d=10 in 0.1 s, d=20 in 4.5 s, d=30 in 1 min, d=40 in 8 minutes