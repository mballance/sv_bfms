package sv_bfms.axi4.qvip

import chisel3._
import chisel3.experimental._
import std_protocol_if.AXI4
import sv_bfms.axi4.Axi4MasterAgent
import sv_bfms.axi4.Axi4MonitorAgent

class Axi4QvipMonitorAgent(p : AXI4.Parameters=new AXI4.Parameters) 
  extends Axi4MonitorAgent(p) {
  
  val qvip = Module(new axi4_qvip_monitor(p))
  
  qvip.io.ACLK := clock
/*
  when (reset === Bool(true)) {
    qvip.io.ARESETn := Bool(false)
  } .otherwise {
    qvip.io.ARESETn := Bool(true)
  }
 */
  io.i.awreq.AWVALID := qvip.io.AWVALID
  io.i.awreq.AWADDR := qvip.io.AWADDR
  io.i.awreq.AWPROT := qvip.io.AWPROT
  io.i.awreq.AWREGION := qvip.io.AWREGION
  io.i.awreq.AWLEN := qvip.io.AWLEN
  io.i.awreq.AWSIZE := qvip.io.AWSIZE
  io.i.awreq.AWBURST := qvip.io.AWBURST
  io.i.awreq.AWLOCK := qvip.io.AWLOCK
  io.i.awreq.AWCACHE := qvip.io.AWCACHE
  io.i.awreq.AWQOS := qvip.io.AWQOS
  io.i.awreq.AWID := qvip.io.AWID
  qvip.io.AWREADY := io.i.awready
  
  io.i.arreq.ARVALID := qvip.io.ARVALID
  io.i.arreq.ARADDR := qvip.io.ARADDR
  io.i.arreq.ARPROT := qvip.io.ARPROT
  io.i.arreq.ARREGION := qvip.io.ARREGION
  io.i.arreq.ARLEN := qvip.io.ARLEN
  io.i.arreq.ARSIZE := qvip.io.ARSIZE
  io.i.arreq.ARBURST := qvip.io.ARBURST
  io.i.arreq.ARLOCK := qvip.io.ARLOCK
  io.i.arreq.ARCACHE := qvip.io.ARCACHE
  io.i.arreq.ARQOS := qvip.io.ARQOS
  io.i.arreq.ARID := qvip.io.ARID
  qvip.io.ARREADY := io.i.arready
  
  qvip.io.RVALID := io.i.rresp.RVALID
  qvip.io.RDATA := io.i.rresp.RDATA
  qvip.io.RRESP := io.i.rresp.RRESP
  qvip.io.RLAST := io.i.rresp.RLAST
  qvip.io.RID := io.i.rresp.RID
  qvip.io.RUSER := Bool(false)
  io.i.rready := qvip.io.RREADY
  
  io.i.wreq.WVALID := qvip.io.WVALID
  io.i.wreq.WDATA := qvip.io.WDATA
  io.i.wreq.WSTRB := qvip.io.WSTRB
  io.i.wreq.WLAST := qvip.io.WLAST
  qvip.io.WREADY := io.i.wready
  
  qvip.io.BVALID := io.i.brsp.BVALID
  qvip.io.BID := io.i.brsp.BID
  qvip.io.BUSER := Bool(false)
  io.i.bready := qvip.io.BREADY
}

class axi4_qvip_monitor(p : AXI4.Parameters) extends BlackBox(Map(
    "ADDR_WIDTH" -> p.ADDR_WIDTH.toInt,
    "DATA_WIDTH" -> p.DATA_WIDTH.toInt,
    "ID_WIDTH" -> p.ID_WIDTH.toInt,
    "USER_WIDTH" -> 1,
    "REGION_MAP_SIZE" -> 16
    )
    ) {
  
  val io = IO(new Bundle {
    val ACLK = Input(Clock())
    val ARESETn = Input(Bool())
    val AWVALID = Input(Bool())
    val AWADDR = Input(UInt(p.ADDR_WIDTH.W))
    val AWPROT = Input(UInt(3.W))
    val AWREGION = Input(UInt(4.W))
    val AWLEN = Input(UInt(8.W))
    val AWSIZE = Input(UInt(3.W))
    val AWBURST = Input(UInt(2.W))
    val AWLOCK = Input(Bool())
    val AWCACHE = Input(UInt(4.W))
    val AWQOS = Input(UInt(4.W))
    val AWID = Input(UInt(p.ID_WIDTH.W))
    val AWUSER = Input(Bool())
    val AWREADY = Input(Bool())
    val ARVALID = Input(Bool())
    val ARADDR = Input(UInt(p.ADDR_WIDTH.W))
    val ARPROT = Input(UInt(3.W))
    val ARREGION = Input(UInt(4.W))
    val ARLEN = Input(UInt(8.W))
    val ARSIZE = Input(UInt(3.W))
    val ARBURST = Input(UInt(2.W))
    val ARLOCK = Input(Bool())
    val ARCACHE = Input(UInt(4.W))
    val ARQOS = Input(UInt(4.W))
    val ARID = Input(UInt(p.ID_WIDTH.W))
    val ARUSER = Input(Bool())
    val ARREADY = Input(Bool())
    val RVALID = Input(Bool())
    val RDATA = Input(UInt(p.DATA_WIDTH.W))
    val RRESP = Input(UInt(2.W))
    val RLAST = Input(Bool())
    val RID = Input(UInt(p.ID_WIDTH.W))
    val RUSER = Input(Bool())
    val RREADY = Input(Bool())
    val WVALID = Input(Bool())
    val WDATA = Input(UInt(p.DATA_WIDTH.W))
    val WSTRB = Input(UInt((p.DATA_WIDTH/8).W))
    val WLAST = Input(Bool())
    val WUSER = Input(Bool())
    val WREADY = Input(Bool())
    val BVALID = Input(Bool())
    val BRESP = Input(UInt(2.W))
    val BID = Input(UInt(p.ID_WIDTH.W))
    val BUSER = Input(Bool())
    val BREADY = Input(Bool())
  })
  
}
