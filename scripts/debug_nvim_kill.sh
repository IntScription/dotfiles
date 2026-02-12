#!/usr/bin/env bash
# Debug script to see what happens when H or y is pressed in nvim

echo "=== Debugging nvim H/y kill issue ==="
echo ""
echo "1. Checking terminal key mappings..."
echo "   Run this in iTerm2: iTerm2 → Settings → Keys → Key Mappings"
echo "   Look for entries with 'H' or 'y' that send text/hex"
echo ""
echo "2. Testing if H sends escape sequence..."
echo "   Press H and check what hex codes are sent:"
stty -echo
echo -n "Press H now (then Enter): "
read -n 1 key
echo ""
stty echo
echo "   Key pressed: '$key'"
echo ""
echo "3. Checking shell functions/aliases..."
if command -v alias >/dev/null 2>&1; then
  echo "   Aliases containing H or y:"
  alias | grep -iE '[^[:alnum:]_](H|y)[^[:alnum:]_]' || echo "   None found"
fi
echo ""
echo "4. Testing nvim with minimal config..."
echo "   Run: nvim -u NONE"
echo "   Then press H and y - do they still cause kill?"
echo ""
echo "5. Check nvim mappings..."
echo "   In nvim, run: :verbose map H"
echo "   And: :verbose map y"
echo ""
echo "6. Check if clipboard access causes issues..."
echo "   Run: pbcopy < /dev/null && echo 'Clipboard OK' || echo 'Clipboard issue'"
