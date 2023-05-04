import spot
import sys

model_file = "model.hoa"

def check_trace(cur_state, next_state) -> bool:
    aut = spot.automaton(model_file)
    result = False
    for s in range(0, aut.num_states()):
        for t in aut.out(s):
            if int(t.src) == int(cur_state) and int(t.dst) == int(next_state):
                result = True
                break
        if result == True:
            break
    return result

assert(len(sys.argv) == 2)
trace_filename = sys.argv[1]
trace_file = open(trace_filename, "r")
trace = trace_file.readline()

push_state_count = 0
pop_state_count = 0

cur_state = trace[0]
if cur_state == '0':
    pop_state_count += 1
if cur_state == '1':
    push_state_count += 1

for state in trace[1:]:
    if state == '0':
        pop_state_count += 1
    if state == '1':
        push_state_count += 1

    assert(check_trace(cur_state, state) == True)
    cur_state = state

assert(pop_state_count == push_state_count)
