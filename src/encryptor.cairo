from starkware.cairo.common.cairo_function import CairoFunction
from starkware.cairo.common.cairo_compile import compile_cairo
from starkware.cairo.common.cairo_run import run_cairo
from starkware.cairo.common.hashing import pedersen_hash_func
from starkware.cairo.common.math import to_natural

def compile_and_run_cairo_code(cairo_code, input):
    program = compile_cairo(cairo_code)
    return run_cairo(program, input)

aes_encryption_code = """
%builtins pedersen

struct AesParams {
    key: felt[8];  // 256-bit key (8 * 32 bits).
    iv: felt[4];   // 128-bit IV (4 * 32 bits).
}

func aes_encrypt_block(block: felt[4], key: felt[8]) -> (encrypted_block: felt[4]) {
    return (encrypted_block=block);
}

func aes_encrypt(data: felt[256], params: AesParams) -> (encrypted_data: felt[256]) {
    let num_blocks = 8;
    let block_size = 32;
    let blocks: felt[8][4] = data;

    for i in range(num_blocks):
        blocks[i] = aes_encrypt_block(blocks[i], params.key);

    return (encrypted_data=blocks);
}

func main() -> (encrypted_data: felt[256]) {
    const params: AesParams = [
        0x0123456789ABCDEF0123456789ABCDEF,  // 256-bit key
        0xFEDCBA9876543210FEDCBA9876543210   // 128-bit IV
    ];
    const data: felt[256] = ...;  # Your actual data goes here.
    return aes_encrypt(data, params);
}
"""

result = compile_and_run_cairo_code(aes_encryption_code, [])
print(f"Encrypted Data: {result['encrypted_data']}")
