## Correctness properties

1. Only one thread resides in the critical section in one time. `NoRaceCondition` invariant in TLA+ model;
2. After all operations stack should be empty. `FinishedEmpty` temporal property in TLA+. This can be written in LTL formula `G(push -> F(pop))`, meaning that if `push` happens, then there will always be a `pop` in the future. Buchi automata can be found in `buchi.pdf` and corresponding monitor in `monitor.pdf`.

## TLA model
In TLA+ model only push/pop stack interfaces were verified. Garbage collection with reference counter was not modeled, but it is present in C++ implementation.

## C++ implementation
Run `make` to build lock free stack implementation with tests. `./a.out` launches tests and saves push/pop trace to `log.txt` file.

## Spot model
Spot checks that input trace satisfies buchi automata build from LTL formula `G(push -> F(pop))`. Model in HOA format is prepared using `ltl2tgba -U 'G(push -> F(pop))'` and stored in `model.hoa` file. Moreover, model checks that number of pushes is equal to number of pops from stack. Tests 1, 2 and 4 from "tests.cpp" satisfy all conditions. Test3 does not satisfies, since number of pushes is greater than number of pops in this test.
Usage: `python3 ./spot_checker <trace>`, for example `python3  ./spot_checker log.txt`
