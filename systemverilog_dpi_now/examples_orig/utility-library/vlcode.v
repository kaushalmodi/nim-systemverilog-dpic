
module top;
    /* 
     * "Import" some C code to build and operate timers.
     */
    import "DPI-C" function longint timer_split(inout chandle p);
    import "DPI-C" function chandle timer_start();

    /*
     * Just something to eat up time so we have something to measure.
     */
    task consumeTime(inout int sum);
        int i, j, k;
        sum = 0;
        for(i = 0; i < 100; i++) begin
          for(j = 0; j < 100; j++) begin
            for(k = 0; k < 5000; k++) begin
                sum = sum + i * 2 + j * 3 + k * 4;
            end
          end
        end
    endtask

    chandle splittime; // The split timer.
    chandle totaltime; // The total execution timer.

    longint useconds;  // Split time, in microseconds.
    real seconds;      // Total time, in seconds.
    int cnt;           // Loop variable.
    int sum;           // The ignored result from our calculation.

    initial begin
        totaltime = timer_start();    // Timer to measure total time.
        splittime = timer_start();  // Timer to measure splits.

        cnt = 10; // Repeat 10 times.
        while (cnt>0) begin
            sum = 0;

            // Reset the split timer.
            useconds = timer_split(splittime);

            // Perform a time consuming computation.
            consumeTime(sum);

            // Calculate how long since the last split.
            useconds = timer_split(splittime);
            $display(" split - %0d microseconds", useconds);
            cnt--;
        end
        
        // Calculate total time since execution began. 
        useconds = timer_split(totaltime);

        // Try to print it nicely.
        seconds = useconds / 1000000.0;
        if (seconds > 1) 
            $display("Test complete - %0g seconds", seconds);
        else
            $display("Test complete - %0d useconds", useconds);
    end

endmodule

