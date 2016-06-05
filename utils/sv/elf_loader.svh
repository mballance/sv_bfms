/****************************************************************************
 * elf_loader.svh
 ****************************************************************************/
class elf_loader;
	const string					ID = "elf_loader";
	`define EI_NIDENT 16
	
	const int	SHT_NULL			= 0;	/* sh_type */
	const int	SHT_PROGBITS		= 1;
	const int	SHT_SYMTAB			= 2;
	const int	SHT_STRTAB			= 3;
	const int	SHT_RELA			= 4;
	const int	SHT_HASH			= 5;
	const int	SHT_DYNAMIC			= 6;
	const int	SHT_NOTE			= 7;
	const int	SHT_NOBITS			= 8;
	const int	SHT_REL				= 9;
	const int	SHT_SHLIB			= 10;
	const int	SHT_DYNSYM			= 11;
	const int	SHT_UNKNOWN12		= 12;
	const int	SHT_UNKNOWN13		= 13;
	const int	SHT_INIT_ARRAY		= 14;
	const int	SHT_FINI_ARRAY		= 15;
	const int	SHT_PREINIT_ARRAY	= 16;
	const int	SHT_GROUP			= 17;
	const int	SHT_SYMTAB_SHNDX	= 18;
	const int	SHT_NUM				= 19;

	const int SHF_WRITE =          (1 << 0);     /* Writable */
	const int SHF_ALLOC =          (1 << 1);     /* Occupies memory during execution */
	const int SHF_EXECINSTR =      (1 << 2);     /* Executable */
	const int SHF_MERGE     =      (1 << 4);     /* Might be merged */
	const int SHF_STRINGS   =      (1 << 5);     /* Contains nul-terminated strings */
	const int SHF_INFO_LINK =      (1 << 6);     /* `sh_info' contains SHT index */
	const int SHF_LINK_ORDER =     (1 << 7);     /* Preserve order after combining */
	const int SHF_OS_NONCONFORMING = (1 << 8);   /* Non-standard OS specific handling
                                           required */
	const int SHF_GROUP           =  (1 << 9);   /* Section is member of a group.  */
	const int SHF_TLS             =  (1 << 10);  /* Section hold thread-local data.  */
	const int SHF_MASKOS          =  'h0ff00000; /* OS-specific.  */
	const int SHF_MASKPROC        =  'hf0000000; /* Processor-specific */
	const int SHF_ORDERED         =  (1 << 30);  /* Special ordering requirement
                                           (Solaris).  */
	const int SHF_EXCLUDE         =  (1 << 31);  /* Section is excluded unless
                                           referenced or allocated (Solaris).
                                           referenced or allocated (Solaris).
                                           */
	
	
	const int ElfHeader_SZ  = 52;
	const int Elf32_Phdr_SZ = 32;
	const int Elf32_Shdr_SZ = 40;
	
	typedef struct {
		bit[7:0]  	e_ident[`EI_NIDENT]; /* bytes 0 to 15  */
		bit[15:0] 	e_e_type;           /* bytes 15 to 16 */
		bit[15:0] 	e_machine;          /* bytes 17 to 18 */
		bit[31:0]   e_version;          /* bytes 19 to 22 */
		bit[31:0]   e_entry;            /* bytes 23 to 26 */
		bit[31:0]   e_phoff;            /* bytes 27 to 30 */
		bit[31:0]   e_shoff;            /* bytes 31 to 34 */
		bit[31:0]   e_flags;            /* bytes 35 to 38 */
		bit[15:0] 	e_ehsize;           /* bytes 39 to 40 */
		bit[15:0] 	e_phentsize;        /* bytes 41 to 42 */
		bit[15:0] 	e_phnum;            /* bytes 43 to 44 (2B to 2C) */
		bit[15:0] 	e_shentsize;        /* bytes 45 to 46 */
		bit[15:0] 	e_shnum;            /* bytes 47 to 48 */
		bit[15:0] 	e_shstrndx;         /* bytes 49 to 50 */		
	} ElfHeader;

	/* Program Headers */
	typedef struct {
		bit[31:0] p_type;     /* entry type */
		bit[31:0] p_offset;   /* file offset */
		bit[31:0] p_vaddr;    /* virtual address */
		bit[31:0] p_paddr;    /* physical address */
		bit[31:0] p_filesz;   /* file size */
		bit[31:0] p_memsz;    /* memory size */
		bit[31:0] p_flags;    /* entry flags */
		bit[31:0] p_align;    /* memory/file alignment */
	} Elf32_Phdr;


	/* Section Headers */
	typedef struct {
		bit[31:0] sh_name;        /* section name - index into string table */
		bit[31:0] sh_type;        /* SHT_... */
		bit[31:0] sh_flags;       /* SHF_... */
		bit[31:0] sh_addr;        /* virtual address */
		bit[31:0] sh_offset;      /* file offset */
		bit[31:0] sh_size;        /* section size */
		bit[31:0] sh_link;        /* misc info */
		bit[31:0] sh_info;        /* misc info */
		bit[31:0] sh_addralign;   /* memory alignment */
		bit[31:0] sh_entsize;     /* entry size if table */
	} Elf32_Shdr;
	

	uvm_component					m_comp;
	sv_bfms_rw_api_if				m_mem_if;
	bit								m_big_endian    = 1;
	bit								m_load_ram      = 0;
	bit								m_do_fill		= 0;
	
	function new(
		uvm_component 					c,
		sv_bfms_rw_api_if				mem_if);
		
		m_comp 		= c;
		m_mem_if 	= mem_if;
	endfunction
	
	function bit[15:0] read_16(bit[7:0] data[], inout int idx);
		bit[15:0] ret;
	
		if (m_big_endian) begin
			ret[7:0] = data[idx++];
			ret[15:8] = data[idx++];
		end else begin
			ret[15:8] = data[idx++];
			ret[7:0] = data[idx++];
		end
		
		return ret;
	endfunction
	
	function bit[31:0] read_32(bit[7:0] data[], inout int idx);
		bit[31:0] ret;

		if (m_big_endian) begin
			ret[7:0] = data[idx++];
			ret[15:8] = data[idx++];
			ret[23:16] = data[idx++];
			ret[31:24] = data[idx++];
		end else begin
			ret[31:24] = data[idx++];
			ret[23:16] = data[idx++];
			ret[15:8] = data[idx++];
			ret[7:0] = data[idx++];
		end
		
		return ret;
	endfunction
	
	function ElfHeader read_hdr(int fd);
		ElfHeader hdr;
		int code, idx=0;
		bit[7:0] tmp[] = new[ElfHeader_SZ];
		bit[7:0] tmp_b;
	
		for (int i=0; i<ElfHeader_SZ; i++) begin
			code = $fread(tmp_b, fd, 0, 1);
			tmp[i] = tmp_b;
		end
		
		// TODO: check code
		for (int i=0; i<`EI_NIDENT; i++) begin
			hdr.e_ident[i] = tmp[idx++];
		end
		
		hdr.e_e_type = read_16(tmp, idx);
		hdr.e_machine = read_16(tmp, idx);
		hdr.e_version = read_32(tmp, idx);
		hdr.e_entry = read_32(tmp, idx);
		hdr.e_phoff = read_32(tmp, idx);
		hdr.e_shoff = read_32(tmp, idx);
		hdr.e_flags = read_32(tmp, idx);
		hdr.e_ehsize = read_16(tmp, idx);
		hdr.e_phentsize = read_16(tmp, idx);
		hdr.e_phnum = read_16(tmp, idx);
		hdr.e_shentsize = read_16(tmp, idx);
		hdr.e_shnum = read_16(tmp, idx);
		hdr.e_shstrndx = read_16(tmp, idx);

		return hdr;
	endfunction
	
	function Elf32_Phdr read_phdr(int fd, int offset);
		Elf32_Phdr phdr;
		int code, idx=0;
		bit[7:0] tmp[] = new[Elf32_Phdr_SZ];
		bit[7:0] tmp_b;
		
		void'($fseek(fd, offset, 0));
		
		for (int i=0; i<Elf32_Phdr_SZ; i++) begin
			code = $fread(tmp_b, fd, 0, 1);
			tmp[i] = tmp_b;
		end
		
		phdr.p_type = read_32(tmp, idx);
		phdr.p_offset = read_32(tmp, idx);
		phdr.p_vaddr = read_32(tmp, idx);
		phdr.p_paddr = read_32(tmp, idx);
		phdr.p_filesz = read_32(tmp, idx);
		phdr.p_memsz = read_32(tmp, idx);
		phdr.p_flags = read_32(tmp, idx);
		phdr.p_align = read_32(tmp, idx);

		return phdr;
	endfunction
	
	function Elf32_Shdr read_shdr(int fd, int offset);
		Elf32_Shdr shdr;
		int code, idx=0;
		bit[7:0] tmp[] = new[Elf32_Shdr_SZ];
		bit[7:0] tmp_b;
		
		void'($fseek(fd, offset, 0));
		
		for (int i=0; i<Elf32_Shdr_SZ; i++) begin
			code = $fread(tmp_b, fd);
			tmp[i] = tmp_b;
		end

		shdr.sh_name = read_32(tmp, idx);
		shdr.sh_type = read_32(tmp, idx);
		shdr.sh_flags = read_32(tmp, idx);
		shdr.sh_addr = read_32(tmp, idx);
		shdr.sh_offset = read_32(tmp, idx);
		shdr.sh_size = read_32(tmp, idx);
		shdr.sh_link = read_32(tmp, idx);
		shdr.sh_info = read_32(tmp, idx);
		shdr.sh_addralign = read_32(tmp, idx);
		shdr.sh_entsize = read_32(tmp, idx);

		return shdr;
	endfunction

	task load(string filename);
		ElfHeader hdr;
		Elf32_Phdr phdr;
		Elf32_Shdr shdr;
		int fd = $fopen(filename, "rb");
		
		if (fd == -1) begin
			m_comp.uvm_report_fatal(ID, 
				$psprintf("Failed to open file %0s", filename));
			return;
		end
	
		hdr = read_hdr(fd);
		
		if (hdr.e_ident[1] != "E" ||
			hdr.e_ident[2] != "L" ||
			hdr.e_ident[3] != "F") begin
			m_comp.uvm_report_fatal(ID, 
				$psprintf("File %0s is invalid", filename));
			return;
		end
	
		// TODO: Make this configurable?
//		if (hdr.e_machine != 40) begin
//			m_comp.uvm_report_fatal(ID, 
//				$psprintf("File %0s has invalid e_machine", filename));
//			return;
//		end
		
		for (int i=0; i<hdr.e_phnum; i++) begin
			phdr = read_phdr(fd, hdr.e_phoff+hdr.e_phentsize*i);
				m_comp.uvm_report_info(ID, 
					$psprintf("Loading %0d bytes @ 'h%08h..'h%08h (vaddr='h%08h)",
						phdr.p_filesz, phdr.p_paddr, (phdr.p_paddr+phdr.p_filesz),
						phdr.p_vaddr), 
					UVM_MEDIUM);			
			
			load_phdr(fd, phdr);
		end
		/*
		 */

		for (int i=0; i<hdr.e_shnum; i++) begin
			shdr = read_shdr(fd, hdr.e_shoff + hdr.e_shentsize*i);
		
//			if (shdr.sh_type == SHT_PROGBITS && shdr.sh_size != 0 &&
//				(shdr.sh_flags & SHF_ALLOC) != 0) begin
//				if (m_load_ram || (shdr.sh_flags & SHF_WRITE) == 0) begin
//
//					m_comp.uvm_report_info(ID, 
//							$psprintf("Loading %0d bytes @ 'h%08h..'h%08h",
//								shdr.sh_size, shdr.sh_addr, (shdr.sh_addr+shdr.sh_size)), 
//							UVM_MEDIUM);
//					load_section(fd, shdr);
//				end else begin
//					m_comp.uvm_report_info(ID, 
//							$psprintf("[Skip] Loading %0d bytes @ 'h%08h..'h%08h",
//								shdr.sh_size, shdr.sh_addr, (shdr.sh_addr+shdr.sh_size)), 
//							UVM_MEDIUM);
//				end
//			end
	
			if (shdr.sh_type == SHT_NOBITS && shdr.sh_size != 0) begin
				if (m_do_fill) begin
					m_comp.uvm_report_info(ID, 
							$psprintf("Fill %0d bytes @ 'h%08h..'h%08h",
								shdr.sh_size, shdr.sh_addr, (shdr.sh_addr+shdr.sh_size)),
							UVM_MEDIUM);
					for (int j=0; j<shdr.sh_size; j+=4) begin
						m_mem_if.write32(shdr.sh_addr+j, 0);
					
						if (j+4 >= shdr.sh_size) begin
							m_comp.uvm_report_info(ID, 
									$psprintf("Fill last addr='h%08h", shdr.sh_addr+j), UVM_MEDIUM);
						end
					end
				end else begin
					m_comp.uvm_report_info(ID, 
							$psprintf("[Skip] Fill %0d bytes @ 'h%08h..'h%08h",
								shdr.sh_size, shdr.sh_addr, (shdr.sh_addr+shdr.sh_size)),
							UVM_MEDIUM);
				end
			end
		end

		$fclose(fd);
	endtask
		
	task load_section(int fd, Elf32_Shdr shdr);
		// read in data
		bit [7:0] tmp[4]; // new[shdr.sh_size];
		bit [7:0] tmp_b;
		bit [31:0] data;
		int off = 0, ret;	
		void'($fseek(fd, shdr.sh_offset, 0));
			
		for (int off=0; off<shdr.sh_size; off+=4) begin
			for (int j=0; j<4; j++) begin
				ret = $fread(tmp_b, fd);
				if (ret <= 0) begin
					m_comp.uvm_report_fatal(ID,
							$psprintf("Read error %0d @ %0d %0d",
								ret, shdr.sh_offset+off, $ftell(fd)));
				end
				tmp[j] = tmp_b;
			end

			// Copy data to memory
			if (m_big_endian) begin
				data[7:0]   = tmp[0];
				data[15:8]  = tmp[1];
				data[23:16] = tmp[2];
				data[31:24] = tmp[3];
			end else begin
				data[7:0]   = tmp[3];
				data[15:8]  = tmp[2];
				data[23:16] = tmp[1];
				data[31:24] = tmp[0];
			end

			m_mem_if.write32(shdr.sh_addr+off, data);
			if (off+4 >= shdr.sh_size) begin
				m_comp.uvm_report_info(ID, 
						$psprintf("Load last addr='h%08h", shdr.sh_addr+off), UVM_MEDIUM);
			end	
		end
	endtask

	task load_phdr(int fd, Elf32_Phdr phdr);
		// read in data
		bit [7:0] tmp[4]; // new[shdr.sh_size];
		bit [7:0] tmp_b;
		bit [31:0] data;
		int off = 0, ret;	
		void'($fseek(fd, phdr.p_offset, 0));
			
		for (int off=0; off<phdr.p_filesz; off+=4) begin
			for (int j=0; j<4; j++) begin
				ret = $fread(tmp_b, fd);
				if (ret <= 0) begin
					m_comp.uvm_report_fatal(ID,
							$psprintf("Read error %0d @ %0d %0d",
								ret, phdr.p_offset+off, $ftell(fd)));
				end
				tmp[j] = tmp_b;
			end

			// Copy data to memory
			if (m_big_endian) begin
				data[7:0]   = tmp[0];
				data[15:8]  = tmp[1];
				data[23:16] = tmp[2];
				data[31:24] = tmp[3];
			end else begin
				data[7:0]   = tmp[3];
				data[15:8]  = tmp[2];
				data[23:16] = tmp[1];
				data[31:24] = tmp[0];
			end

			m_mem_if.write32(phdr.p_paddr+off, data);
			if (off+4 >= phdr.p_filesz) begin
				m_comp.uvm_report_info(ID, 
						$psprintf("Load last addr='h%08h", phdr.p_paddr+off), UVM_MEDIUM);
			end	
		end
	endtask
	
endclass
