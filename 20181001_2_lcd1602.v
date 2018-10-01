
module lcd1602(clk,rst,lcd_e,lcd_rw,lcd_rs,data,led,pot);
input clk,rst;
output  lcd_e;
output reg[3:0]led;
output reg lcd_rw,lcd_rs;
output reg [7:0] data;
output reg pot;
reg [13:0] state;
reg [6:0] count;
reg [639:0] data_in_buf;
reg clk4Hz;
reg [23:0] cnt;
reg [6:0] disp_count;
parameter  SETFUNCTION1    =12'b000000001000;     //工作方式设置
parameter  SETFUNCTION1_1    =12'b000000000011;
parameter  IDLE            =12'b000000000000;
parameter  CLEAR           =12'b000000000001;
parameter  SETDDRAM        =12'b000000000010;
parameter  SETFUNCTION     =12'b000000000100;
parameter  SETFUNCTION2    =12'b000000010000;
parameter  SETFUNCTION2_1  =12'b000000011000;
parameter  SETFUNCTION3    =12'b000000100000;
parameter  SETFUNCTION3_1  =12'b000000110000;
parameter  SETFUNCTION4    =12'b000001000000;
parameter  SETFUNCTION4_1  =12'b000001100000;
parameter  SETSHIFT        =12'b000010000000;     //屏幕左移设置
parameter  SWITCHMODE      =12'b000100000000;     //显示状�?�设�?
parameter  SETMODE         =12'b001000000000;                    //输入方式设置
parameter  SHIFT           =12'b010000000000;
parameter  WRITERAM        =12'b100000000000;
parameter data_in="Zhang Bingbing      Zhang Bingbing      3160105502          3160105502          " ;
always @(posedge clk)
begin
if(cnt%20<5)
	pot<=1'b1;
else pot<=1'b0;
if(cnt==24'hbebc20)  
   begin 
		cnt<=0; 
		clk4Hz<=~clk4Hz;	      
   end
else  
	cnt<=cnt+1;
end

assign lcd_e=clk4Hz;//E 1 I MPU Starts data read/write.

always @(posedge clk4Hz or negedge rst)//when rst negedge(rebound), the working function is triggered.
if(rst) 
begin
	state<=SETFUNCTION1;//reg [13:0] state;      SETFUNCTION1(function setting) =12'b000000001000;
	data_in_buf<=data_in;//the data is stored in the buffer
	disp_count<=7'b0000000;
	led<=4'h0;
end
else  
begin
case(state)
	IDLE:  
	begin  
		state<=IDLE; 
	end

	SETFUNCTION1:  
	begin
		lcd_rs<=0;/*RS 1 I MPU Selects registers.
				0: Instruction register (for write) Busy flag:address counter (for read)
				1: Data register (for write and read)*/
		lcd_rw<=0;//Selects read or write.0: Write	1: Read
		data[7:5]<=3'b001;//30H�?8位�?�线，单行显示，显示5×7的点阵字符�??
		data[4]<=1;
		data[3]<=0;
		data[2]<=0;
		data[1:0]<=2'b00;
		state<=SETFUNCTION2; 
		led<=4'h1;
	end
	

	
	SETFUNCTION2:  
	begin
		lcd_rs<=0;
		lcd_rw<=0;
		data[7:5]<=3'b001;
		data[4]<=1;
		data[3]<=0;
		data[2]<=0;
		data[1:0]<=2'b00;
		state<=SETFUNCTION3; 
		led<=4'h2;
		//lcd_e<=1'b1;
	end
		

	SETFUNCTION3:  
	begin
		lcd_rs<=0;
		lcd_rw<=0;
		data[7:5]<=4'h3;
		data[7:5]<=3'b001;
		data[4]<=1; data[3]<=0;
		data[2]<=0; data[1:0]<=2'b00;		
		state<=SETFUNCTION4; 
		led<=4'h3;
		//lcd_e<=1'b1;
	end
	

	
	SETFUNCTION4:  
	begin
		lcd_rs<=0;
		lcd_rw<=0;
		data[7:5]<=3'b001;
		data[4]<=1; data[3]<=0;
		data[2]<=0; data[1:0]<=2'b00;
		state<=SETFUNCTION;
		led<=4'h4;
		//lcd_e<=1'b1;
	end

	

	SETFUNCTION:  
	begin
		lcd_rs<=0;
		lcd_rw<=0;
		data[4]<=1;data[3]<=1;
		data[2]<=0;data[1:0]<=2'b00;
		state<=SETMODE; 
		led<=4'h5;
	end

	SETMODE:  
	begin
		lcd_rs<=0;
		lcd_rw<=0;
		data[7:2]<=6'b000001;
		data[1]<=1;
		data[0]<=0;
		state<=SWITCHMODE; 
		led<=4'h6;
	end

	SWITCHMODE:  
	begin
		lcd_rs<=0;
		lcd_rw<=0;
		data[7:3]<=5'b00001;
		data[2]<=1;
		data[1]<=0;
		data[0]<=0;
		state<=CLEAR;
		led<=4'h7;
	end

	CLEAR:  
	begin  
		lcd_rs<=0;
		lcd_rw<=0;
		data<=8'h01;
		state<=SETDDRAM; //清除DDRAM的所有单元，光标被移动到屏幕左上角�??
		led<=4'h8;
	end

	SETDDRAM:  
	begin
		lcd_rs<=0;
		lcd_rw<=0;
		data<=8'h80;//?
		state<=WRITERAM; 
		led<=4'h9;
	end   

	SHIFT:  
	begin
		lcd_rs<=1;//RS�?1、RW�?0—�?�表示向LCM写入数据
		lcd_rw<=0;
		data<=data_in_buf[639:632];
		data_in_buf<=(data_in_buf<<8);
		disp_count<=disp_count + 1'b1;
		state<=WRITERAM; 
		led<=4'ha;
	end

	WRITERAM:  
	begin
		lcd_rs<=1;//RS�?1、RW�?0—�?�表示向LCM写入数据
		lcd_rw<=0;
		if(disp_count == 79)  
		begin
			state<=SETSHIFT;
			led<=4'hc;
		end
		else if(disp_count==40)
		begin
			lcd_rs<=0;//S�?0、RW�?0—�?�表示向LCM写入指令
			lcd_rw<=0;
			data<=8'hc0;//?
			state<=SHIFT;
			led<=4'hb;
		end
		else  
		begin
			data<=data_in_buf[639:632];
			data_in_buf<=(data_in_buf<<8);
			disp_count<=disp_count + 1'b1;
			state<=WRITERAM; 
		end
	end

	SETSHIFT:  
	begin
		lcd_rs<=0;
		lcd_rw<=0;
		data[7:4]<=4'b0001;
		data[3]<=1'b1;
		data[2]<=1'b0;
		data[1:0]<=2'b00;
		state<=SETSHIFT; //每输入一次该指令，整体的画面就向左滚动一个字符位�?
		led<=4'hd;
	end
endcase
end
endmodule
