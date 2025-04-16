module apb_master(  
                  
                  //  protocol signals

                   input               pclk        ,
                   input               preset_n    ,
                   output              pselx       ,
                   output              penable     ,
                   output  [3:0]       paddr       ,
                   output              pwrite      ,
                   output  [15:0]      pwdata      ,
  				   output reg [15:0]      data_out    ,
                    
                   //   external signals for testing
                    
                    input               start      ,
 					input   [3:0]     	addr       ,
  					input   [15:0]      data       ,
                    input               write      ,
                    input               pready     ,
                    input   [15:0]      prdata      
    );

  typedef enum logic [1:0] {IDLE, SETUP, ACCESS} apb_states;
     
      apb_states present;
      apb_states next;
  
  reg [15:0] data_inter;
  reg [3:0] addr_inter;
  reg  write_inter;

         always_ff @(posedge pclk or negedge preset_n)
             begin
                 if(~preset_n)
                     present <= IDLE;
                 else
                     present <= next;
             end

         always_comb begin
                case(present)
                  IDLE: if(start)  next = SETUP;
                    SETUP: next = ACCESS; 
                    ACCESS:if(pready && pselx) 
                      			next = SETUP;
                  else  if (!pready)
                    			next = ACCESS;
                  		  else next = IDLE;
                    default: next = IDLE;
                endcase
         end

         always_ff @(posedge pclk) begin
            if(!pwrite && pready)
                data_out <= prdata;
           else
             	data_out <= 0;
         end
  
//   assign data_out = prdata;

  always @(posedge pclk) begin
    if(next == SETUP)begin
           data_inter = data;
    		addr_inter = addr;
    		write_inter = write;
         end
  end
  
  
  assign pselx    = !(present == IDLE) && (start)    ;
  assign penable  =  (present == ACCESS);

  assign pwrite  =  (present == SETUP) || (present == ACCESS) ?  write_inter : 1'b0	   ;
  assign paddr    = (present == SETUP) || (present == ACCESS)  ? addr_inter  : 4'b0000 ;
  assign pwdata   = (present == SETUP) || (present == ACCESS)  ? data_inter  : 16'd0   ;

endmodule
