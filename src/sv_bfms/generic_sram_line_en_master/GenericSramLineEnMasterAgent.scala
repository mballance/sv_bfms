package sv_bfms.generic_sram_line_en_master

import chisel3.Bool
import chisel3.Bundle
import chisel3.Clock
import chisel3.Input
import chisel3.Module
import chisel3.Output
import chisel3.UInt
import chisel3.core.BlackBox
import chisel3.fromIntToWidth
import chisellib.factory.ModuleFactory
import std_protocol_if.GenericSramLineEnIf

class GenericSramLineEnMasterAgent(
    val p : GenericSramLineEnIf.Parameters = new GenericSramLineEnIf.Parameters()
    ) extends Module {
  
  val io = IO(new Bundle {
    val i = new GenericSramLineEnIf(p)
  })

  val bfm = Module(new generic_sram_line_en_master_bfm(p))
  
  bfm.io.clock := clock
  bfm.io.reset := reset
  io.i.addr := bfm.io.addr
  bfm.io.read_data := io.i.read_data
  io.i.write_data := bfm.io.write_data
  io.i.write_en := bfm.io.write_en
  io.i.read_en := bfm.io.read_en
  
}

object GenericSramLineEnMasterAgent extends ModuleFactory[GenericSramLineEnMasterAgent] {
  
}

class generic_sram_line_en_master_bfm(
    val p : GenericSramLineEnIf.Parameters) extends BlackBox {
 
  val io = IO(new Bundle {
    val clock = Input(Clock())
    val reset = Input(Bool())
    val addr = Output(UInt(p.NUM_ADDR_BITS.W))
    val read_data = Input(UInt(p.NUM_DATA_BITS.W))
    val write_data = Output(UInt(p.NUM_DATA_BITS.W))
    val write_en = Output(Bool())
    val read_en = Output(Bool())
  })
}

//object generic_sram_line_en_master_bfm extends ModuleFactory[generic_sram_line_en_master_bfm] {
  
//}