`timescale	1ns/10ps
//TLC
module TLC(
			input clk,
			input reset,
			
			output HG,
			output HY,
			output HR,
			output HRTR,
			output FG,
			output FY,
			output FR,
			output FRTR
			);
	reg [1:0] ST,ST_out;
	reg [2:0] state,next_state;
	
	parameter S0=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100,S5=3'b101;
	assign HG=(state==S0);
	assign HY=(state==S1);
	assign HR=((state==S2)||(state==S3)||(state==S4)||(state==S5));
	assign HRTR=(state==S2);
	assign FG=(state==S3);
	assign FY=(state==S4);
	assign FR=((state==S0)||(state==S1)||(state==S2)||(state==S5));
	assign FRTR=(state==S5);

//seq
	always@(posedge clk)
	begin
		if(reset)begin
			state<=S0;
			ST_out<=0;
		end
		else begin
			state<=next_state;
			ST_out<=ST;
		end
	end
	
	wire TS,TL,T_TR;
	counter counter0(.ST_out(ST_out),.reset(reset),.clk(clk),.TL(TL),.TS(TS),.T_TR(T_TR));
	
	
//comb
	always@(*)
	begin
		case(state)
		S0:	if(TL)begin
				next_state=S1;
				ST=2'b01;
				end
			else begin
				next_state=S0;
				ST=2'b00;
				end
		
		S1:	if(TS)begin
				next_state=S2;
				ST=2'b10;
			end
			else begin
				next_state=S1;
				ST=2'b01;
				end
	
		S2:	if(T_TR)begin
				next_state=S3;
				ST=2'b00;
				end
			else begin
				next_state=S2;
				ST=2'b10;
				end

		S3:	if(TL)begin
				next_state=S4;
				ST=2'b01;
				end
			else begin
				next_state=S3;
				ST=2'b00;
				end
		
		S4:	if(TS)begin
				next_state=S5;
				ST=2'b10;
				end
			else begin
				next_state=S4;
				ST=2'b01;
				end
				
		S5:	if(T_TR)begin
				next_state=S0;
				ST=2'b00;
				end
			else begin
				next_state=S5;
				ST=2'b10;
				end
				
		default: if(TL)begin
					next_state=S1;
					ST=2'b01;
					end
				 else begin
					next_state=S0;
					ST=2'b00;
					end
		
		endcase
	end	
endmodule	


//counter
module counter(
				input [1:0] ST_out,
				input reset,
				input clk,
				
				output TL,
				output TS,
				output T_TR
				);

reg [2:0]timer;
reg timer_clr;
assign  TL=((timer==3'd5)&&(timer_clr==1'b1))?1:0;
assign  TS=((timer==3'd3)&&(timer_clr==1'b1))?1:0;
assign  T_TR=((timer==3'd2)&&(timer_clr==1'b1))?1:0;
always@(posedge clk)
begin
	if(reset)begin
		timer<=3'd0;
		end
	else if(timer_clr==1'b1)begin
			timer<=0;
			end
		else begin
			timer<=timer+1;
			end
end

always@(*)
begin
    case(ST_out)   
        2'd0:
            if(timer==3'd5)begin
                timer_clr=1'b1;
				end
            else begin
                timer_clr=1'b0;
				end
        2'd1:
            if(timer==3'd3)begin
                timer_clr=1'b1;
				end
            else begin
                timer_clr=1'b0;
				end
        2'd2:
            if(timer==3'd2)begin
                timer_clr=1'b1;
				end
            else begin
                timer_clr=1'b0;
				end
        default:
            if(timer==3'd5)begin
                timer_clr=1'b1;
				end
            else begin
                timer_clr=1'b0;
				end
    endcase
end
endmodule