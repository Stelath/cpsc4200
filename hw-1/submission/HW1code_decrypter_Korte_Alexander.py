key = {
    'a': 'c',
    'b': 'i',
    'c': 'o',
    'd': 'v',
    'e': 'y',
    'f': 'b',
    'g': 'l',
    'h': 'k',
    'i': 'f',
    'j': 't',
    'k': 'q',
    'l': 'm',
    'm': 'a',
    'n': 'd',
    'o': 'x',
    'p': 'h',
    'q': 'p',
    'r': 's',
    's': 'j',
    't': 'n',
    'u': 'u',
    'v': 'r',
    'w': 'g',
    'x': 'e',
    'y': 'w',
    'z': 'z',
}

def decrypt(cipher: str, key: dict[str, str]) -> str:
    decrypted = []
    for char in cipher:
        if char.lower() in key:
            new_char = key[char.lower()]
            if char.isupper():
                new_char = new_char.upper()
            decrypted.append(new_char)
        else:
            decrypted.append(char)
    return "".join(decrypted)

if __name__ == "__main__":
    with open("cipher.txt", "r", encoding="utf-8") as f:
        cipher_text = f.read()
    
    plain_text = decrypt(cipher_text, key)
    print(plain_text)