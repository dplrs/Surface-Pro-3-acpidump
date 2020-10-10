/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20190509 (64-bit version)
 * Copyright (c) 2000 - 2019 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of ssdt2.dat, Sat Oct 10 17:24:16 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000047E (1150)
 *     Revision         0x01
 *     Checksum         0x91
 *     OEM ID           "OEMC"
 *     OEM Table ID     "Ult0Rtd3"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20120913 (538052883)
 */
DefinitionBlock ("", "SSDT", 1, "OEMC", "Ult0Rtd3", 0x00001000)
{
    /*
     * iASL Warning: There were 2 external control methods found during
     * disassembly, but only 0 were resolved (2 unresolved). Additional
     * ACPI tables may be required to properly disassemble the code. This
     * resulting disassembler output file may not compile because the
     * disassembler did not know how many arguments to assign to the
     * unresolved methods. Note: SSDTs can be dynamically loaded at
     * runtime and may or may not be available via the host OS.
     *
     * In addition, the -fe option can be used to specify a file containing
     * control method external declarations with the associated method
     * argument counts. Each line of the file must be of the form:
     *     External (<method pathname>, MethodObj, <argument count>)
     * Invocation:
     *     iasl -fe refs.txt -d dsdt.aml
     *
     * The following methods were unresolved and many not compile properly
     * because the disassembler had to guess at the number of arguments
     * required for each:
     */
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.HDEF, DeviceObj)
    External (_SB_.PCI0.RP01.WIFI, DeviceObj)
    External (_SB_.PCI0.SAT0, DeviceObj)
    External (_SB_.PCI0.XHC_, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB, DeviceObj)
    External (_SB_.PEPD, UnknownObj)
    External (_SB_.RDGP, UnknownObj)
    External (_SB_.WTGP, MethodObj)    // Warning: Unknown method, guessing 2 arguments
    External (ADBG, MethodObj)    // Warning: Unknown method, guessing 1 arguments
    External (BID_, UnknownObj)
    External (BSPC, UnknownObj)
    External (BWT1, UnknownObj)
    External (GO27, UnknownObj)
    External (GS27, UnknownObj)
    External (HDAD, UnknownObj)
    External (MEMB, UnknownObj)
    External (RTD3, UnknownObj)
    External (S0ID, UnknownObj)
    External (VRSD, UnknownObj)

    Name (LONT, Zero)
    Method (SGON, 2, Serialized)
    {
        If ((\_SB.RDGP != Arg0))
        {
            Arg1
            Local0 = ((Timer - \LONT) / 0x2710)
            If ((Local0 < \VRSD))
            {
                Sleep ((\VRSD - Local0))
            }

            \_SB.WTGP (Arg0, Arg1)
            \LONT = Timer
            Return (One)
        }
        Else
        {
            Return (Zero)
        }
    }

    If ((((BID == BWT1) || (BID == BSPC)) && (RTD3 == One)))
    {
        Scope (\_SB)
        {
            PowerResource (PRWF, 0x05, 0x0000)
            {
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }

                Method (_ON, 0, NotSerialized)  // _ON_: Power On
                {
                    If (\_OSI ("Windows 2013"))
                    {
                        Notify (\_SB.PCI0.RP01.WIFI, One) // Device Check
                    }
                    Else
                    {
                        \_SB.WTGP (0x08, One)
                        Sleep (0xFA)
                    }
                }

                Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
                {
                    If (\_OSI ("Windows 2013"))
                    {
                        Notify (\_SB.PCI0.RP01.WIFI, One) // Device Check
                    }
                    Else
                    {
                        \_SB.WTGP (0x08, Zero)
                        Sleep (0xFA)
                    }
                }

                Method (_RST, 0, NotSerialized)  // _RST: Device Reset
                {
                    \_SB.PRWF._OFF ()
                    \_SB.PRWF._ON ()
                }
            }
        }

        Scope (\_SB.PCI0.RP01.WIFI)
        {
            Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
            {
                0x1B, 
                0x04
            })
            Name (WKEN, Zero)
            Method (_DSW, 3, NotSerialized)  // _DSW: Device Sleep Wake
            {
                If (Arg1)
                {
                    WKEN = Zero
                }
                ElseIf ((Arg0 && Arg2))
                {
                    WKEN = One
                }
                Else
                {
                    WKEN = Zero
                }
            }

            Name (_PR0, Package (0x01)  // _PR0: Power Resources for D0
            {
                \_SB.PRWF
            })
            Name (_PR3, Package (0x01)  // _PR3: Power Resources for D3hot
            {
                \_SB.PRWF
            })
            Name (_PRR, Package (0x01)  // _PRR: Power Resource for Reset
            {
                \_SB.PRWF
            })
            Method (_S0W, 0, NotSerialized)  // _S0W: S0 Device Wake State
            {
                Return (0x03)
            }

            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                \GO27 = One
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
                \GS27 = One
                \GO27 = Zero
            }
        }

        Scope (\_GPE)
        {
            Method (_L1B, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=0x00-0xFF
            {
                If (\_SB.PCI0.RP01.WIFI.WKEN)
                {
                    \GO27 = One
                }

                Notify (\_SB.PCI0.RP01.WIFI, 0x02) // Device Wake
            }
        }

        Scope (\_SB.PCI0.SAT0)
        {
            Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
        }

        Scope (\_SB.PCI0.XHC)
        {
            Name (UPWR, Zero)
            Name (USPP, Zero)
            Method (_S0W, 0, NotSerialized)  // _S0W: S0 Device Wake State
            {
                Return (0x03)
            }

            Method (_S4W, 0, NotSerialized)  // _S4W: S4 Device Wake State
            {
                Return (0x03)
            }
        }

        Scope (\_SB.PCI0.XHC.RHUB)
        {
            Method (_S0W, 0, NotSerialized)  // _S0W: S0 Device Wake State
            {
                Return (0x03)
            }

            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                USPP = Zero
            }

            Method (_PS2, 0, Serialized)  // _PS2: Power State 2
            {
                OperationRegion (XHCM, SystemMemory, (MEMB & 0xFFFF0000), 0x0600)
                Field (XHCM, DWordAcc, NoLock, Preserve)
                {
                    Offset (0x02), 
                    XHCV,   16, 
                    Offset (0x480), 
                    HP01,   1, 
                    Offset (0x490), 
                    HP02,   1, 
                    Offset (0x4A0), 
                    HP03,   1, 
                    Offset (0x4B0), 
                    HP04,   1, 
                    Offset (0x4C0), 
                    HP05,   1, 
                    Offset (0x4D0), 
                    HP06,   1, 
                    Offset (0x4E0), 
                    HP07,   1, 
                    Offset (0x4F0), 
                    HP08,   1, 
                    Offset (0x510), 
                    SP00,   1, 
                    Offset (0x520), 
                    SP01,   1, 
                    Offset (0x530), 
                    SP02,   1, 
                    Offset (0x540), 
                    SP03,   1
                }

                If ((XHCV == 0xFFFF))
                {
                    Return (Zero)
                }

                If (((HP01 == Zero) && (SP00 == Zero)))
                {
                    USPP |= 0x02
                }

                If (((HP02 == Zero) && (SP01 == Zero)))
                {
                    USPP |= 0x04
                }
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
            }
        }

        Scope (\_SB.PCI0)
        {
            PowerResource (PAUD, 0x00, 0x0000)
            {
                Name (_STA, One)  // _STA: Status
                Method (_ON, 0, NotSerialized)  // _ON_: Power On
                {
                    _STA = One
                }

                Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
                {
                    _STA = Zero
                }
            }
        }

        If (!HDAD)
        {
            Scope (\_SB.PCI0.HDEF)
            {
                Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
                {
                    ADBG ("HDEF DEP Call")
                    If ((S0ID == One))
                    {
                        ADBG ("HDEF DEP")
                        Return (Package (0x01)
                        {
                            \_SB.PEPD
                        })
                    }
                    Else
                    {
                        ADBG ("HDEF DEP NULL")
                        Return (Package (0x00){})
                    }
                }

                Name (_PR0, Package (0x01)  // _PR0: Power Resources for D0
                {
                    \_SB.PCI0.PAUD
                })
                Name (_PR3, Package (0x01)  // _PR3: Power Resources for D3hot
                {
                    \_SB.PCI0.PAUD
                })
            }
        }
    }
}

