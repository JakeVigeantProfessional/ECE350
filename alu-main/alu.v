module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire [31:0] addRes, andRes, orRes, sllRes, sraRes, subRes;
    wire doSub;

    //addition/subtraction result
    //cla_full_adder(x, y, c_in, p, g, s);
    //use cin to add on 1 if subtraction
    
    //adder cla_full_adder(data_operandA, data_operandB, doSu4b, p, g, addResult);
    wire ovf;
    cla_full_adder aluAdder(data_operandA, inputB, ctrl_ALUopcode[0], addRes, ovf);
    //subtraction result
    //invert input b
    //module mux_2(out, select, in0, in1);
    wire [31:0] inverted_B;
    bit_inverter aluInv(data_operandB, inverted_B);

    wire [31:0] inputB;
    mux_2 chooseSubt(inputB, ctrl_ALUopcode[0], data_operandB, inverted_B);

    //and result
    bitwise_and aluAnd(data_operandA, data_operandB, andRes);


    //or result
    bitwise_or aluOR(data_operandA, data_operandB, orRes);

    //sll result
    //module left_barrel_shifter (data, amt, out);
    left_barrel_shifter aluLeft(data_operandA,ctrl_shiftamt,sllRes);
    //sra result
    right_barrel_shifter aluRight(data_operandA,ctrl_shiftamt,sraRes);

    // use 8 bit mux to select output based on opcode
    //mux_8(in0,in1,in2,in3,in4,in5,in6,in7, out, select);
    mux_8 resultSelection(addRes, addRes, andRes, orRes, sllRes, sraRes, 32'b0, 32'b0, data_result, ctrl_ALUopcode[2:0]);

    assign isNotEqual  = 1'b0;
    assign isLessThan  = 1'b0;
    assign overflow = 1'b0;
endmodule