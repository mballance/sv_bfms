package sv_bfms.axi4

import chisel3._
import std_protocol_if.AXI4
import sv_bfms.axi4.qvip.Axi4QvipMasterAgent
import sv_bfms.axi4.qvip.Axi4QvipMonitorAgent

class Axi4MonitorAgent(val p : AXI4.Parameters = new AXI4.Parameters) extends Module {
  val io = IO(new Bundle {
    val i = Input(new AXI4(p))
  })
}

object Axi4MonitorAgent {
  def apply(p : AXI4.Parameters) : Axi4MonitorAgent = {
    // TODO: switch
    Module(new Axi4QvipMonitorAgent(p))
  }
}