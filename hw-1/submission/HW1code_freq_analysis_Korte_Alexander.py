from argparse import ArgumentParser
from collections import Counter


def print_freq(title: str, data: dict[str, int], top: int = 30) -> None:
    all_items = sorted(data.items(), key=lambda kv: (-kv[1], kv[0])) # Sort from greatest to least, weird ahh lambda but it works
    if top is not None and top > 0:  # Quick way for us to ignore "top"
        shown_items = all_items[:top]
    else:
        shown_items = all_items
        top = len(shown_items)

    showing_counter = f" (showing {len(shown_items)}/{len(all_items)})"
    print(f"\n{title}{showing_counter}")
    print("-" * (len(title) + len(showing_counter)))

    cols = 3
    rows = (len(shown_items) + cols - 1) // cols
    items = []
    for k, v in shown_items:
        items.append(f"{k}:{v}")

    # Reorganize into columns and print (added this cause it was spamming my terminal)
    for r in range(rows):
        line = []
        for c in range(cols):
            idx = r + c * rows
            if idx < len(items):
                line.append(items[idx])
        print("\t".join(line))


def freq_counter(text: str) -> dict[str, int]:
    text = "".join([c for c in text if c.isalpha()])
    letter_frequency = Counter(text)

    return dict(letter_frequency)


def ngram_counter(text: str, n: int) -> dict[str, int]:
    ngrams = [text[i : i + n] for i in range(len(text) - n + 1)]
    ngrams = [ngram for ngram in ngrams if " " not in ngram] # Ignore ngrams with spaces
    ngram_frequency = Counter(ngrams)

    return dict(ngram_frequency)


def get_argparser() -> ArgumentParser:
    parser = ArgumentParser(description="Frequency Counter")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--text", type=str, help="Text to analyze directly")
    group.add_argument("--file", type=str, help="Path to a .txt file to analyze")
    parser.add_argument(
        "--ngram", type=int, help="Max N-gram size for analysis", default=3
    )
    return parser


def main():
    parser = get_argparser()
    args = parser.parse_args()

    if args.file:
        with open(args.file, "r", encoding="utf-8") as f:
            text = f.read()
    else:
        text = args.text

    text = text.lower()
    text = text.replace("\n", " ").replace("\r", " ").replace("\t", " ")

    result = freq_counter(text)
    print_freq("Character Frequency", result, top=-1)

    for i in range(2, args.ngram + 1):
        ngram_result = ngram_counter(text, i)
        print_freq(f"{i}-gram Frequency", ngram_result, top=30)


if __name__ == "__main__":
    main()
