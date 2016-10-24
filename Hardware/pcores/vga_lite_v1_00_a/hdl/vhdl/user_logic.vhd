------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Fri Jan 24 13:48:46 2014 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_NUM_REG                    -- Number of software accessible registers
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_NUM_REG                      : integer              := 4;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------

	--VGA DRIVER PORTS
	VGA_PIXCLK: in std_logic;
	VGA_RED: out std_logic_vector(3 downto 0);
	VGA_GRN: out std_logic_vector(3 downto 0);
	VGA_BLU: out std_logic_vector(3 downto 0);
	VGA_HSY: out std_logic;
	VGA_VSY: out std_logic;	
	--FRAMEBUFFER0 PORTS
	FB0_Rst: out std_logic;
	FB0_Clk: out std_logic; 
	FB0_En: out std_logic; 
	FB0_WE: out std_logic_vector(3 downto 0); 
	FB0_Addr: out std_logic_vector(31 downto 0);
	FB0_WrData: out std_logic_vector(31 downto 0);
	FB0_RdData: in std_logic_vector(31 downto 0); 
	--FRAMEBUFFER1 PORTS
	FB1_Rst: out std_logic;
	FB1_Clk: out std_logic; 
	FB1_En: out std_logic; 
	FB1_WE: out std_logic_vector(3 downto 0); 
	FB1_Addr: out std_logic_vector(31 downto 0);
	FB1_WrData: out std_logic_vector(31 downto 0);
	FB1_RdData: in std_logic_vector(31 downto 0);	
	--END


    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --USER signal declarations added here, as needed for user logic

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal slv_reg0                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg1                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg2                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg3                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg_write_sel              : std_logic_vector(3 downto 0);
  signal slv_reg_read_sel               : std_logic_vector(3 downto 0);
  signal slv_ip2bus_data                : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;


------------------------------------------------------------------------------
--VGA
	constant UNSIGNED_NULL: unsigned(11 downto 0) := (others => '0');	
	
	signal regHSY: std_logic := '1';	--active low
	signal regVSY: std_logic := '1';	--active low
	signal regRED: std_logic_vector(3 downto 0) := "0000";
	signal regGRN: std_logic_vector(3 downto 0) := "0000";
	signal regBLU: std_logic_vector(3 downto 0) := "0000";
	
	signal Hcntr: unsigned(11 downto 0) := (others => '0');
	signal Vcntr: unsigned(11 downto 0) := (others => '0');
		
	signal   C_HVISIBLE    : unsigned(11 downto 0);
	signal   C_H_SYNC_START  : unsigned(11 downto 0);
	signal   C_H_SYNC_END    : unsigned(11 downto 0);
	signal   C_H_CNTR_MAX        : unsigned(11 downto 0);

	signal   C_VVISIBLE    : unsigned(11 downto 0);
	signal   C_V_SYNC_START  : unsigned(11 downto 0);
	signal   C_V_SYNC_END    : unsigned(11 downto 0);
	signal   C_V_CNTR_MAX        : unsigned(11 downto 0);
	
	signal fbEnable: std_logic := '0';
	signal fbID: std_logic := '0';
	signal fbDataIn: std_logic_vector(31 downto 0);	
	
	signal fbWordAddr: unsigned(31 downto 0) := (others => '0');	
	signal fbWordAddrDiv: unsigned(3 downto 0) := "0000";
	
	signal xCounter: unsigned(3 downto 0) := (others => '0');
begin

--========================================================================================
--VGA DRIVER BEGIN
--========================================================================================		
-------------------------
--framebuffer static setup
-------------------------
	FB0_Rst <= '0';
	FB0_Clk <= VGA_PIXCLK;
	FB0_En <= '1';
	
	FB1_Rst <= '0';
	FB1_Clk <= VGA_PIXCLK;
	FB1_En <= '1';
	
	FB0_WE <= "0000";
	FB1_WE <= "0000";
	
	FB0_WrData <= (others => '0');
	FB1_WrData <= (others => '0');
	
-------------------------
--framebuffer dynamic setup
-------------------------
	FB0_Addr <= std_logic_vector(fbWordAddr);
	FB1_Addr <= std_logic_vector(fbWordAddr);		
	--multiplexer frame id
	fbDataIn <= FB0_RdData when (fbID = '0') else FB1_RdData;	
	
	--buffer outputs
	VGA_HSY <= regHSY;
	VGA_VSY <= regVSY;
	VGA_RED <= regRED;
	VGA_GRN <= regGRN;
	VGA_BLU <= regBLU;
  
	
-------------------------
--VGA TIMINGS see
--martin.hinner.info/vga/timing.html  
-------------------------
	C_HVISIBLE		<= UNSIGNED_NULL + 640;
	C_H_SYNC_START  <= UNSIGNED_NULL + 640+16;
	C_H_SYNC_END    <= UNSIGNED_NULL + 640+16+96;
	C_H_CNTR_MAX    <= UNSIGNED_NULL + 640+16+96+48-1;
	
	C_VVISIBLE    	<= UNSIGNED_NULL + 480;
	C_V_SYNC_START  <= UNSIGNED_NULL + 480+10;
	C_V_SYNC_END    <= UNSIGNED_NULL + 480+10+2;
	C_V_CNTR_MAX    <= UNSIGNED_NULL + 480+10+2+33-1;
	
			  
-------------------------  
--SYNC PROCESS
-------------------------
	process(VGA_PIXCLK)
	begin
		if( rising_edge(VGA_PIXCLK) )then	
																		
			if Vcntr >=	C_VVISIBLE or Hcntr >= C_HVISIBLE then
				regRED <= (others => '0');
				regGRN <= (others => '0');
				regBLU <= (others => '0');								
         else			
				--x,y in [0,0]::[639,479]
				--encode word
				--if disabled write 0
				case xCounter is 				
					when "0000" => 						
						regRED <= ( others => (fbEnable and fbDataIn(31)) );
						regGRN <= ( others => (fbEnable and fbDataIn(30)) );
						regBLU <= ( others => (fbEnable and fbDataIn(29)) );
					when "0001" => 						
						regRED <= ( others => (fbEnable and fbDataIn(28)) );
						regGRN <= ( others => (fbEnable and fbDataIn(27)) );
						regBLU <= ( others => (fbEnable and fbDataIn(26)) );												
					when "0010" => 						
						regRED <= ( others => (fbEnable and fbDataIn(25)) );
						regGRN <= ( others => (fbEnable and fbDataIn(24)) );
						regBLU <= ( others => (fbEnable and fbDataIn(23)) );												
					when "0011" => 						
						regRED <= ( others => (fbEnable and fbDataIn(22)) );
						regGRN <= ( others => (fbEnable and fbDataIn(21)) );
						regBLU <= ( others => (fbEnable and fbDataIn(20)) );												
					when "0100" => 						
						regRED <= ( others => (fbEnable and fbDataIn(19)) );
						regGRN <= ( others => (fbEnable and fbDataIn(18)) );
						regBLU <= ( others => (fbEnable and fbDataIn(17)) );												
					when "0101" => 						
						regRED <= ( others => (fbEnable and fbDataIn(16)) );
						regGRN <= ( others => (fbEnable and fbDataIn(15)) );
						regBLU <= ( others => (fbEnable and fbDataIn(14)) );											
					when "0110" => 		
						regRED <= ( others => (fbEnable and fbDataIn(13)) );
						regGRN <= ( others => (fbEnable and fbDataIn(12)) );
						regBLU <= ( others => (fbEnable and fbDataIn(11)) );						
					when "0111" => 
						regRED <= ( others => (fbEnable and fbDataIn(10)) );
						regGRN <= ( others => (fbEnable and fbDataIn(9)) );
						regBLU <= ( others => (fbEnable and fbDataIn(8)) );						
					when "1000" => 
						regRED <= ( others => (fbEnable and fbDataIn(7)) );
						regGRN <= ( others => (fbEnable and fbDataIn(6)) );
						regBLU <= ( others => (fbEnable and fbDataIn(5)) );						
					when "1001" => 
						regRED <= ( others => (fbEnable and fbDataIn(4)) );
						regGRN <= ( others => (fbEnable and fbDataIn(3)) );
						regBLU <= ( others => (fbEnable and fbDataIn(2)) );						
					when others => 
						regRED <= "1111";
						regGRN <= "1111";
						regBLU <= "1111";
				end case;	
				
				--bram wordaddr needs to clock cycles
				--before FbDataIn is valid
				if( xCounter = 8 )then
					fbWordAddr <= fbWordAddr + 4;
				end if;
				
				--next clock cycle, fbDatain is valid
				--reset/inc counter
				if( xCounter = 9 )then
					xCounter <= (others => '0');					
				else	
					xCounter <= xCounter + 1;
				end if;		
				
				--end of visible screen-> reset BRAM Addr
				if( Hcntr = 639 and Vcntr = 479 )then
					fbWordAddr <= (others => '0');
				end if;
			end if;	
	    
         --sync active low
         if( Vcntr = C_V_SYNC_START )then 
            regVSY <= '0';
         elsif( Vcntr = C_V_SYNC_END )then
            regVSY <= '1';
         end if;

         if( Hcntr = C_H_SYNC_START )then 
            regHSY <= '0';
         elsif( Hcntr = C_H_SYNC_END )then
            regHSY <= '1';
         end if;	

         
		 
		 --inc counters
         if( Hcntr = C_H_CNTR_MAX )then
            -- starting a new line
            Hcntr <= (others => '0');
            if( Vcntr = C_V_CNTR_MAX )then
               Vcntr <= (others => '0');					
					--start new frame					
					--check if user wants to enable vga
					--check which framebuffer to select
					fbEnable <= slv_reg0(0);
					fbID <= slv_reg0(1);					
            else
               Vcntr <= Vcntr + 1;					
            end if;
         else
            Hcntr <= Hcntr + 1;					
         end if;
		
		end if;	
	end process;	

--========================================================================================
--VGA DRIVER END
--========================================================================================
  ------------------------------------------
  -- Example code to read/write user logic slave model s/w accessible registers
  -- 
  -- Note:
  -- The example code presented here is to show you one way of reading/writing
  -- software accessible registers implemented in the user logic slave model.
  -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  -- to one software accessible register by the top level template. For example,
  -- if you have four 32 bit software accessible registers in the user logic,
  -- you are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  --                     "1000"   C_BASEADDR + 0x0
  --                     "0100"   C_BASEADDR + 0x4
  --                     "0010"   C_BASEADDR + 0x8
  --                     "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
  slv_reg_write_sel <= Bus2IP_WrCE(3 downto 0);
  slv_reg_read_sel  <= Bus2IP_RdCE(3 downto 0);
  slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3);
  slv_read_ack      <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3);

  
  
  
  
  
  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Resetn = '0' then
        slv_reg0 <= (others => '0');
        slv_reg1 <= (others => '0');
        slv_reg2 <= (others => '0');
        slv_reg3 <= (others => '0');
      else
        case slv_reg_write_sel is
          when "1000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg0(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "0100" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg1(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "0010" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg2(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "0001" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg3(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, slv_reg0, slv_reg1, slv_reg2, slv_reg3 ) is
  begin

    case slv_reg_read_sel is
      when "1000" => slv_ip2bus_data <= slv_reg0;
      when "0100" => slv_ip2bus_data <= slv_reg1;
      when "0010" => slv_ip2bus_data <= slv_reg2;
      when "0001" => slv_ip2bus_data <= slv_reg3;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else
                  (others => '0');

  IP2Bus_WrAck <= slv_write_ack;
  IP2Bus_RdAck <= slv_read_ack;
  IP2Bus_Error <= '0';

end IMP;
