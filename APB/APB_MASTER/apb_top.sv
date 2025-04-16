`include "apb_master.sv"
`include "apb_slave.sv"

module apb_top( 
                    input               clk        ,
                    input               rst_n      , 
                    input               start      ,
 					input   [3:0]     	addr       ,
  					input   [15:0]      data       ,
                    input               write      
                    
);
                   
                   wire            pclk       ; 
                   wire            preset_n   ;
                   wire            pselx      ;
                   wire            penable    ;
                   wire [3:0]      paddr      ;
                   wire            pwrite     ;
                   wire [15:0]     pwdata     ;
                   wire [15:0]     data_out   ;
                   wire            pready     ;
                   wire [15:0]     prdata     ; 

                  assign pclk = clk		  ;
  				  assign preset_n = rst_n;   


apb_master master(  
                  .pclk    ( pclk               )   ,
                  .preset_n( preset_n           )   , 
                  .start   ( start              )   ,
  				  .data    ( data               )   ,
                  .write   ( write              )   ,
                  .pready  ( pready             )   ,
                  .prdata  ( prdata             )   ,
                  .pselx   ( pselx              )   ,
                  .penable ( penable            )   ,
                  .paddr   ( paddr              )   ,
                  .pwrite  ( pwrite             )   ,
                  .pwdata  ( pwdata             )   ,
  				  .data_out( data_out           )   ,
 				  .addr	   ( addr				)

    );

apb_slave slave(
				.pselx	( pselx	     )  ,
				.penable( penable    )  ,
				.pwrite	( pwrite     ) 	,
    			.pwdata	( pwdata     ) 	,
                .paddr	( paddr	     ) 	,
                .pclk	( pclk	     ) 	,
                .prst_n	( preset_n   ) 	,
                .pready	( pready     ) 	,
                .prdata	( prdata	 ) 				       
                  
                 );	

endmodule


