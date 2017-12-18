package sv_bfms.axi4

import chisel3.Bundle
import chisel3.Module
import std_protocol_if.AXI4
import sv_bfms.axi4.qvip.Axi4QvipMasterAgent
import chisellib.factory.ModuleFactory

class Axi4MasterAgent(val p : AXI4.Parameters = new AXI4.Parameters) extends Module {
  val io = IO(new Bundle {
    val i = new AXI4(p)
  })
}

object Axi4MasterAgent extends ModuleFactory[Axi4MasterAgent] {
  def apply(p : AXI4.Parameters) : Axi4MasterAgent = {
    // TODO: switch
    Module(new Axi4QvipMasterAgent(p))
  }
}