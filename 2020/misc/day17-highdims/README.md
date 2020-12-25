Generalisation of [Advent of Code - 2020 day 17](https://adventofcode.com/2020/day/17) to higher dimensions.

Works by defining the following equivalence:
X = Y if {\*|X_i|; i = 3..d \*} = {\*|Y_i|; i = 3..d \*}
and noting that equivalent cells are either all active or all inactive. Hence, we only track the cosets [X].
See [reddit thread regarding this topic](https://www.reddit.com/r/adventofcode/comments/kfb6zx/day_17_getting_to_t6_at_for_higher_spoilerss/).

Code consumes a lot of memory and works quickly up to d=16 (3 minutes).
