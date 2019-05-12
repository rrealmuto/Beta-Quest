.org 0x8004BE30

.definelabel VROM_CODE, 0x3480000	// addr of code //MUST BE 0x01 0000 aligned!
.definelabel VROM_CODE_SIZE, 0x0B00	// MUST NOT BE GREATER THAN 0x7FFF!
.definelabel VROM_CODE_ADDR, 0x001DAFA0
.definelabel VROM_CODE_VADDR, 0x80000000 | VROM_CODE_ADDR

// a0 = Global Context

	addiu	$sp, $sp, 0xFFD0 //safety stack push
	sw  	a0, 0x0030($sp)
	sw		$ra, 0x002C($sp)
	li		t0, VROM_CODE_VADDR
	sw		t0, 0x0028($sp)
	
	li  	a0, VROM_CODE_VADDR
	li  	a1, VROM_CODE
	jal 	0x0DF0
	li		a2, VROM_CODE_SIZE
	
	lw 		a0, 0x0028($sp)
	jal 	0x3440 // osWritebackDCache
	li		a1, VROM_CODE_SIZE
	
	lw 		a0, 0x0028($sp)
	jal		0x41A0 // osInvalICache
	li		a1, VROM_CODE_SIZE
	
	jal		VROM_CODE_ADDR 
	lw  	a0, 0x0030($sp)
	
	lw  	a0, 0x0030($sp)
	lw		$ra, 0x002C($sp)
	addiu   $sp, $sp, 0x30
// hook back
	addiu   $sp, $sp, 0xFF70
	j		0x9A758
	sw  	s2, 0x0028($sp)
	
// for convenience, here's the hook
//	j		0x4BE30
