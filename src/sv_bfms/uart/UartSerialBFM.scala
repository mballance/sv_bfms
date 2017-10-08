package sv_bfms.uart

import chisel3._
import std_protocol_if.UartIf

class UartSerialBFM extends Module {
  
  val io = IO(new Bundle {
    val s = Flipped(new UartIf())
  })

  val bfm = Module(new uart_serial_bfm())
  
  bfm.io.clk_i := clock
  bfm.io.rst_i := reset
}

class uart_serial_bfm extends BlackBox {
  
  val io = IO(new Bundle {
    val clk_i = Input(Clock())
    val rst_i = Input(Bool())
    val stx_pad_o = Output(Bool())
    val srx_pad_i = Input(Bool())
    val rts_pad_o = Output(Bool())
    val cts_pad_i = Input(Bool())
    val dtr_pad_o = Output(Bool())
    val dsr_pad_i = Input(Bool())
    val ri_pad_i = Input(Bool())
    val dcd_pad_i = Input(Bool())
  })
  
}