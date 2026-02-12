#!/usr/bin/env bash
# Check if terminal is sending escape sequences or signals on H/y

echo "=== Terminal Key Check ==="
echo ""
echo "1. Check iTerm2 Key Mappings:"
echo "   iTerm2 → Settings → Keys → Key Mappings"
echo "   Look for 'H' or 'y' entries"
echo "   Remove any that send 'Text' or 'Hex Code'"
echo ""
echo "2. Test what H sends:"
echo "   Run: cat -v"
echo "   Press H, then Ctrl+D"
echo "   If you see escape sequences (^[ or similar), that's the problem"
echo ""
echo "3. Check shell functions:"
if command -v type >/dev/null 2>&1; then
  type H 2>/dev/null || echo "   No function 'H' found"
  type y 2>/dev/null || echo "   No function 'y' found"
fi
echo ""
echo "4. Test clipboard access:"
if command -v pbcopy >/dev/null 2>&1; then
  echo "test" | pbcopy && echo "   Clipboard OK" || echo "   Clipboard FAILED"
else
  echo "   pbcopy not found"
fi
echo ""
echo "5. Test nvim with minimal config:"
echo "   nvim -u NONE"
echo "   Then press H and y - do they still cause kill?"
