#![no_std]
#![no_main]

const _: &[u8] = include_bytes!("../memory.ld");

#[panic_handler]
fn panic(_: &core::panic::PanicInfo) -> ! {
    unsafe { core::arch::asm!("ud2", options(noreturn)) }
}

core::arch::global_asm!(r#"
    .globl _start
    .pushsection .text
    _start:
        push rbp
        jmp {entry_point}
    .popsection
    "#,
    entry_point = sym entry_point,
);

pub struct Struct {
    field: u32
}

#[no_mangle]
#[link_section = ".extra"]
static mut STRUCT: Struct = Struct { field: 0 };

#[no_mangle]
static mut INT: u32 = 0;

unsafe fn print_self_maps() {
    let Ok(fd) = polkavm_linux_raw::sys_open(core::ffi::CStr::from_bytes_with_nul_unchecked(b"/proc/self/maps\0"), 0) else { return };
    let stdout = polkavm_linux_raw::FdRef::from_raw_unchecked(1);
    let mut buffer: core::mem::MaybeUninit<[u8; 1024]> = core::mem::MaybeUninit::uninit();
    loop {
        match polkavm_linux_raw::sys_read_raw(fd.borrow(), buffer.as_mut_ptr().cast(), 1024) {
            Ok(0) | Err(_) => break,
            Ok(length) => {
                let slice = core::slice::from_raw_parts(buffer.as_ptr().cast::<u8>(), length);
                let _ = polkavm_linux_raw::sys_write(stdout, slice);
            }
        }
    }
}

unsafe extern "C" fn entry_point() {
    print_self_maps();

    core::arch::asm!(r#"
            mov dword ptr [{foo}], 0x123
            mov dword ptr [{bar}], 0x456
            mov rax, 0x3c
            mov rdi, 0
            syscall
        "#,
        foo = in(reg) &mut INT,
        bar = in(reg) &mut STRUCT.field,
        options(noreturn)
    );
}
