#include <stdio.h>
#include <openssl/bn.h>
#include <string.h>

void printBN(char *msg, BIGNUM * a)
{
    /* Use BN_bn2hex(a) for hex string
     * Use BN_bn2dec(a) for decimal string */
    char * number_str = BN_bn2hex(a);
    printf("%s %s\n", msg, number_str);
    OPENSSL_free(number_str);
}

int main()
{
    BN_CTX *ctx = BN_CTX_new();
    BIGNUM *n = BN_new();
    BIGNUM *e = BN_new();
    BIGNUM *d = BN_new();
    BIGNUM *message = BN_new();
    BIGNUM *ciphertext = BN_new();
    BIGNUM *decrypted = BN_new();

    BN_hex2bn(&n, "DCBFFE3E51F62E09CE7032E2677A78946A849DC4CDDE3A4D0CB81629242FB1A5");
    BN_hex2bn(&e, "010001");
    BN_hex2bn(&d, "74D806F9F3A62BAE331FFE3F0A68AFE35B3D2E4794148AACBC26AA381CD7D30D");

    // Hex for "A top secret!"
    BN_hex2bn(&message, "4120746f702073656372657421");

    // Encryption: message^e mod n
    BN_mod_exp(ciphertext, message, e, n, ctx);
    printBN("Ciphertext (C = M^e mod n):", ciphertext);

    // Decryption: ciphertext^d mod n
    BN_mod_exp(decrypted, ciphertext, d, n, ctx);
    printBN("Decrypted (C^d mod n):", decrypted);
    
    if (BN_cmp(message, decrypted) == 0) {
        printf("Message encrypted succesfully\n");
    } else {
        printf("Message encrypted unsuccesfully\n");
    }

    // Free memory
    BN_CTX_free(ctx);
    BN_free(n);
    BN_free(e);
    BN_free(d);
    BN_free(message);
    BN_free(ciphertext);
    BN_free(decrypted);

    return 0;
}