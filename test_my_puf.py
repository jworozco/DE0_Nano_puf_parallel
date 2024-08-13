# test_my_design.py (extended)

import cocotb
from cocotb.triggers import FallingEdge, Timer
from cocotb.types import Bit,Logic, LogicArray


async def generate_clock(dut):
    """Generate clock pulses."""

    for cycle in range(100):
        dut.CLOCK_50.value = 0
        await Timer(1, units="ns")
        dut.CLOCK_50.value = 1
        await Timer(1, units="ns")

async def reset_dut(dut, duration_ns):
    """Start with reset asserted and then de-assert it"""
    dut.SW.value = 1
    await Timer(duration_ns, units="ns")
    dut.SW.value = 0
    dut.SW._log.debug("Reset complete")


@cocotb.test()
async def my_first_test(dut):

    await cocotb.start(generate_clock(dut))  # run the clock "in the background"
    await cocotb.start(reset_dut(dut, 3))    # run reset in the background after 3 cycles get out of reset

    dut.KEY.value = 3

    await Timer(6, units="ns")  # wait a bit

    for i in range(2):
        dut.KEY.value = 2
        await Timer(2, units="ns")  # wait a bit
        dut.KEY.value = 3
        await Timer(2, units="ns")  # wait a bit
        dut.KEY.value = 1
        await Timer(2, units="ns")  # wait a bit
        dut.KEY.value = 3
        await Timer(2, units="ns")  # wait a bit

    await Timer(6, units="ns")  # wait a bit


    await Timer(32, units="ns")  # wait for multiplication to complete
    await FallingEdge(dut.CLOCK_50)  # wait for falling edge/"negedge"

    #dut.soc_top._log.info("PC is %s", int(dut.soc_top.PC.value))
    assert dut.ps.value == 3, "PS is not 2!"