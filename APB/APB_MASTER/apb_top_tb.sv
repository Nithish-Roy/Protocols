module apb_top_tb();
     reg            clk        ;
     reg            rst_n      ;
     reg            start      ;
  reg [3:0]     	addr       ;
     reg [15:0]     data       ;
     reg            write      ;


 apb_top top( 
                   .clk  ( clk  )      ,
                   .rst_n( rst_n)      , 
                   .start( start)      ,
 				   .addr ( addr )      ,
  				   .data ( data )      ,
                   .write( write)      
            );
 
        initial begin

            $dumpfile("dump.vcd");
            $dumpvars;

        end
       
        initial begin

            clk = 0;
            forever #5 clk = ~clk;

        end

        initial begin
          
          	start = 1;

            rst_n = 0;
            #6;
            rst_n = 1;

        end

  task to_write(bit [15:0] data_in, bit [3:0] addr_in);
    
    
    @(posedge clk) begin
   	data = data_in;
    addr = addr_in;
    write = 1;
      @(posedge clk) ; 
      @(posedge clk) ; 
      $display(" writing data = %h to addr = =%d", data_in, addr_in);
    end
    
  endtask
    
  task to_read(bit [3:0] addr_in);
    
    @(posedge clk) begin
    addr = addr_in;
    write = 0;
      @(posedge clk);
    end
    
  endtask
  
  
  
        initial begin
          to_write(32'h FACE,4'd15);
          to_write(32'h CAFE,4'd14);
          to_write(32'h FFFF,4'd13);
          to_write(32'h BEEF,4'd12);
          
          @(posedge clk);
          
			
          to_read(4'd15);
          to_read(4'd14);
          to_read(4'd13);
          to_read(4'd12);
		
          #300
		  $finish;
        end

endmodule
