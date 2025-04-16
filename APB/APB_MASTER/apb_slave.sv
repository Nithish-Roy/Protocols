module apb_slave(
					input 					pselx		,
					input					penable		,
					input 					pwrite		,
    				input 	   [15:0]		pwdata		,
                    input 	   [3:0]		paddr		,
                    input					pclk		,
                    input					prst_n		,
                    output   				pready		,
                    output reg [15:0] 		prdata					       
          
                 );	
                           
                 typedef enum logic [1:0] {IDLE, SETUP, ACCESS} apb_slave_states;
                 apb_slave_states present	;
				 apb_slave_states	next	;
                           
  reg [15:0] memory [15:0];
                           
                           always_ff @(posedge pclk, negedge prst_n)
                             begin
                               if(~prst_n)
                               	 present <= IDLE;
                               else
                                 present <= next;
                             end
                           
                           always_comb begin
                             case(present)
                               IDLE: if(pselx && penable)
                                 		next = SETUP;
                               			else
                                          next = IDLE;
                               SETUP: next = ACCESS;
                               ACCESS: if(!pselx || !penable)
                                 			next = IDLE;
                               else if(pselx && penable)
                                         	next = SETUP;
                               default: next = IDLE;
                             endcase
                               end
                               
                               always_ff @(posedge pclk) begin
                                 if(present == SETUP && pwrite)
                                   memory[paddr] <= pwdata;
                                 else if(present == SETUP && !pwrite)
                                   prdata <= memory[paddr];
                               end
                               
  							assign pready = (present == ACCESS); 
endmodule
                                   
 
