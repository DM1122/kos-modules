// PID lib
@LAZYGLOBAL OFF.

FUNCTION PID_init
{
    PARAMETER
        Kp,     // proportional gain
        Ki,     // integral gain
        Kd,     // derivative gain
        cnfg.       // algorithm config

    LOCAL e is 0.       // error e(t)
    LOCAL e_prev is 0.      // error e(t-1)

    LOCAL P is 0.       // proportional term
    LOCAL I is 0.       // integral term
    LOCAL D is 0.       // derivative term

    LOCAL t is 0.       // time (t)
    LOCAL u is 0.       // control var u(t)

    LOCAL pid is LIST
        (
            cnfg,           // [0]
            e,              // [1]
            e_prev,         // [2]
            P,              // [3]
            I,              // [4]
            D,              // [5]
            Kp,             // [6]
            Ki,             // [7]
            Kd,             // [8]
            t,              // [9]
            u               // [10]
        ).

RETURN pid.
}

FUNCTION PID_loop
{
    PARAMETER
        pid,
        r,
        y.

    LOCAL cnfg is pid[0].
    LOCAL e_prev is pid[1].
    LOCAL e_prev2 is pid[2].
    LOCAL P_prev is pid[3].
    LOCAL I_prev is pid[4].
    LOCAL D_prev is pid[5].
    LOCAL Kp is pid[6].
    LOCAL Ki is pid[7].
    LOCAL Kd is pid[8].
    LOCAL t_prev is pid[9].
    LOCAL u_prev is pid[10].

    LOCAL e is r - y.
    LOCAl P is P_prev.
    LOCAL I is I_prev.
    LOCAL D is D_prev.
    LOCAL t is TIME:SECONDS.
    LOCAL u is 0.

    IF t_prev > 0 AND t - t_prev > 0     // prevents Nan from being pushed into stack
    {
        IF cnfg = 0        // positional algorithm
        {
            // P
            SET P to Kp * e.

            // I
            SET I to I_prev + Ki * (e * (t - t_prev)).

            // D
            SET D to Kd * ((e - e_prev) / (t - t_prev)).

            // Plant
            SET u to P + I + D.       
        }

        IF cnfg = 1     // velocity algorithm
        {
            // P
            SET P to Kp * (e - e_prev).

            // I
            SET I to Ki * e * (t - t_prev).

            // D
            SET D to (Kd / (t - t_prev)) * (e - 2 * (e_prev) + e_prev2).

            // Plant
            SET u to u_prev + P + I + D.
        }
    }    

    SET pid[1] to e.
    SET pid[2] to e_prev.
    SET pid[3] to P.
    SET pid[4] to I.
    SET pid[5] to D.
    SET pid[9] to t.
    SET pid[10] to u.

    RETURN u.
}

