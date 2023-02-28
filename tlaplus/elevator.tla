---- MODULE elevator ----

EXTENDS Sequences, Integers, TLC, FiniteSets

(*--algorithm elevator

variables
    levels = 10,
    order = [from: 1..levels, to: 1..levels],
    orders_to_process \in order \X order,
    orders_queue = <<>>,

    cur_order = "",
    curr_elevator_level = 1,
    passenger_taken = FALSE,
    elevator_in_move = FALSE,

define
    EventuallyConsistent == <>[](orders_to_process = <<>> /\ orders_queue = <<>>)
end define;

begin
    \* start proccess a call
    ElevatorStartMovement:
        if elevator_in_move = FALSE /\ Len(orders_queue) > 0 then
            elevator_in_move := TRUE;
            cur_order := Head(orders_queue);
        end if;

    \* take passenger
    ElevatorMoveToCaller:
        if elevator_in_move = TRUE /\ passenger_taken = FALSE then
            curr_elevator_level := cur_order.from;
            passenger_taken := TRUE;
        end if;
    
    \* transfer passenger
    ElevetorTransfer:
        if elevator_in_move = TRUE /\ passenger_taken = TRUE then
            passenger_taken := FALSE;
            elevator_in_move := FALSE;
            curr_elevator_level := cur_order.to;
            orders_queue := Tail(orders_queue);
        end if;

    CallElevator:
        if Len(orders_to_process) /= 0 then
            orders_queue := Append(orders_queue, Head(orders_to_process));
            orders_to_process := Tail(orders_to_process);
        end if;

end algorithm;*)

=========================
