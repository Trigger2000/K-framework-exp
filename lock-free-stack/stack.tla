---- MODULE stack ----

EXTENDS Sequences, Integers, TLC, FiniteSets

(*--algorithm stack

variables
    stack = <<>>,

\* temporal property
define
    FinishEmpty == Len(stack) = 0
end define;

process workers \in 1..4
variables
    push_counter = 0,
    pop_counter = 0

begin
push:
    while push_counter < 10 do
        push_counter := push_counter + 1;
        stack := Append(stack, push_counter);
    end while;

pop:
    while pop_counter < 10 do
        pop_counter := pop_counter + 1;
        stack := SubSeq(stack, 1, Len(stack)-1);
    end while;
end process;


end algorithm;*)
===================================
