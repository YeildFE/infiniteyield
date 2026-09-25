#!/usr/bin/env python3
"""
Infinite Yield modular split - rebuild / verify tool.

Reads tools/manifest.json, concatenates the module files in load order and:
  1. byte-compares the result against the original monolithic source
     (verification that the split lost / duplicated / moved nothing), or
  2. writes the result to a single-file bundle with --out <path>.

Usage:
  python rebuild.py                     # verify against original
  python rebuild.py --out bundle.lua    # emit single-file bundle
"""
import argparse
import hashlib
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
SRC_ROOT = os.path.normpath(os.path.join(HERE, "..", "src"))
MANIFEST = os.path.join(HERE, "manifest.json")
ORIGINAL = "/home/z/my-project/upload/source.txt"  # adjust if moved


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", help="write single-file bundle to this path")
    args = ap.parse_args()

    manifest = json.load(open(MANIFEST, encoding="utf-8"))
    order = manifest["load_order"]

    parts = []
    total_lines = 0
    for rel in order:
        p = os.path.join(SRC_ROOT, rel)
        with open(p, encoding="utf-8", newline="") as fh:
            content = fh.read()
        if not content.endswith("\n"):
            print(f"WARN: {rel} missing trailing newline")
        parts.append(content)
        total_lines += content.count("\n")
    rebuilt = "".join(parts)

    print(f"modules        : {len(order)}")
    print(f"rebuilt lines  : {total_lines}")
    print(f"rebuilt sha256 : {hashlib.sha256(rebuilt.encode()).hexdigest()}")

    if args.out:
        with open(args.out, "w", encoding="utf-8", newline="") as fh:
            fh.write(rebuilt)
        print(f"bundle written -> {args.out}")
        return

    if not os.path.exists(ORIGINAL):
        print(f"original source not found at {ORIGINAL} - cannot byte-verify")
        sys.exit(2)

    with open(ORIGINAL, encoding="utf-8", newline="") as fh:
        original = fh.read()

    if rebuilt == original:
        print("original sha256: " + hashlib.sha256(original.encode()).hexdigest())
        print("RESULT: BYTE-IDENTICAL - the modular split is lossless")
    else:
        print(f"original  lines: {original.count(chr(10))}")
        print("RESULT: MISMATCH - modules were edited or the split is broken")
        # locate first difference
        n = min(len(rebuilt), len(original))
        for i in range(n):
            if rebuilt[i] != original[i]:
                print(f"first difference at byte {i}")
                print("  rebuilt:", repr(rebuilt[max(0, i - 40):i + 40]))
                print("  original:", repr(original[max(0, i - 40):i + 40]))
                break
        else:
            print(f"one side is a prefix of the other (len {len(rebuilt)} vs {len(original)})")
        sys.exit(1)


if __name__ == "__main__":
    main()
